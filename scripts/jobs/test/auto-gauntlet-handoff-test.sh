#!/bin/bash
# auto-gauntlet-handoff-test.sh — completion-local automatic staging.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-auto-gauntlet-test.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
fail() { echo "FAIL: $*" >&2; exit 1; }

git init -q --bare "$TR/journal.git"
git init -q "$TR/seed"
git -C "$TR/seed" checkout -q -b journal2
mkdir -p "$TR/seed/jobs/"{todo,doin,tada,index,gauntlet} "$TR/seed/work"
touch "$TR/seed/jobs/todo/.gitkeep" "$TR/seed/jobs/doin/.gitkeep" \
  "$TR/seed/jobs/tada/.gitkeep" "$TR/seed/jobs/index/.gitkeep" \
  "$TR/seed/jobs/gauntlet/.gitkeep" "$TR/seed/work/.gitkeep"
git -C "$TR/seed" add -A
git -C "$TR/seed" -c user.name=test -c user.email=test@example.invalid commit -q -m seed
git -C "$TR/seed" remote add origin "$TR/journal.git"
git -C "$TR/seed" push -q origin HEAD:journal2

GARDEN_ROOT="$(cd "$JOBS/../.." && pwd)"
export GARDEN_ROOT
export GARDEN_TEST=1 JOURNAL_REMOTE="$TR/journal.git" JOURNAL_BRANCH=journal2
export GARDEN_STATE="$TR/state" GARDEN=auto-gauntlet-test
export GARDEN_BOT_LOGIN=kriscendobot
export GARDEN_PRODUCER_CLONE="$TR/state/producer/journal"
export GARDEN_GH="$HERE/assert-producer-pr-draft-gh-stub.sh"
export GARDEN_GH_CALL_LOG="$TR/gh-calls.log"

builder="$TR/builder.md"
designer="$TR/designer.md"
web_builder="$TR/web-builder.md"
probe="$TR/probe.md"
roleless="$TR/roleless.md"
printf -- '---\nrole: builder\n---\nBuild.\n' >"$builder"
printf -- '---\nrole: designer\n---\nDesign.\n' >"$designer"
printf -- '---\nrole: web-builder\n---\nBuild a web surface.\n' >"$web_builder"
printf -- '---\nrole: builder\n---\nProbe the design.\n' >"$probe"
printf 'Produce an implementation artifact.\n' >"$roleless"
# build-minion-town-caddy-restart-on-env-change (2026-10-05) used "probe" as an
# ordinary noun and was misclassified as a probe; minion.town#163 staged nothing.
smoke_probe="$TR/smoke-probe.md"
probe_verb="$TR/probe-verb.md"
printf -- '---\nrole: builder\n---\n3. Optionally, strengthen the smoke probe so a gated route is detected.\n' >"$smoke_probe"
printf -- '---\nrole: builder\n---\nprobe #12 and report the gaps.\n' >"$probe_verb"

run_hook() { # <base> <job> <pr>
  local base="$1" job="$2" pr="$3" report
  report="$TR/$base-report.md"
  printf 'Artifact: https://github.com/endojs/endo-but-for-bots/pull/%s\n' "$pr" >"$report"
  "$JOBS/auto-gauntlet-handoff.sh" "$base" "$job" "$report"
}

echo '== producer drafts record PR-keyed staged gauntlets =='
run_hook build-x "$builder" 200
[ -e "$GARDEN_PRODUCER_CLONE/jobs/gauntlet/endojs-endo-but-for-bots-pr200-gauntlet.md" ] \
  || fail 'builder gauntlet was not recorded'
grep -q '^build_job: build-x$' "$GARDEN_PRODUCER_CLONE/jobs/gauntlet/endojs-endo-but-for-bots-pr200-gauntlet.md" \
  || fail 'builder provenance missing'
