#!/bin/bash
# Verify stale recurring dispatches retire instead of requeueing/splitting when a
# newer dispatch from the same interchangeable schedule is already on the board.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
# shellcheck source=test-tmpdir.sh
source "$HERE/test-tmpdir.sh"

unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_)' || true) 2>/dev/null || true
TR="$(mktemp -d "$(garden_test_exec_tmpdir)/reaper-scheduled-supersede.XXXXXXXX")"
trap 'rm -rf "$TR"' EXIT
BARE="$TR/journal.git"
SEED="$TR/seed"
VERIFY="$TR/verify"
BRANCH=journal2
git_id=(-c user.name=test -c user.email=test@localhost)

git init -q --bare "$BARE"
git init -q "$SEED"
git -C "$SEED" checkout -q -b "$BRANCH"
mkdir -p "$SEED"/{jobs/{todo,doin,plan,tada},work,inbox,schedules}
touch "$SEED"/jobs/{todo,doin,plan,tada}/.gitkeep "$SEED"/work/.gitkeep "$SEED"/inbox/.gitkeep "$SEED"/schedules/.gitkeep
git -C "$SEED" add -A
git -C "$SEED" "${git_id[@]}" commit -q -m seed

add_schedule() { # <name> [interchangeable]
  local name="$1" interchangeable="${2:-}"
  {
    printf 'cadence: hourly\nlast_dispatched: 2026-10-14T09:00:00Z\njob_basename_prefix: %s\n' "$name"
    [ -n "$interchangeable" ] && printf 'interchangeable: %s\n' "$interchangeable"
    printf -- '---\nrun %s\n' "$name"
  } > "$SEED/schedules/$name.md"
  git -C "$SEED" add "schedules/$name.md"
  git -C "$SEED" "${git_id[@]}" commit -q -m "configure $name"
}

dispatch_old_and_claim() { # <schedule> <base>
  local schedule="$1" base="$2"
  printf 'scheduled work for %s\n' "$schedule" > "$SEED/jobs/todo/$base.md"
  mkdir -p "$SEED/jobs/bids/$base"
  printf 'bid for %s\n' "$base" > "$SEED/jobs/bids/$base/test-bidder.md"
  git -C "$SEED" add "jobs/todo/$base.md"
  git -C "$SEED" add "jobs/bids/$base/test-bidder.md"
  git -C "$SEED" "${git_id[@]}" commit -q -m "schedule($schedule) dispatched $base -> todo"
  git -C "$SEED" mv "jobs/todo/$base.md" "jobs/doin/$base.md"
  {
    printf '\n<!-- garden-deadline-overrun: 1 -->\n'
    printf -- '---\nclaim:\n  host: oldhost\n  gardener: 1\n  claimed_at: 2020-01-01T00:00:00Z\n'
  } >> "$SEED/jobs/doin/$base.md"
  printf 'worktree_dir: %s\n' "$TR/nonexistent-$base" > "$SEED/work/$base"
  mkdir -p "$SEED/inbox/$base/unread" "$SEED/inbox/$base/read"
  touch "$SEED/inbox/$base/unread/.gitkeep" "$SEED/inbox/$base/read/.gitkeep"
  git -C "$SEED" add -A
  git -C "$SEED" "${git_id[@]}" commit -q -m "claim($base) by oldhost/gardener-1"
}

dispatch_new() { # <schedule> <base> <todo|doin|tada>
  local schedule="$1" base="$2" lane="$3" tada_path
  printf 'new scheduled work for %s\n' "$schedule" > "$SEED/jobs/todo/$base.md"
  git -C "$SEED" add "jobs/todo/$base.md"
  git -C "$SEED" "${git_id[@]}" commit -q -m "schedule($schedule) dispatched $base -> todo"
  case "$lane" in
    todo) ;;
    doin)
      git -C "$SEED" mv "jobs/todo/$base.md" "jobs/doin/$base.md"
      printf '\n---\nclaim:\n  host: newhost\n  gardener: 2\n  claimed_at: 2026-10-14T09:00:00Z\n' >> "$SEED/jobs/doin/$base.md"
      git -C "$SEED" add -A
      git -C "$SEED" "${git_id[@]}" commit -q -m "claim($base) by newhost/gardener-2"
      ;;
    tada)
      tada_path="jobs/tada/2026/10/14/$base.md"
      mkdir -p "$SEED/$(dirname "$tada_path")"
      git -C "$SEED" mv "jobs/todo/$base.md" "$tada_path"
      git -C "$SEED" add -A
      git -C "$SEED" "${git_id[@]}" commit -q -m "tada($base) done newhost/gardener-2"
      ;;
  esac
}

