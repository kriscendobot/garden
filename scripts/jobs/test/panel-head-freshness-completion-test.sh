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
report='Updated draft PR: https://github.com/endojs/endo-but-for-bots/pull/301'

env GARDEN=panel-fresh-terminal-test GARDEN_STATE="$TR/state" \
  JOURNAL_REMOTE="$TR/journal.git" JOURNAL_BRANCH=journal2 \
  GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 GARDEN_BOT_LOGIN=kriscendobot \
  GARDEN_PRODUCER_CLONE="$TR/state/producer/journal" \
  GARDEN_GH="$HERE/panel-head-freshness-completion-gh-stub.sh" \
  GARDEN_GH_CALL_LOG="$TR/gh-calls.log" \
  GARDEN_STUB_RC=0 GARDEN_STUB_SIGNAL=1 GARDEN_STUB_REPORT="$report" \
  GARDEN_STUB_CALL_LOG="$TR/handler-calls.log" \
  GARDEN_JOB_HANDLER="$HERE/completion-signal-handler-stub.sh" \
  "$JOBS/gardener.sh" 1 >"$TR/gardener.log" 2>&1 || true

git clone -q --single-branch --branch journal2 "$TR/journal.git" "$TR/verify"
stale_tada="$(find "$TR/verify/jobs/tada" -type f -name stalejob.md -print -quit)"
[ -n "$stale_tada" ] || fail 'stale producer did not terminalize'
[ ! -e "$TR/verify/jobs/doin/stalejob.md" ] || fail 'stale producer remained in doin'
[ "$(wc -l <"$TR/handler-calls.log")" -eq 1 ] || fail 'producer handler reran'
message="$TR/verify/inbox/maintainer/unread/stale-panel-head-endojs-endo-but-for-bots-pr301-aaaaaaaa-bbbbbbbb.md"
[ -f "$message" ] || fail 'deduplicated stale-review action was not recorded'
grep -q 'Disposition: \*\*review required\*\*' "$message" || fail 'maintainer action lacks explicit disposition'
grep -q 'No gauntlet was staged' "$message" || fail 'manual-trigger policy is not explicit'
grep -q '## Panel-head freshness' "$stale_tada" || fail 'tada report lacks freshness disposition'
[ ! -e "$TR/verify/jobs/gauntlet/endojs-endo-but-for-bots-pr301-gauntlet.md" ] || fail 'freshness gate silently staged a gauntlet'
! grep -qE 'pr (ready|merge|edit|close|reopen)' "$TR/gh-calls.log" || fail 'freshness gate mutated the PR'
grep -q 'panel-head freshness disposition recorded' "$TR/gardener.log" || fail 'freshness disposition was not logged'

echo 'PASS: stale post-panel completion terminalizes with one explicit review-required action, no PR mutation, and no automatic gauntlet'
