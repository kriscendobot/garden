#!/bin/bash
# Regression: the journal-fallback meters must bind their `cutoff` argument.
#
# meter_journal_host_tokens / meter_journal_provider_usd each take a third
# positional `cutoff` that both threads into a `jq --argjson cutoff`. A dropped
# `="$3"` in the `local` declaration left `cutoff` unset, so under set -u the
# functions died with `cutoff: unbound variable` the instant a usage ledger
# existed — silently disabling remote-account budget-gating via the journal
# fallback path (2026-08-23). These tests assert the functions return a real
# summed number given a live cutoff, not merely that they exit without error.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-meter-journal-test.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
pass=0; fail=0
ok() { echo "PASS: $*"; pass=$((pass+1)); }
bad() { echo "FAIL: $*"; fail=$((fail+1)); }

# A ledger with two live host rows and one before the cutoff. cutoff is a unix
# epoch; only rows at/after it are summed. Host `h1`: 100+10+5 and 200+20+8 after
# the cutoff; the 999999-token row before the cutoff must be excluded.
mkdir -p "$TR/usage"
CUT="$(date -u -d 2026-08-22T00:00:00Z +%s)"
{
  printf '{"host":"h1","provider":"anthropic","ts":"2026-08-21T00:00:00Z","input_tokens":999999,"output_tokens":0,"cache_creation_tokens":0,"total_cost_usd":9.99}\n'
  printf '{"host":"h1","provider":"anthropic","ts":"2026-08-22T06:00:00Z","input_tokens":100,"output_tokens":10,"cache_creation_tokens":5,"total_cost_usd":1.50}\n'
  printf '{"host":"h1","provider":"anthropic","ts":"2026-08-22T12:00:00Z","input_tokens":200,"output_tokens":20,"cache_creation_tokens":8,"total_cost_usd":2.25}\n'
  printf '{"host":"h2","provider":"openai","ts":"2026-08-22T12:00:00Z","input_tokens":50,"output_tokens":0,"cache_creation_tokens":0,"total_cost_usd":0.75}\n'
} > "$TR/usage/ledger.jsonl"

# meter_journal_host_tokens: 100+10+5 + 200+20+8 = 343, pre-cutoff row excluded.
set +e
HOST_OUT="$(bash -c 'set -u; source "$1/common.sh"; meter_journal_host_tokens "$2" h1 "$3"' _ "$JOBS" "$TR" "$CUT" 2>"$TR/host.err")"
hrc=$?
set -e
if [ "$hrc" -eq 0 ] && [ "$HOST_OUT" = 343 ]; then
  ok "meter_journal_host_tokens sums live rows and binds cutoff (=343)"
else
  bad "host tokens rc=$hrc out='$HOST_OUT' err='$(cat "$TR/host.err")'"
fi

# meter_journal_provider_usd: 1.50+2.25 = 3.75 for anthropic, pre-cutoff excluded.
set +e
USD_OUT="$(bash -c 'set -u; source "$1/common.sh"; meter_journal_provider_usd "$2" anthropic "$3"' _ "$JOBS" "$TR" "$CUT" 2>"$TR/usd.err")"
urc=$?
set -e
if [ "$urc" -eq 0 ] && [ "$USD_OUT" = 3.75 ]; then
  ok "meter_journal_provider_usd sums live rows and binds cutoff (=3.75)"
else
  bad "provider usd rc=$urc out='$USD_OUT' err='$(cat "$TR/usd.err")'"
fi

echo "RESULT: $pass passed, $fail failed"
[ "$fail" -eq 0 ]