add_schedule todo-family
dispatch_old_and_claim todo-family todo-family-20261013-010000
dispatch_new todo-family todo-family-20261014-010000 todo

add_schedule doin-family
dispatch_old_and_claim doin-family doin-family-20261013-020000
dispatch_new doin-family doin-family-20261014-020000 doin

add_schedule tada-family
dispatch_old_and_claim tada-family tada-family-20261013-030000
dispatch_new tada-family tada-family-20261014-030000 tada

add_schedule preserve-family false
dispatch_old_and_claim preserve-family preserve-family-20261013-040000
dispatch_new preserve-family preserve-family-20261014-040000 todo

git -C "$SEED" remote add origin "$BARE"
git -C "$SEED" push -q -u origin "$BRANCH"

export JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH"
export GARDEN=testhost GARDEN_STATE="$TR/state" GARDEN_TEST=1
export GARDEN_REAP_PUSH_ATTEMPTS=20 GARDEN_POST_ATTEMPTS=20
export GARDEN_CLAIM_TTL=3600 GARDEN_REAP_MAX_PER_TICK=8
"$JOBS/reaper.sh" > "$TR/reaper.log" 2>&1

git clone -q --single-branch --branch "$BRANCH" "$BARE" "$VERIFY"
fail=0
for family in todo doin tada; do
  case "$family" in todo) hour=01 ;; doin) hour=02 ;; tada) hour=03 ;; esac
  old="$family-family-20261013-${hour}0000"
  report="$(find "$VERIFY/jobs/tada" -type f -name "$old.md" -print -quit)"
  [ -n "$report" ] || { echo "FAIL: $old did not reach tada"; fail=1; continue; }
  grep -q '^status: superseded$' "$report" || { echo "FAIL: $old lacks superseded status"; fail=1; }
  grep -q "^superseded_by: '$family-family-20261014-0" "$report" || { echo "FAIL: $old lacks newer dispatch identity"; fail=1; }
  [ ! -e "$VERIFY/jobs/todo/$old.md" ] || { echo "FAIL: $old was requeued"; fail=1; }
  [ ! -e "$VERIFY/jobs/plan/$old.md" ] || { echo "FAIL: $old was split/parked"; fail=1; }
  [ ! -e "$VERIFY/jobs/doin/$old.md" ] || { echo "FAIL: $old remains claimed"; fail=1; }
  [ ! -d "$VERIFY/jobs/bids/$old" ] || { echo "FAIL: $old bid directory remains"; fail=1; }
done

preserve_old=preserve-family-20261013-040000
[ -f "$VERIFY/jobs/todo/$preserve_old.md" ] || { echo "FAIL: non-interchangeable run was not requeued to split"; fail=1; }
[ -d "$VERIFY/jobs/bids/$preserve_old" ] || { echo "FAIL: non-superseded run lost its bid directory"; fail=1; }
grep -q '^role: orchestrator$' "$VERIFY/jobs/todo/$preserve_old.md" \
  || { echo "FAIL: non-interchangeable overrun did not retain split behavior"; fail=1; }
if find "$VERIFY/jobs/tada" -type f -name "$preserve_old.md" -print -quit | grep -q .; then
  echo "FAIL: non-interchangeable run was superseded"
  fail=1
fi

grep -q "retired 3 superseded scheduled claim(s)" "$TR/reaper.log" \
  || { echo "FAIL: reaper summary did not report three supersessions"; fail=1; }

if [ "$fail" -eq 0 ]; then
  echo "PASS: newer todo/doin/tada dispatches supersede stale interchangeable runs; interchangeable=false preserves split behavior"
fi
exit "$fail"
