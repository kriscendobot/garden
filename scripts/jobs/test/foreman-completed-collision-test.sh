#!/bin/bash
# foreman-completed-collision-test.sh — a completed basename proposed by the
# foreman is a healthy, visible no-op rather than a fatal post-job rc=79; the
# foreman re-prompts once with the base excluded and notes the maintainer only
# when that replacement is absent or also invalid.
#
# Hermetic: a throwaway bare journal; no real garden, journal, or network.

set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }

# A live gardener may carry fleet configuration in its environment. Keep every
# board and host-local write inside this fixture.
# shellcheck disable=SC2046
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true
export GARDEN_TEST=1

TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-foreman-collision.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
BARE="$TR/journal.git"
SEED="$TR/seed"
STATE="$TR/state"
BASE=already-completed-step
BRANCH=journal2

git init -q --bare "$BARE"
git init -q "$SEED"
git -C "$SEED" checkout -q -b "$BRANCH"
(
  cd "$SEED"
  mkdir -p jobs/todo jobs/doin jobs/tada/2026/10/24 jobs/plan work repos msgs \
    hosts entries schedules cursors config inbox/maintainer/unread inbox/maintainer/read
  for d in jobs/todo jobs/doin jobs/plan work repos msgs hosts entries schedules \
    cursors config inbox/maintainer/unread inbox/maintainer/read; do
    touch "$d/.gitkeep"
  done
  printf '# completed\n' > "jobs/tada/2026/10/24/$BASE.md"
)
git -C "$SEED" add -A
git -C "$SEED" -c user.name=test -c user.email=test@localhost commit -q -m seed
git -C "$SEED" remote add origin "$BARE"
git -C "$SEED" push -q -u origin "$BRANCH"
mkdir -p "$STATE/foreman"
printf '%s\n' previously-posted-step > "$STATE/foreman/last-step"

tick() {
  local now="$1"; shift
  env GARDEN=okhost GARDEN_STATE="$STATE" HOME="$TR" \
    JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
    GARDEN_FOREMAN_NOW="$now" GARDEN_FOREMAN_IDLE_SETTLE=0 \
    GARDEN_FOREMAN_ACTIVE_TARGET=1 \
    GARDEN_FOREMAN_HANDLER="$HERE/foreman-stub.sh" \
    GARDEN_FOREMAN_STUB_BASE="$BASE" "$@" \
    "$JOBS/foreman.sh" >"$TR/tick-$now.log" 2>&1
}

echo "================================================================"
echo "FOREMAN COMPLETED-BASENAME COLLISION"
echo "================================================================"

tick 1000 # establish the below-target settle marker
if tick 1001; then
  ok "a foreman pump whose base collides with tada/ exits 0"
else
  bad "the completed collision escaped as a failed foreman tick"
fi

tree="$(git -C "$BARE" ls-tree -r --name-only "$BRANCH")"
if ! grep -qx "jobs/todo/$BASE.md" <<<"$tree"; then
  ok "the completed base was not posted back into todo/"
else
  bad "the completed base was re-posted into todo/"
fi

if [ "$(cat "$STATE/foreman/last-step")" = previously-posted-step ]; then
  ok "the refused proposal did not overwrite LAST_STEP"
else
  bad "LAST_STEP changed for a proposal that was not posted"
fi

if grep -q "guard=completed-collision base=$BASE" "$STATE/foreman/decisions.log"; then
  ok "the collision is recorded as a completed-collision decision"
else
  bad "decisions.log lacks the completed-collision disposition"
fi

if grep -q "next milestone step '$BASE' collides with a completed job; not posted" "$TR/tick-1001.log"; then
  ok "the collision is logged"
else
  bad "the foreman log does not explain the completed collision"
fi

