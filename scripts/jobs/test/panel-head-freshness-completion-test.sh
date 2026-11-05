#!/bin/bash
# A stale panel-head result is a terminal, durable review-required disposition;
# it never silently stages a gauntlet and never reruns the producing handler.
set -euo pipefail
mapfile -t ambient_test_variables < <(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true)
[ "${#ambient_test_variables[@]}" -eq 0 ] || unset "${ambient_test_variables[@]}"
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-panel-fresh-terminal.XXXXXX")"
trap '[ "${KEEP_GARDEN_TEST_TMP:-0}" = 1 ] || rm -rf "$TR"' EXIT
fail() { echo "FAIL: $*" >&2; exit 1; }

git init -q --bare "$TR/journal.git"
git init -q "$TR/seed"
git -C "$TR/seed" checkout -q -b journal2
mkdir -p "$TR/seed/jobs/"{plan,todo,doin,tada,index,gauntlet,orchestration,bids} \
  "$TR/seed/work" "$TR/seed/inbox/maintainer/"{unread,read} \
  "$TR/seed/entries" "$TR/seed/msgs" "$TR/seed/hosts" "$TR/seed/schedules" \
  "$TR/seed/cursors" "$TR/seed/reputation/"{events,pending,verdicts} \
  "$TR/seed/panel-runs/endojs-endo-but-for-bots-301"
for directory in jobs/plan jobs/todo jobs/doin jobs/tada jobs/index jobs/gauntlet \
  jobs/orchestration jobs/bids work inbox/maintainer/unread inbox/maintainer/read \
  entries msgs hosts schedules cursors reputation/events reputation/pending reputation/verdicts; do
  touch "$TR/seed/$directory/.gitkeep"
done
printf -- '---\nrole: shepherd\n---\nRepair CI on the existing PR.\n' >"$TR/seed/jobs/todo/stalejob.md"
cat >"$TR/seed/panel-runs/endojs-endo-but-for-bots-301/panel.md" <<'EOF'
---
kind: panel-run
repo: endojs/endo-but-for-bots
pr: 301
disposition: passed
reviewed_head: aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
---
EOF
git -C "$TR/seed" add -A
git -C "$TR/seed" -c user.name=test -c user.email=test@example.invalid commit -q -m seed
git -C "$TR/seed" remote add origin "$TR/journal.git"
git -C "$TR/seed" push -q origin HEAD:journal2

: >"$TR/handler-calls.log"
: >"$TR/gh-calls.log"
: >"$TR/docket.log"
report='Updated draft PR: https://github.com/endojs/endo-but-for-bots/pull/301'

env GARDEN=panel-fresh-terminal-test GARDEN_STATE="$TR/state" \
  JOURNAL_REMOTE="$TR/journal.git" JOURNAL_BRANCH=journal2 \
  GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 GARDEN_BOT_LOGIN=kriscendobot \
  GARDEN_PRODUCER_CLONE="$TR/state/producer/journal" \
  GARDEN_GH="$HERE/panel-head-freshness-completion-gh-stub.sh" \
  GARDEN_GH_CALL_LOG="$TR/gh-calls.log" \
  GARDEN_GARDENER_DOCKET_REQUEST="$HERE/review-docket-request-spy.sh" \
  GARDEN_DOCKET_SPY_LOG="$TR/docket.log" \
  GARDEN_STUB_RC=0 GARDEN_STUB_SIGNAL=1 GARDEN_STUB_REPORT="$report" \
  GARDEN_STUB_CALL_LOG="$TR/handler-calls.log" \
  GARDEN_JOB_HANDLER="$HERE/completion-signal-handler-stub.sh" \
  "$JOBS/gardener.sh" 1 >"$TR/gardener.log" 2>&1 || true

git clone -q --single-branch --branch journal2 "$TR/journal.git" "$TR/verify"
stale_tada="$(find "$TR/verify/jobs/tada" -type f -name stalejob.md -print -quit)"
[ -n "$stale_tada" ] || fail 'stale producer did not terminalize'
[ ! -e "$TR/verify/jobs/doin/stalejob.md" ] || fail 'stale producer remained in doin'
[ "$(wc -l <"$TR/handler-calls.log")" -eq 1 ] || fail 'producer handler reran'
grep -q -- '--ask re-review' "$TR/docket.log" || fail 'stale review was not sent to the docket'
grep -q 'stale-panel-head-endojs-endo-but-for-bots-pr301-aaaaaaaa-bbbbbbbb' "$TR/docket.log" \
  || fail 'docket request lacks stable stale-head identity'
