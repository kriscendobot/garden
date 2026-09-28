#!/bin/bash
# foreman-provider-order-test.sh — deterministic provider-order and safety tests
# for the live foreman handler. No inference CLIs or network endpoints are used.
set -euo pipefail
# Explicit positive test-context sentinel: protects this standalone suite even when
# invoked outside the test-tree entrypoint heuristic.
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
ROOT="$(cd "$JOBS/../.." && pwd)"
HANDLER="$JOBS/handlers/foreman-claude.sh"
PASS=0; FAIL=0
ok() { echo "  PASS: $*"; PASS=$((PASS + 1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL + 1)); }
hr() { echo "----------------------------------------------------------------"; }

TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-foreman-provider.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
BIN="$TR/bin"; mkdir -p "$BIN" "$TR/state"
ln -s "$HERE/foreman-provider-fake-codex.sh" "$BIN/codex"
ln -s "$HERE/foreman-provider-fake-curl.sh" "$BIN/curl"
ln -s "$HERE/foreman-provider-fake-claude.sh" "$BIN/claude"
chmod +x "$HERE"/foreman-provider-fake-{codex,curl,claude}.sh "$HERE/foreman-provider-order-test.sh"
DIGEST="$TR/digest"; printf 'project: test\nboard: empty\n' > "$DIGEST"

run_handler() { # <order> [environment assignments...]
  local order="$1"; shift
  env PATH="$BIN:$PATH" HOME="$TR/home" GARDEN_ROOT="$ROOT" GARDEN_STATE="$TR/state" GARDEN_NO_MAINTAINER_ALERT=1 \
    GARDEN_TOKEN_WEEKLY_QUOTA=0 GARDEN_FOREMAN_PROVIDER_ORDER="$order" "$@" "$HANDLER" "$DIGEST"
}

hr; echo "SUBTEST 1 — quota/error advances from OpenAI to Claude"; hr
LOG1="$TR/log1"
if out="$(run_handler openai,anthropic \
  GARDEN_TEST_PROVIDER_LOG="$LOG1" GARDEN_TEST_OPENAI_CODEX_RC=1)"; then
  [ "$out" = $'JOB anthropic-step\nanthropic fallback body\nENDJOB' ] \
    && ok "Claude response is returned after OpenAI failure" \
    || bad "unexpected Claude response: '$out'"
else
  bad "OpenAI failure did not advance to Claude"
fi
[ "$(tr '\n' ' ' < "$LOG1")" = "openai anthropic " ] \
  && ok "attempt order is OpenAI then Claude" \
  || bad "wrong provider attempt order: $(tr '\n' ' ' < "$LOG1")"

rm -rf "$TR/state"; mkdir -p "$TR/state"
hr; echo "SUBTEST 2 — unavailable OpenAI advances to Claude without exec"; hr
LOG2="$TR/log2"
if out="$(run_handler openai,anthropic \
  GARDEN_TEST_PROVIDER_LOG="$LOG2" GARDEN_TEST_CODEX_LOGIN_RC=1)"; then
  [ "$out" = $'JOB anthropic-step\nanthropic fallback body\nENDJOB' ] \
    && ok "Claude receives the final fallback" \
    || bad "unexpected Claude response: '$out'"
else
  bad "availability failure did not advance to Claude"
fi
[ "$(tr '\n' ' ' < "$LOG2")" = "anthropic " ] \
  && ok "OpenAI auth failure skips its exec and reaches Claude" \
  || bad "wrong fallback trace: $(tr '\n' ' ' < "$LOG2")"