run_hook build-web "$web_builder" 208
[ -e "$GARDEN_PRODUCER_CLONE/jobs/gauntlet/endojs-endo-but-for-bots-pr208-gauntlet.md" ] \
  || fail 'web-builder gauntlet was not recorded'

echo '== role-less and non-design non-builder producers also stage =='
run_hook roleless-x "$roleless" 209
[ -e "$GARDEN_PRODUCER_CLONE/jobs/gauntlet/endojs-endo-but-for-bots-pr209-gauntlet.md" ] \
  || fail 'role-less producer gauntlet was not recorded'
run_hook ordinary-fix "$designer" 200
[ "$(find "$GARDEN_PRODUCER_CLONE/jobs/gauntlet" -name 'endojs-endo-but-for-bots-pr200-gauntlet.md' | wc -l)" -eq 1 ] \
  || fail 'two producers for one PR did not converge on one record'

echo '== the word "probe" in an ordinary build still stages =='
run_hook build-caddy "$smoke_probe" 216
[ -e "$GARDEN_PRODUCER_CLONE/jobs/gauntlet/endojs-endo-but-for-bots-pr216-gauntlet.md" ] \
  || fail 'a build mentioning a smoke probe was misread as a probe and staged nothing'

echo '== exclusions do not stage =='
run_hook probe-x "$probe" 203
run_hook probe-verb "$probe_verb" 217
[ ! -e "$GARDEN_PRODUCER_CLONE/jobs/gauntlet/endojs-endo-but-for-bots-pr217-gauntlet.md" ] \
  || fail 'a "probe #N" directive staged a gauntlet'
run_hook ready-build "$builder" 210
run_hook open-questions "$roleless" 214
run_hook cited-draft "$roleless" 215
[ ! -e "$GARDEN_PRODUCER_CLONE/jobs/gauntlet/endojs-endo-but-for-bots-pr203-gauntlet.md" ] \
  || fail 'probe staged a gauntlet'
[ ! -e "$GARDEN_PRODUCER_CLONE/jobs/gauntlet/endojs-endo-but-for-bots-pr210-gauntlet.md" ] \
  || fail 'ready PR staged through the draft-only hook'
[ ! -e "$GARDEN_PRODUCER_CLONE/jobs/gauntlet/endojs-endo-but-for-bots-pr214-gauntlet.md" ] \
  || fail 'open-questions answer surface staged a gauntlet'
[ ! -e "$GARDEN_PRODUCER_CLONE/jobs/gauntlet/endojs-endo-but-for-bots-pr215-gauntlet.md" ] \
  || fail 'cited draft from another author staged a gauntlet'
! grep -qE 'pr (ready|merge|edit|close|reopen)' "$TR/gh-calls.log" \
  || fail 'auto handoff mutated GitHub PR state'

echo '== a build whose ledger says non-deliverable-probe still stages (minion.town#148) =='
run_hook build-cli-provider "$builder" 219 2>"$TR/ledger.err"
[ -e "$GARDEN_PRODUCER_CLONE/jobs/gauntlet/endojs-endo-but-for-bots-pr219-gauntlet.md" ] \
  || fail 'a build PR with a non-deliverable-probe ledger staged no gauntlet'
grep -q "ledger says 'non-deliverable-probe'; staging the code panel anyway" "$TR/ledger.err" \
  || fail 'the ledger-disposition staging decision was not logged'