grep -q '## Panel-head freshness' "$stale_tada" || fail 'tada report lacks freshness disposition'
[ ! -e "$TR/verify/jobs/gauntlet/endojs-endo-but-for-bots-pr301-gauntlet.md" ] || fail 'freshness gate silently staged a gauntlet'
! grep -qE 'pr (ready|merge|edit|close|reopen)' "$TR/gh-calls.log" || fail 'freshness gate mutated the PR'
grep -q 'panel-head freshness disposition recorded' "$TR/gardener.log" || fail 'freshness disposition was not logged'

# A review-docket rc=76 means the re-review action is durable in the host spool,
# so the completed producer terminalizes with an explicit deferred disposition.
# Other nonzero docket results remain retryable.
printf -- '---\nrole: shepherd\n---\nExercise a spooled stale-panel request.\n' \
  > "$TR/verify/jobs/todo/stalejob-spooled.md"
git -C "$TR/verify" add jobs/todo/stalejob-spooled.md
git -C "$TR/verify" -c user.name=test -c user.email=test@example.invalid \
  commit -q -m 'seed spooled stale-panel case'
git -C "$TR/verify" push -q origin HEAD:journal2
env GARDEN=panel-fresh-terminal-test GARDEN_STATE="$TR/state-spooled" \
  JOURNAL_REMOTE="$TR/journal.git" JOURNAL_BRANCH=journal2 \
  GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 GARDEN_BOT_LOGIN=kriscendobot \
  GARDEN_PRODUCER_CLONE="$TR/state-spooled/producer/journal" \
  GARDEN_GH="$HERE/panel-head-freshness-completion-gh-stub.sh" \
  GARDEN_GH_CALL_LOG="$TR/gh-calls.log" \
  GARDEN_GARDENER_DOCKET_REQUEST="$HERE/review-docket-request-spy.sh" \
  GARDEN_DOCKET_SPY_LOG="$TR/docket.log" GARDEN_DOCKET_SPY_RC=76 \
  GARDEN_STUB_RC=0 GARDEN_STUB_SIGNAL=1 GARDEN_STUB_REPORT="$report" \
  GARDEN_STUB_CALL_LOG="$TR/handler-calls.log" \
  GARDEN_JOB_HANDLER="$HERE/completion-signal-handler-stub.sh" \
  "$JOBS/gardener.sh" 2 > "$TR/gardener-spooled.log" 2>&1 || true
rm -rf "$TR/verify"
git clone -q --single-branch --branch journal2 "$TR/journal.git" "$TR/verify"
spooled_tada="$(find "$TR/verify/jobs/tada" -type f -name stalejob-spooled.md -print -quit)"
[ -n "$spooled_tada" ] || fail 'spooled stale-panel request did not terminalize'
grep -q 'durably spooled for a later docket transaction' "$spooled_tada" \
  || fail 'spooled stale-panel disposition was not recorded in the report'
grep -q "freshness disposition spooled for 'stalejob-spooled'" "$TR/gardener-spooled.log" \
  || fail 'spooled stale-panel disposition was not logged'
! grep -q 'leaving in doin for retry' "$TR/gardener-spooled.log" \
  || fail 'spooled stale-panel request entered the retry path'

printf -- '---\nrole: shepherd\n---\nExercise a hard stale-panel docket failure.\n' \
  > "$TR/verify/jobs/todo/stalejob-hard.md"
git -C "$TR/verify" add jobs/todo/stalejob-hard.md
git -C "$TR/verify" -c user.name=test -c user.email=test@example.invalid \
  commit -q -m 'seed hard stale-panel case'