rm -rf "$TR/state"; mkdir -p "$TR/state"
hr; echo "RETIRED LOCAL — a stale 'local' entry fails fast at parse time"; hr
for order in openai,local local,anthropic openai,local,anthropic; do
  LOG_LOCAL="$TR/log-local"; : > "$LOG_LOCAL"
  if run_handler "$order" GARDEN_TEST_PROVIDER_LOG="$LOG_LOCAL" \
    >"$TR/local.out" 2>"$TR/local.err"; then
    bad "retired provider order '$order' was accepted"
  else
    ok "retired provider order '$order' is rejected"
  fi
  grep -q "provider 'local' is retired" "$TR/local.err" && grep -q 'retire-local-qwen-hermit-lane' "$TR/local.err" \
    && ok "'$order' refusal names the 2026-09-13 retirement" \
    || bad "'$order' refusal lacks the retirement diagnostic: $(cat "$TR/local.err")"
  [ ! -s "$LOG_LOCAL" ] \
    && ok "'$order' is rejected before any provider is attempted" \
    || bad "'$order' attempted providers before rejecting: $(tr '\n' ' ' < "$LOG_LOCAL")"
done

rm -rf "$TR/state"; mkdir -p "$TR/state"
hr; echo "SUBTEST 3 — malformed semantic output never fans out"; hr
LOG3="$TR/log3"
if run_handler openai,anthropic \
  GARDEN_TEST_PROVIDER_LOG="$LOG3" GARDEN_TEST_OPENAI_OUTPUT='JOB one\nbody\nENDJOB\nJOB two\nbody\nENDJOB\n' \
  >"$TR/malformed.out" 2>"$TR/malformed.err"; then
  bad "malformed multi-job output was accepted"
else
  ok "malformed multi-job output is rejected"
fi
[ "$(tr '\n' ' ' < "$LOG3")" = "openai " ] \
  && ok "semantic rejection does not ask another provider" \
  || bad "semantic rejection fanned out: $(tr '\n' ' ' < "$LOG3")"

hr; echo "SUBTEST 4 — default normal order stays Anthropic-only"; hr
LOG4="$TR/log4"
if out="$(env PATH="$BIN:$PATH" HOME="$TR/home" GARDEN_ROOT="$ROOT" GARDEN_STATE="$TR/state" \
  GARDEN_TOKEN_WEEKLY_QUOTA=0 GARDEN_TEST_PROVIDER_LOG="$LOG4" "$HANDLER" "$DIGEST")"; then
  [ "$out" = $'JOB anthropic-step\nanthropic fallback body\nENDJOB' ] \
    && ok "unset order returns the normal Anthropic response" \
    || bad "unexpected normal response: '$out'"
else
  bad "unset provider order failed"
fi
[ "$(tr '\n' ' ' < "$LOG4")" = "anthropic " ] \
  && ok "unset provider order invokes only Anthropic" \
  || bad "normal order trace: $(tr '\n' ' ' < "$LOG4")"

rm -rf "$TR/state"; mkdir -p "$TR/state"
hr; echo "SUBTEST 5: Moonshot cannot become foreman/default routing"; hr
if run_handler moonshot,anthropic >"$TR/moonshot.out" 2>"$TR/moonshot.err"; then
  bad "Moonshot provider order was accepted"
else
  ok "Moonshot provider order is rejected as explicit-job-only"
fi
grep -q 'explicit-job-only' "$TR/moonshot.err" && ok "routing refusal explains policy" || bad "routing refusal lacks policy diagnostic"

# The Anthropic fake replies through the JSON --output-format branch (a fixed
# block), so drive these accepted-shape cases through the OpenAI/codex fake, which
# emits GARDEN_TEST_OPENAI_OUTPUT verbatim — the same channel SUBTEST 3 uses.
rm -rf "$TR/state"; mkdir -p "$TR/state"
hr; echo "SUBTEST 6 — blank lines around the single block are tolerated"; hr
if out="$(run_handler openai,anthropic GARDEN_TEST_OPENAI_OUTPUT='\n\nJOB fs-a\nfallback body\nENDJOB\n\n')"; then
  [ "$out" = $'JOB fs-a\nfallback body\nENDJOB' ] \
    && ok "leading/trailing blank lines are stripped around the block" \
    || bad "unexpected blank-tolerant output: '$out'"