echo '== a held-draft gauntlet re-stages once the ledger turns deliverable =='
seed_held() { # <pr> [gauntlet-base]
  local wt="$TR/seed-held-$1-$RANDOM" shard gauntlet_base
  shard="$(date -u +%Y/%m/%d)"
  gauntlet_base="${2:-endojs-endo-but-for-bots-pr$1-gauntlet}"
  git clone -q --branch journal2 "$TR/journal.git" "$wt"
  mkdir -p "$wt/jobs/tada/$shard"
  printf 'gauntlet-status: held-draft\nrepo: endojs/endo-but-for-bots\npr_number: %s\n# held\n' "$1" \
    >"$wt/jobs/tada/$shard/$gauntlet_base.md"
  git -C "$wt" add -A
  git -C "$wt" -c user.name=test -c user.email=test@example.invalid commit -q -m "held pr$1"
  git -C "$wt" push -q origin HEAD:journal2
}
seed_held 220
run_hook canary-child "$builder" 220 2>"$TR/restage.err"
[ -e "$GARDEN_PRODUCER_CLONE/jobs/gauntlet/endojs-endo-but-for-bots-pr220-gauntlet-$(date -u +%Y%m%d)-0123456789ab.md" ] \
  || fail "deliverable ledger after a held-draft finish did not re-stage: $(cat "$TR/restage.err")"
seed_held 221
run_hook still-slice "$builder" 221 2>/dev/null
[ -z "$(find "$GARDEN_PRODUCER_CLONE/jobs/gauntlet" -name 'endojs-endo-but-for-bots-pr221-gauntlet*')" ] \
  || fail 'a still-held ledger re-staged a gauntlet'

echo '== a second held-draft finish on the same day gets a distinct re-stage =='
seed_held 222
seed_held 222 "endojs-endo-but-for-bots-pr222-gauntlet-$(date -u +%Y%m%d)-aaaaaaaaaaaa"
GARDEN_STUB_HEAD_OID=bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb \
  run_hook second-canary-child "$builder" 222 2>"$TR/restage-second.err"
[ -e "$GARDEN_PRODUCER_CLONE/jobs/gauntlet/endojs-endo-but-for-bots-pr222-gauntlet-$(date -u +%Y%m%d)-bbbbbbbbbbbb.md" ] \
  || fail "second same-day held-draft finish reused the earlier re-stage: $(cat "$TR/restage-second.err")"

echo '== idempotent replay keeps one PR-keyed record =='
run_hook build-x "$builder" 200
[ "$(find "$GARDEN_PRODUCER_CLONE/jobs/gauntlet" -name 'endojs-endo-but-for-bots-pr200-gauntlet.md' | wc -l)" -eq 1 ] \
  || fail 'builder replay duplicated the record'

echo '== a transient first gh read is retried, not a failed completion =='
export GARDEN_BACKOFF_BASE_MS=1 GARDEN_BACKOFF_CAP_MS=5 GARDEN_GH_API_ATTEMPTS=3
run_hook build-flaky "$builder" 211 || fail 'transient first attempt failed the handoff'
[ -e "$GARDEN_PRODUCER_CLONE/jobs/gauntlet/endojs-endo-but-for-bots-pr211-gauntlet.md" ] \
  || fail 'transient-retried builder gauntlet was not recorded'
[ "$(grep -c 'pull/211 ' "$TR/gh-calls.log")" -eq 2 ] || fail 'transient read was not retried exactly once'

echo '== a non-PR no-ops immediately, without retries =='
run_hook build-issue "$builder" 213 || fail 'non-PR failed the handoff'
[ "$(grep -c 'pull/213 ' "$TR/gh-calls.log")" -eq 1 ] || fail 'non-PR read was retried'
[ ! -e "$GARDEN_PRODUCER_CLONE/jobs/gauntlet/endojs-endo-but-for-bots-pr213-gauntlet.md" ] || fail 'non-PR staged a gauntlet'

echo '== a persistent transient fails only after the retry budget =='
if run_hook build-down "$builder" 212 2>"$TR/down.err"; then fail 'exhausted transient reads succeeded'; fi
[ "$(grep -c 'pull/212 ' "$TR/gh-calls.log")" -eq 3 ] || fail 'exhausted read did not spend exactly GARDEN_GH_API_ATTEMPTS'
grep -q 'gh could not inspect' "$TR/down.err" || fail 'exhaustion did not fail loud'

echo 'PASS: completion-local auto handoff stages every bot-authored draft artifact by PR identity, skips exceptions, never mutates PR state, replays idempotently, and retries only transient gh reads'
