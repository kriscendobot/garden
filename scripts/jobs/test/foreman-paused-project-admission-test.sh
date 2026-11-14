#!/bin/bash
# foreman-paused-project-admission-test.sh — a paused-project refusal
# (GARDEN_PAUSED_RC from promote-plan.sh / post-job.sh) is a nonfatal foreman
# decision, not a failed tick (job improve-foreman-paused-project-admission,
# 2026-11-14).
#
# THE BUG: the deferred-promotion loop swallowed promote-plan.sh's rc, logged a
# generic failure, and stopped — so every tick re-selected the same paused head
# and starved every eligible deferred job behind it; and the pump path turned the
# same rc=78 from post-job.sh into `exit 78`, failing the unit every tick.
#
# SUBTEST 1 — deferred admission: a paused deferred job is excluded from this
#   tick's admission, the eligible one behind it is promoted, the tick exits 0,
#   and the decision line names the paused base.
# SUBTEST 2 — pump path: a handler proposal in a paused project is recorded as
#   guard=paused-project, re-prompted once, the replacement is posted, rc=0.
# SUBTEST 3 — pump path with no replacement: still rc=0, nothing posted.
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

BRANCH=journal2
declare -a GIT_ID=(-c user.name=test -c user.email=test@localhost)
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-fpaused.XXXXXX")"; trap 'rm -rf "$TR"' EXIT

# new_journal <tag> <plan-base>... → bare path: a board paused on project
# `quarantined` (pauses/quarantined.md), seeded with the given deferred plan jobs.
new_journal() {
  local tag="$1"; shift
  local bare="$TR/$tag.git" seed="$TR/$tag.seed" d b
  git init -q --bare "$bare"
  git init -q "$seed"; git -C "$seed" checkout -q -b "$BRANCH"
  ( cd "$seed"
    for d in jobs/todo jobs/doin jobs/tada jobs/plan jobs/index plan/milestones plan/designs \
             work repos msgs hosts entries schedules cursors config pauses \
             inbox/maintainer/unread inbox/maintainer/read; do
      mkdir -p "$d"; touch "$d/.gitkeep"
    done
    printf '%s\n' '---' 'status: active' '---' '# M1' > plan/milestones/M1.md
    printf '%s\n' '---' 'project: quarantined' 'authorized_by: test' '---' 'paused for test' \
      > pauses/quarantined.md
    for b in "$@"; do
      printf '# %s\n\ndo the deferred work for %s\n' "$b" "$b" > "jobs/plan/$b.md"
    done )
  git -C "$seed" add -A
  git -C "$seed" "${GIT_ID[@]}" commit -q -m seed
  git -C "$seed" remote add origin "$bare"
  git -C "$seed" push -q -u origin "$BRANCH"
  printf '%s\n' "$bare"
}

# tick <bare> <state> [env...] → the real foreman rc (not swallowed).
tick() {
  local bare="$1" state="$2" rc=0; shift 2
  mkdir -p "$state"
  env GARDEN=okhost GARDEN_STATE="$state" HOME="$TR" \
      JOURNAL_REMOTE="$bare" JOURNAL_BRANCH="$BRANCH" \
      GARDEN_FOREMAN_IDLE_SETTLE=0 GARDEN_FOREMAN_ACTIVE_TARGET=5 \
      GARDEN_FOREMAN_HANDLER="$HERE/foreman-stub.sh" \
      GARDEN_FOREMAN_STUB_CALLS="$state/stub-calls" "$@" \
      "$JOBS/foreman.sh" >>"$state/tick.log" 2>&1 || rc=$?
  printf '%s\n' "$rc"
}
tree() { git -C "$1" ls-tree -r --name-only "$BRANCH"; }

echo "--- SUBTEST 1: deferred admission skips the paused head"
B1="$(new_journal one quarantined-fuzz-1 eligible-work-1)"; S1="$TR/s1"
tick "$B1" "$S1" >/dev/null
rc="$(tick "$B1" "$S1")"
[ "$rc" = 0 ] && ok "tick exits 0 despite a paused deferred candidate" \
  || bad "tick exited $rc ($(tr '\n' '|' < "$S1/tick.log"))"
tree "$B1" | grep -qx jobs/todo/eligible-work-1.md \
  && ok "the eligible deferred job was promoted (not starved)" \
  || bad "the eligible deferred job was not promoted"
tree "$B1" | grep -qx jobs/plan/quarantined-fuzz-1.md \
  && ok "the paused deferred job stays parked" || bad "the paused job left plan/"
grep -q 'guard=promoted .*paused=quarantined-fuzz-1' "$S1/foreman/decisions.log" \
  && ok "the decision line records the paused exclusion" \
  || bad "decision log lacks paused= ($(cat "$S1"/foreman/decisions.log 2>/dev/null | tr '\n' '|'))"

echo "--- SUBTEST 1b: only paused deferred work → falls through, no failure"
B1b="$(new_journal oneb quarantined-fuzz-2)"; S1b="$TR/s1b"
tick "$B1b" "$S1b" >/dev/null
rc="$(tick "$B1b" "$S1b" GARDEN_FOREMAN_STUB_BASE=fresh-step-1b)"
[ "$rc" = 0 ] && ok "all-paused deferred queue: tick exits 0" || bad "tick exited $rc"
[ "$(grep -c 'promote.*quarantined-fuzz-2' "$S1b/tick.log" || true)" -le 2 ] \
  && ok "the paused head is attempted once per tick, not spun on" \
  || bad "the paused head was retried repeatedly"
tree "$B1b" | grep -qx jobs/todo/fresh-step-1b.md \
  && ok "the handler still pumps a new step past the paused queue" \
  || bad "no step pumped past the paused deferred queue"

echo "--- SUBTEST 2: a pumped step in a paused project is re-prompted, not fatal"
B2="$(new_journal two)"; S2="$TR/s2"
tick "$B2" "$S2" GARDEN_FOREMAN_STUB_BASE=quarantined-next >/dev/null
rc="$(tick "$B2" "$S2" GARDEN_FOREMAN_STUB_BASE=quarantined-next GARDEN_FOREMAN_STUB_RETRY_BASE=open-next)"
[ "$rc" = 0 ] && ok "paused post refusal does not fail the tick" \
  || bad "tick exited $rc ($(tr '\n' '|' < "$S2/tick.log"))"
grep -q 'guard=paused-project base=quarantined-next' "$S2/foreman/decisions.log" \
  && ok "decision log records guard=paused-project" || bad "no paused-project decision"
tree "$B2" | grep -qx jobs/todo/open-next.md \
  && ok "the one re-prompt's replacement step was posted" || bad "replacement not posted"
! tree "$B2" | grep -qx jobs/todo/quarantined-next.md \
  && ok "the paused step was not posted" || bad "paused step posted"

echo "--- SUBTEST 3: no replacement → still nonfatal"
B3="$(new_journal three)"; S3="$TR/s3"
tick "$B3" "$S3" GARDEN_FOREMAN_STUB_BASE=quarantined-next >/dev/null
rc="$(tick "$B3" "$S3" GARDEN_FOREMAN_STUB_BASE=quarantined-next GARDEN_FOREMAN_STUB_RETRY_BASE=none)"
[ "$rc" = 0 ] && ok "paused refusal with no replacement exits 0" || bad "tick exited $rc"

echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