# Re-proposal on a later eligible tick stays healthy, while note_once retains one
# maintainer surface for this base.
tick 1002 || bad "a repeated completed collision failed the foreman tick"
VERIFY="$TR/verify"
git clone -q --single-branch --branch "$BRANCH" "$BARE" "$VERIFY" 2>/dev/null
notice_count="$(find "$VERIFY/inbox/maintainer/unread" -maxdepth 1 -type f -name '*.md' | wc -l)"
if [ "$notice_count" -eq 1 ] && grep -Rqs "proposed next step '$BASE' is already completed" "$VERIFY/inbox/maintainer/unread"; then
  ok "the completed collision is surfaced to the maintainer once"
else
  bad "expected one completed-collision maintainer note, found $notice_count"
fi

notices() { # <verify-dir>
  find "$1/inbox/maintainer/unread" -maxdepth 1 -type f -name '*.md' | wc -l
}

echo "--- the re-prompt yields a valid replacement: posted, no maintainer note"
STATE="$TR/state-replace"; mkdir -p "$STATE/foreman"
printf '%s\n' previously-posted-step > "$STATE/foreman/last-step"
tick 2000
tick 2001 GARDEN_FOREMAN_STUB_DIGEST="$TR/first-digest" \
  GARDEN_FOREMAN_STUB_RETRY_BASE=fresh-replacement-step \
  GARDEN_FOREMAN_STUB_RETRY_DIGEST="$TR/retry-digest" || bad "the replacement tick failed"
if grep -qx '  already-completed-step' "$TR/first-digest" && grep -q '^completed_job_bases: |' "$TR/first-digest"; then
  ok "the handler digest lists the completed job bases"
else
  bad "the handler digest lacks completed_job_bases"
fi
if grep -qx "rejected_completed_base: $BASE" "$TR/retry-digest"; then
  ok "the re-prompt digest names the rejected completed base"
else
  bad "the re-prompt digest does not exclude the rejected base"
fi
tree="$(git -C "$BARE" ls-tree -r --name-only "$BRANCH")"
if grep -qx "jobs/todo/fresh-replacement-step.md" <<<"$tree"; then
  ok "the replacement proposal was posted"
else
  bad "the replacement proposal was not posted"
fi
if [ "$(cat "$STATE/foreman/last-step")" = fresh-replacement-step ]; then
  ok "LAST_STEP records the replacement"
else
  bad "LAST_STEP does not record the replacement"
fi
if grep -q "guard=pumped base=fresh-replacement-step.* replaced=$BASE" "$STATE/foreman/decisions.log"; then
  ok "the pump decision records the replaced base"
else
  bad "decisions.log lacks the replaced pump"
fi
rm -rf "$VERIFY"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$VERIFY" 2>/dev/null
if [ "$(notices "$VERIFY")" -eq "$notice_count" ]; then
  ok "a successful replacement sends no maintainer note"
else
  bad "a successful replacement still noted the maintainer"
fi

echo "--- the re-prompt yields nothing: one maintainer note"
STATE="$TR/state-absent"; mkdir -p "$STATE/foreman"
printf '%s\n' previously-posted-step > "$STATE/foreman/last-step"
CALLS="$TR/absent-calls"
# fresh-replacement-step is now in flight; leave room below the target.
tick 3000 GARDEN_FOREMAN_ACTIVE_TARGET=2
tick 3001 GARDEN_FOREMAN_ACTIVE_TARGET=2 GARDEN_FOREMAN_STUB_RETRY_BASE=none GARDEN_FOREMAN_STUB_CALLS="$CALLS" \
  || bad "the absent-replacement tick failed"
if [ "$(wc -l < "$CALLS")" -eq 2 ]; then
  ok "the re-prompt is bounded to one extra handler call"
else
  bad "expected 2 handler calls, saw $(wc -l < "$CALLS")"
fi
rm -rf "$VERIFY"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$VERIFY" 2>/dev/null
if [ "$(notices "$VERIFY")" -eq $((notice_count + 1)) ]; then
  ok "an absent replacement surfaces the collision once"
else
  bad "expected one new note for an absent replacement, found $(( $(notices "$VERIFY") - notice_count ))"
fi

echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
