#!/bin/bash
# mentor-provider-order-test.sh — provider fallback and fail-closed output tests.
set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
ROOT="$(cd "$JOBS/../.." && pwd)"
HANDLER="$JOBS/handlers/mentor-claude.sh"
PASS=0; FAIL=0
ok() { echo "  PASS: $*"; PASS=$((PASS + 1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL + 1)); }
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-mentor-provider.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
BIN="$TR/bin"; mkdir -p "$BIN" "$TR/state" "$TR/clone"
ln -s "$HERE/foreman-provider-fake-codex.sh" "$BIN/codex"
ln -s "$HERE/foreman-provider-fake-curl.sh" "$BIN/curl"
ln -s "$HERE/foreman-provider-fake-claude.sh" "$BIN/claude"
chmod +x "$HERE"/foreman-provider-fake-{codex,curl,claude}.sh "$HANDLER"
SHA=deadbeef
BARE="$TR/journal.git"; SEED="$TR/seed"
git init -q --bare "$BARE"; git init -q "$SEED"; git -C "$SEED" checkout -q -b journal2
mkdir -p "$SEED/jobs/todo" "$SEED/jobs/doin" "$SEED/jobs/tada" "$SEED/jobs/plan" "$SEED/jobs/index"
touch "$SEED/jobs/todo/.gitkeep" "$SEED/jobs/doin/.gitkeep" "$SEED/jobs/tada/.gitkeep" "$SEED/jobs/plan/.gitkeep" "$SEED/jobs/index/.gitkeep"
git -C "$SEED" add -A; git -C "$SEED" -c user.name=test -c user.email=test@localhost commit -q -m seed
git -C "$SEED" remote add origin "$BARE"; git -C "$SEED" push -q -u origin journal2

run_handler() { # <order> [environment assignments...]
  local order="$1"; shift
  env PATH="$BIN:$PATH" HOME="$TR/home" GARDEN_ROOT="$ROOT" GARDEN_STATE="$TR/state" \
    JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 GARDEN_NO_MAINTAINER_ALERT=1 GARDEN_TOKEN_WEEKLY_QUOTA=0 \
    GARDEN_MENTOR_PROVIDER_ORDER="$order" "$@" "$HANDLER" "$SHA" "$TR/clone"
}

echo 'SUBTEST 1 — Claude quota advances to Codex/OpenAI'
LOG1="$TR/log1"
if run_handler anthropic,openai GARDEN_TEST_PROVIDER_LOG="$LOG1" GARDEN_TEST_ANTHROPIC_RC=1 \
  GARDEN_TEST_OPENAI_OUTPUT='JOB improve-codex\nscripts/jobs/example.sh\nmake retry bounded\nENDJOB\n'; then
  VERIFY1="$TR/verify1"; git clone -q --branch journal2 "$BARE" "$VERIFY1"
  [ -f "$VERIFY1/jobs/todo/improve-codex.md" ] && ok "Claude failure falls through to a valid Codex response" || bad "Codex job was not posted"
else bad "Claude quota did not fall through to Codex"; fi
[ "$(tr '\n' ' ' < "$LOG1")" = 'anthropic openai ' ] && ok "attempted Claude then OpenAI" || bad "wrong trace: $(tr '\n' ' ' < "$LOG1")"

rm -rf "$TR/state"; mkdir -p "$TR/state"
echo 'SUBTEST 2 — unavailable providers traverse configured order'
LOG2="$TR/log2"
if run_handler openai,local,anthropic GARDEN_TEST_PROVIDER_LOG="$LOG2" GARDEN_TEST_CODEX_LOGIN_RC=1 GARDEN_TEST_LOCAL_CURL_RC=1 \
  GARDEN_TEST_ANTHROPIC_OUTPUT='JOB improve-claude\nscripts/jobs/other.sh\nmake failure visible\nENDJOB\n'; then
  VERIFY2="$TR/verify2"; git clone -q --branch journal2 "$BARE" "$VERIFY2"
  [ -f "$VERIFY2/jobs/todo/improve-claude.md" ] && ok "unavailable Codex/local providers reach Claude" || bad "Claude fallback job was not posted"
else bad "unavailable provider traversal failed"; fi
[ "$(tr '\n' ' ' < "$LOG2")" = 'local-preflight local-preflight anthropic ' ] && ok "unavailable providers were each skipped once" || bad "wrong traversal: $(tr '\n' ' ' < "$LOG2")"

rm -rf "$TR/state"; mkdir -p "$TR/state"
echo 'SUBTEST 3 — all unavailable fails without a decision'
if run_handler openai,local,anthropic GARDEN_TEST_CODEX_LOGIN_RC=1 GARDEN_TEST_LOCAL_CURL_RC=1 GARDEN_TEST_ANTHROPIC_RC=1 >"$TR/all.out" 2>"$TR/all.err"; then
  bad "all unavailable providers unexpectedly succeeded"
else grep -q 'no configured mentor inference provider was available' "$TR/all.err" && ok "all unavailable reports no provider" || bad "missing all-unavailable diagnostic"; fi

rm -rf "$TR/state"; mkdir -p "$TR/state"
echo 'SUBTEST 4 — malformed semantic output never asks another model'
LOG4="$TR/log4"
if run_handler openai,anthropic GARDEN_TEST_PROVIDER_LOG="$LOG4" GARDEN_TEST_OPENAI_OUTPUT='JOB one\nscripts/jobs/a.sh\nreason\nENDJOB\ntrailing prose\n' >"$TR/malformed.out" 2>"$TR/malformed.err"; then
  bad "malformed output was accepted"
else ok "malformed output is rejected"; fi
[ "$(tr '\n' ' ' < "$LOG4")" = 'openai ' ] && ok "semantic rejection did not solicit Claude" || bad "malformed output fanned out: $(tr '\n' ' ' < "$LOG4")"

echo 'SUBTEST 5 — injected handler and stable identity prevent duplicate posting'
for n in 1 2; do
  env PATH="$BIN:$PATH" HOME="$TR/home" GARDEN_ROOT="$ROOT" GARDEN_STATE="$TR/injected-state" JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 \
    GARDEN_MENTOR_PROVIDER_ORDER=anthropic GARDEN_MENTOR_CLAUDE=claude GARDEN_TOKEN_WEEKLY_QUOTA=0 \
    GARDEN_TEST_ANTHROPIC_OUTPUT='JOB improve-injected\nscripts/jobs/stable.sh\nfix it\nENDJOB\n' "$HANDLER" "$SHA" "$TR/clone" >/dev/null
done
VERIFY="$TR/verify"; git clone -q --branch journal2 "$BARE" "$VERIFY"
[ "$(find "$VERIFY/jobs/todo" -name 'improve-injected.md' | wc -l)" -eq 1 ] \
  && ok "injected handler posts one stable mentor identity" || bad "injected handler duplicated a job"

echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
