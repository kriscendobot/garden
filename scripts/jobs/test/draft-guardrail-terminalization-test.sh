#!/bin/bash
# draft-guardrail-terminalization-test.sh — a conclusive completion-time draft
# guardrail hit becomes one durable manual-gauntlet action plus tada, not another
# handler/reaper cycle. The PR remains untouched.

set -euo pipefail
# A live gardener can invoke this suite with its own worker-kind/clone routing in
# the environment. Keep every journal write inside the throwaway fixture.
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-draft-terminal-test.XXXXXX")"
trap '[ "${KEEP_GARDEN_TEST_TMP:-0}" = 1 ] || rm -rf "$TR"' EXIT

fail() { echo "FAIL: $*" >&2; exit 1; }

git init -q --bare "$TR/journal.git"
git init -q "$TR/seed"
git -C "$TR/seed" checkout -q -b journal2
mkdir -p "$TR/seed/jobs/"{plan,todo,doin,tada,index,gauntlet,orchestration,bids} \
  "$TR/seed/work" "$TR/seed/inbox/maintainer/"{unread,read} \
  "$TR/seed/entries" "$TR/seed/msgs" "$TR/seed/hosts" "$TR/seed/schedules" \
  "$TR/seed/cursors" "$TR/seed/reputation/"{events,pending,verdicts}
for d in jobs/plan jobs/todo jobs/doin jobs/tada jobs/index jobs/gauntlet \
  jobs/orchestration jobs/bids work inbox/maintainer/unread inbox/maintainer/read \
  entries msgs hosts schedules cursors reputation/events reputation/pending reputation/verdicts; do
  touch "$TR/seed/$d/.gitkeep"
done
printf -- '---\nrole: builder\n---\nBuild the feature.\n' > "$TR/seed/jobs/todo/readyjob.md"
git -C "$TR/seed" add -A
git -C "$TR/seed" -c user.name=test -c user.email=test@example.invalid commit -q -m seed
git -C "$TR/seed" remote add origin "$TR/journal.git"
git -C "$TR/seed" push -q origin HEAD:journal2

: > "$TR/handler-calls.log"
: > "$TR/gh-calls.log"
report='Ready PR: https://github.com/endojs/endo-but-for-bots/pull/201

## Follow-ups

Run the manual gauntlet if review is wanted.'

env GARDEN=draft-terminal-test GARDEN_STATE="$TR/state" \
  JOURNAL_REMOTE="$TR/journal.git" JOURNAL_BRANCH=journal2 \
  GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 GARDEN_BOT_LOGIN=kriscendobot \
  GARDEN_PRODUCER_CLONE="$TR/state/producer/journal" \
  GARDEN_GH="$HERE/assert-producer-pr-draft-gh-stub.sh" \
  GARDEN_GH_CALL_LOG="$TR/gh-calls.log" \
  GARDEN_STUB_RC=0 GARDEN_STUB_SIGNAL=1 GARDEN_STUB_REPORT="$report" \
  GARDEN_STUB_CALL_LOG="$TR/handler-calls.log" \
  GARDEN_JOB_HANDLER="$HERE/completion-signal-handler-stub.sh" \
  "$JOBS/gardener.sh" 1 > "$TR/gardener.log" 2>&1 || true

git clone -q --single-branch --branch journal2 "$TR/journal.git" "$TR/verify"
[ -f "$TR/verify/jobs/tada/readyjob.md" ] || fail 'guarded completed job did not terminalize in tada'
[ ! -e "$TR/verify/jobs/doin/readyjob.md" ] || fail 'guarded completed job remained in doin'
[ ! -e "$TR/verify/jobs/todo/readyjob.md" ] || fail 'guarded completed job was requeued'
[ "$(wc -l < "$TR/handler-calls.log")" -eq 1 ] || fail 'handler ran more than once'

msg="$TR/verify/inbox/maintainer/unread/manual-gauntlet-handoff-readyjob-endojs-endo-but-for-bots-pr201.md"
[ -f "$msg" ] || fail 'durable manual-gauntlet maintainer action was not recorded'
grep -q 'reply_to: readyjob' "$msg" || fail 'maintainer action is not attributed to the completed job'
grep -q 'did not re-draft the PR and did not stage a gauntlet' "$msg" \
  || fail 'maintainer action does not preserve the non-mutating contract'
grep -q '## Manual gauntlet handoff' "$TR/verify/jobs/tada/readyjob.md" \
  || fail 'completion report does not record the terminal handoff'
grep -q 'terminalized it' "$TR/gardener.log" || fail 'terminalization was not logged'
! grep -q 'leaving in doin for retry' "$TR/gardener.log" \
  || fail 'conclusive draft-gate result still entered the retry path'
! grep -qE 'pr (ready|merge|edit|close|reopen)' "$TR/gh-calls.log" \
  || fail 'draft guardrail mutated the PR'

# A second worker pass sees an empty board: no repeated handler and no repeated
# maintainer action. This is the regression boundary for the former reaper loop.
env GARDEN=draft-terminal-test GARDEN_STATE="$TR/state2" \
  JOURNAL_REMOTE="$TR/journal.git" JOURNAL_BRANCH=journal2 \
  GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 GARDEN_BOT_LOGIN=kriscendobot \
  GARDEN_STUB_CALL_LOG="$TR/handler-calls.log" \
  GARDEN_JOB_HANDLER="$HERE/completion-signal-handler-stub.sh" \
  "$JOBS/gardener.sh" 2 > "$TR/gardener-second.log" 2>&1 || true
[ "$(wc -l < "$TR/handler-calls.log")" -eq 1 ] || fail 'terminal job ran the handler again'
[ "$(find "$TR/verify/inbox/maintainer/unread" -name 'manual-gauntlet-handoff-*.md' | wc -l)" -eq 1 ] \
  || fail 'manual-gauntlet action was duplicated'

echo 'PASS: conclusive draft guardrail hits terminalize completed jobs with one durable manual-gauntlet action, no PR mutation, and no repeated handler run'