else bad "blank lines around the block FATALed"; fi

rm -rf "$TR/state"; mkdir -p "$TR/state"
hr; echo "SUBTEST 7 — a prose 'no next step' reply is a no-op, not a FATAL"; hr
if out="$(run_handler openai,anthropic GARDEN_TEST_OPENAI_OUTPUT='No unblocked next step right now.\n' 2>"$TR/noop.err")"; then
  [ -z "$out" ] && ok "prose refusal yields empty no-op output" || bad "prose refusal emitted a block: '$out'"
else bad "prose refusal FATALed"; fi
grep -q 'WARN: foreman reply had no JOB/MAINTAINER block' "$TR/noop.err" && ok "prose refusal is surfaced at WARN" || bad "prose refusal was not WARN-logged"

rm -rf "$TR/state"; mkdir -p "$TR/state"
hr; echo "SUBTEST 8 — whitespace-decorated keyword lines are tolerated"; hr
if out="$(run_handler openai,anthropic GARDEN_TEST_OPENAI_OUTPUT='  JOB fs-b  \n  ROLE builder  \nfallback body\n  ENDJOB  \n')"; then
  [ "$out" = $'JOB fs-b\nROLE builder\nfallback body\nENDJOB' ] \
    && ok "whitespace around JOB/ROLE/ENDJOB is normalized" \
    || bad "unexpected whitespace-tolerant output: '$out'"
else bad "whitespaced keyword lines FATALed"; fi

rm -rf "$TR/state"; mkdir -p "$TR/state"
hr; echo 'SUBTEST 9 — a code-fence wrapping the block is skipped'; hr
if out="$(run_handler openai,anthropic GARDEN_TEST_OPENAI_OUTPUT='```\nJOB fs-c\nfallback body\nENDJOB\n```\n')"; then
  [ "$out" = $'JOB fs-c\nfallback body\nENDJOB' ] \
    && ok "surrounding code fence is tolerated" \
    || bad "unexpected fenced output: '$out'"
else bad "fenced block FATALed"; fi

rm -rf "$TR/state"; mkdir -p "$TR/state"
hr; echo "SUBTEST 10 — a preamble before a MAINTAINER block is skipped"; hr
if out="$(run_handler openai,anthropic GARDEN_TEST_OPENAI_OUTPUT='Here is the situation.\n\nMAINTAINER\nneeds a decision\nENDMAINTAINER\n')"; then
  [ "$out" = $'MAINTAINER\nneeds a decision\nENDMAINTAINER' ] \
    && ok "preamble before a block is skipped" \
    || bad "unexpected preamble output: '$out'"
else bad "preamble + block FATALed"; fi

rm -rf "$TR/state"; mkdir -p "$TR/state"
hr; echo "SUBTEST 11 — malformed multi-job output records a diagnostic"; hr
if run_handler openai,anthropic GARDEN_TEST_OPENAI_OUTPUT='JOB one\nbody\nENDJOB\nJOB two\nbody\nENDJOB\n' \
  >"$TR/fm.out" 2>"$TR/fm.err"; then
  bad "malformed multi-job output was accepted"
else ok "malformed multi-job output still FATALs (fail-closed)"; fi
[ -s "$TR/state/foreman/last-malformed.txt" ] && ok "malformed reply is saved to foreman/last-malformed.txt" || bad "malformed diagnostic was not recorded"
FM_CAP="$(find "$TR/state/foreman/rejected" -name '*-openai.txt' 2>/dev/null | head -1)"
{ [ -n "$FM_CAP" ] && grep -q 'JOB two' "$FM_CAP"; } \
  && ok "malformed reply also saved as a per-failure capture under foreman/rejected/" \
  || bad "durable rejected/ capture missing or lacking the raw output"

hr
echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
