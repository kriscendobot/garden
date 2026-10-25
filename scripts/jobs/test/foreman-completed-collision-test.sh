#!/bin/bash
# foreman-completed-collision-test.sh — a completed basename proposed by the
# foreman is a healthy, visible no-op rather than a fatal post-job rc=79.
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
  local now="$1"
  env GARDEN=okhost GARDEN_STATE="$STATE" HOME="$TR" \
    JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
    GARDEN_FOREMAN_NOW="$now" GARDEN_FOREMAN_IDLE_SETTLE=0 \
    GARDEN_FOREMAN_ACTIVE_TARGET=1 \
    GARDEN_FOREMAN_HANDLER="$HERE/foreman-stub.sh" \
    GARDEN_FOREMAN_STUB_BASE="$BASE" \
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

echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
