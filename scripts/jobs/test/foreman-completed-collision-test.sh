#!/bin/bash
# foreman-completed-collision-test.sh — foreman occurrence identity comes from
# normalized milestone context: an old tada basename does not block a fresh
# recurrence, an unchanged delivered decision dedups, and changed context can
# post the same deterministic basename again. Malformed/duplicate proposals keep
# the bounded one-reprompt fallback.

set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }

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
  mkdir -p jobs/todo jobs/doin jobs/tada/2026/10/24 jobs/plan jobs/index \
    plan/milestones plan/designs work repos msgs hosts entries schedules cursors \
    config inbox/maintainer/unread inbox/maintainer/read
  for d in jobs/todo jobs/doin jobs/plan jobs/index plan/designs work repos msgs \
    hosts entries schedules cursors config inbox/maintainer/unread inbox/maintainer/read; do
    touch "$d/.gitkeep"
  done
  printf '# completed old occurrence\n' > "jobs/tada/2026/10/24/$BASE.md"
  printf '%s\n' '---' 'status: active' '---' '# M1' > plan/milestones/M1.md
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

tree() { git -C "$BARE" ls-tree -r --name-only "$BRANCH"; }
index_identities() {
  local path
  while read -r path; do
    git -C "$BARE" show "$BRANCH:$path" 2>/dev/null | sed -n 's/^identity:[[:space:]]*//p'
  done < <(tree | grep '^jobs/index/' || true)
}

echo "================================================================"
echo "FOREMAN DECISION IDENTITY"
echo "================================================================"

tick 1000 # establish settle marker
tick 1001 || bad "fresh recurrence tick failed"
if tree | grep -qx "jobs/todo/$BASE.md"; then
  ok "a fresh recurrence reuses the deterministic basename despite old tada/"
else
  bad "fresh recurrence was swallowed by the completed basename"
fi
first_identity="$(index_identities | head -1)"
if [[ "$first_identity" =~ ^foreman-decision:[0-9a-f]{24}$ ]]; then
  ok "the posted recurrence carries a scripted foreman decision identity"
else
  bad "missing or malformed decision identity: '$first_identity'"
fi
if grep -q "guard=pumped base=$BASE identity=$first_identity" "$STATE/foreman/decisions.log"; then
  ok "the pump decision records its occurrence identity"
else
  bad "decisions.log does not record the occurrence identity"
fi

# Complete the new occurrence under another dated tada path. The normalized
# completed-base set is unchanged (duplicate rows collapse), as is the plan.
MUTATE="$TR/mutate"
git clone -q --single-branch --branch "$BRANCH" "$BARE" "$MUTATE"
mkdir -p "$MUTATE/jobs/tada/2026/10/27"
git -C "$MUTATE" mv "jobs/todo/$BASE.md" "jobs/tada/2026/10/27/$BASE.md"
git -C "$MUTATE" -c user.name=test -c user.email=test@localhost commit -q -m complete-recurrence
git -C "$MUTATE" push -q origin "$BRANCH"
printf '%s\n' another-posted-step > "$STATE/foreman/last-step"
CALLS="$TR/duplicate-calls"
tick 1002 GARDEN_FOREMAN_STUB_RETRY_BASE=none GARDEN_FOREMAN_STUB_CALLS="$CALLS" \
  || bad "unchanged duplicate tick failed"
if ! tree | grep -qx "jobs/todo/$BASE.md" && [ "$(index_identities | grep -cxF "$first_identity")" -eq 1 ]; then
  ok "an unchanged delivered decision is idempotent"
else
  bad "unchanged decision reminted work or changed identity ownership"
fi
if [ "$(wc -l < "$CALLS")" -eq 2 ] \
   && grep -q "guard=duplicate-proposal base=$BASE" "$STATE/foreman/decisions.log"; then
  ok "an unchanged duplicate gets exactly one replacement prompt"
else
  bad "duplicate fallback was not bounded to one re-prompt"
fi

# A semantic plan change is a fresh milestone context. The same agent basename
# now gets a different scripted identity and may recur again.
git -C "$MUTATE" pull -q --ff-only
printf '%s\n' '---' 'status: active' 'phase: recurrence-two' '---' '# M1' > "$MUTATE/plan/milestones/M1.md"
git -C "$MUTATE" add plan/milestones/M1.md
git -C "$MUTATE" -c user.name=test -c user.email=test@localhost commit -q -m advance-context
git -C "$MUTATE" push -q origin "$BRANCH"
printf '%s\n' another-posted-step > "$STATE/foreman/last-step"
tick 1003 || bad "changed-context recurrence tick failed"
second_identity="$(index_identities | grep -vF "$first_identity" | head -1)"
if tree | grep -qx "jobs/todo/$BASE.md" \
   && [[ "$second_identity" =~ ^foreman-decision:[0-9a-f]{24}$ ]]; then
  ok "changed milestone context posts the recurrence under a new identity"
else
  bad "changed context did not disambiguate the recurring basename"
fi

echo "--- malformed proposal fallback"
STATE="$TR/state-malformed"; mkdir -p "$STATE/foreman"
printf '%s\n' another-posted-step > "$STATE/foreman/last-step"
MALFORMED_CALLS="$TR/malformed-calls"
tick 2000 GARDEN_FOREMAN_ACTIVE_TARGET=2 GARDEN_FOREMAN_STUB_BASE='bad/name'
tick 2001 GARDEN_FOREMAN_ACTIVE_TARGET=2 GARDEN_FOREMAN_STUB_BASE='bad/name' \
  GARDEN_FOREMAN_STUB_RETRY_BASE=fresh-replacement-step \
  GARDEN_FOREMAN_STUB_CALLS="$MALFORMED_CALLS" || bad "malformed replacement tick failed"
if [ "$(wc -l < "$MALFORMED_CALLS")" -eq 2 ] \
   && tree | grep -qx 'jobs/todo/fresh-replacement-step.md'; then
  ok "a malformed proposal is re-prompted once and replaced"
else
  bad "malformed proposal fallback did not post one valid replacement"
fi

echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