git -C "$TR/verify" push -q origin HEAD:journal2
env GARDEN=panel-fresh-terminal-test GARDEN_STATE="$TR/state-hard" \
  JOURNAL_REMOTE="$TR/journal.git" JOURNAL_BRANCH=journal2 \
  GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 GARDEN_BOT_LOGIN=kriscendobot \
  GARDEN_PRODUCER_CLONE="$TR/state-hard/producer/journal" \
  GARDEN_GH="$HERE/panel-head-freshness-completion-gh-stub.sh" \
  GARDEN_GH_CALL_LOG="$TR/gh-calls.log" \
  GARDEN_GARDENER_DOCKET_REQUEST="$HERE/review-docket-request-spy.sh" \
  GARDEN_DOCKET_SPY_LOG="$TR/docket.log" GARDEN_DOCKET_SPY_RC=1 \
  GARDEN_STUB_RC=0 GARDEN_STUB_SIGNAL=1 GARDEN_STUB_REPORT="$report" \
  GARDEN_STUB_CALL_LOG="$TR/handler-calls.log" \
  GARDEN_JOB_HANDLER="$HERE/completion-signal-handler-stub.sh" \
  "$JOBS/gardener.sh" 3 > "$TR/gardener-hard.log" 2>&1 || true
rm -rf "$TR/verify"
git clone -q --single-branch --branch journal2 "$TR/journal.git" "$TR/verify"
[ -e "$TR/verify/jobs/doin/stalejob-hard.md" ] \
  || fail 'hard stale-panel docket failure did not retain the retryable claim'
[ ! -e "$TR/verify/jobs/tada/stalejob-hard.md" ] \
  || fail 'hard stale-panel docket failure terminalized'
grep -q 'leaving in doin for retry' "$TR/gardener-hard.log" \
  || fail 'hard stale-panel docket failure was not logged as retryable'

# Regression: a provider completion nudge may succeed and emit its sentinel after
# its transient job/report inputs have disappeared.  The freshness gate must not
# leak the sensor's bare usage text/rc=2; it diagnoses the missing inputs as a
# retryable completion failure and leaves the durable claim in doin.
printf -- '---\nrole: shepherd\n---\nExercise missing completion inputs.\n' \
  >"$TR/verify/jobs/todo/missinginput.md"
git -C "$TR/verify" add jobs/todo/missinginput.md
git -C "$TR/verify" -c user.name=test -c user.email=test@example.invalid \
  commit -q -m 'seed missing-input regression'
git -C "$TR/verify" push -q origin HEAD:journal2

env GARDEN=panel-fresh-terminal-test GARDEN_STATE="$TR/state-missing" \
  JOURNAL_REMOTE="$TR/journal.git" JOURNAL_BRANCH=journal2 \
  GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 GARDEN_BOT_LOGIN=kriscendobot \
  GARDEN_PRODUCER_CLONE="$TR/state-missing/producer/journal" \
  GARDEN_GH="$HERE/panel-head-freshness-completion-gh-stub.sh" \
  GARDEN_GH_CALL_LOG="$TR/gh-calls.log" \
  GARDEN_GARDENER_DOCKET_REQUEST="$HERE/review-docket-request-spy.sh" \
  GARDEN_DOCKET_SPY_LOG="$TR/docket.log" \
  GARDEN_STUB_RC=0 GARDEN_STUB_SIGNAL=1 \
  GARDEN_STUB_REPORT='Successful completion nudge report.' \
  GARDEN_STUB_REMOVE_INPUTS=1 GARDEN_STUB_CALL_LOG="$TR/handler-calls.log" \
  GARDEN_JOB_HANDLER="$HERE/completion-signal-handler-stub.sh" \
  "$JOBS/gardener.sh" 4 >"$TR/missing-input.log" 2>&1 || true

rm -rf "$TR/verify-missing"
git clone -q --single-branch --branch journal2 "$TR/journal.git" "$TR/verify-missing"
[ -e "$TR/verify-missing/jobs/doin/missinginput.md" ] \
  || fail 'successful handler with missing freshness inputs did not remain retryable in doin'
[ ! -e "$TR/verify-missing/jobs/tada/missinginput.md" ] \
  || fail 'successful handler with missing freshness inputs terminalized'
grep -q 'panel-head-freshness: completion input unavailable for missinginput' "$TR/missing-input.log" \
  || fail 'missing freshness input lacked an actionable retryable diagnostic'
grep -q 'fresh board sync/requeue can restore the input' "$TR/missing-input.log" \
  || fail 'missing freshness input diagnostic did not explain the retry action'
! grep -q '^usage:' "$TR/missing-input.log" \
  || fail 'missing freshness input leaked the sensor usage diagnostic'
grep -q "handler FAILED (rc=12) for 'missinginput'" "$TR/missing-input.log" \
  || fail 'missing freshness input did not enter the retryable completion-failure path'

echo 'PASS: stale post-panel completions accept recorded or spooled docket actions, preserve hard-error retries, and diagnose missing completion inputs'
