#!/bin/bash
# augment-usage-session-delta-test.sh — augment_usage_with_session_delta closes the
# nested-`claude -p` metering hole: a panel job (delta >> envelope) is rewritten from
# the complete session delta; a plain job (delta ~= envelope) keeps its exact envelope.
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok() { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }

command -v jq >/dev/null 2>&1 || { echo "jq absent; skipping"; exit 0; }
export GARDEN_STATE="${TMPDIR:-/tmp}/augment-test-state"
# shellcheck source=../usage-meter.sh
source "$JOBS/usage-meter.sh"

TD="$(mktemp -d "${TMPDIR:-/tmp}/augment.XXXXXX")"; trap 'rm -rf "$TD"' EXIT

# --- panel job: nested seats blow the delta far past the top-level envelope -----
f="$TD/panel.json"
printf '%s\n' '{"source":"result","model":"claude-opus-4-8","input_tokens":100,"output_tokens":20,"cache_creation_tokens":5,"cache_read_tokens":3,"total_cost_usd":0.10,"num_turns":2,"cpu_user_ms":1234}' > "$f"
# before = top-level not yet run (0); after = top-level + ~30 seats
before=$'0\t0\t0\t0'
after=$'4000\t800\t200\t9000'
augment_usage_with_session_delta "$f" "$before" "$after" "claude-opus-4-8"
if jq -e '.source=="session-augmented" and .input_tokens==4000 and .output_tokens==800 and .cache_creation_tokens==200 and .cache_read_tokens==9000' "$f" >/dev/null; then
  ok "panel job rewritten from the complete session delta"
else bad "panel not augmented: $(cat "$f")"; fi
jq -e 'has("total_cost_usd")|not' "$f" >/dev/null \
  && ok "total_cost_usd dropped (nested seats span models, unpriced)" || bad "cost not dropped: $(cat "$f")"
jq -e '.model=="claude-opus-4-8" and .num_turns==2 and .cpu_user_ms==1234' "$f" >/dev/null \
  && ok "envelope model / num_turns / rusage preserved" || bad "envelope fields lost: $(cat "$f")"

# --- plain job: delta ~= envelope, so the exact provider envelope is untouched --
g="$TD/plain.json"
printf '%s\n' '{"source":"result","model":"claude-opus-4-8","input_tokens":1000,"output_tokens":200,"cache_creation_tokens":50,"cache_read_tokens":30,"total_cost_usd":0.42}' > "$g"
before=$'0\t0\t0\t0'
after=$'1000\t200\t50\t30'   # single top-level session only
augment_usage_with_session_delta "$g" "$before" "$after" "claude-opus-4-8"
if jq -e '.source=="result" and .total_cost_usd==0.42 and .input_tokens==1000' "$g" >/dev/null; then
  ok "plain job keeps its exact envelope (source result, dollars intact)"
else bad "plain job wrongly rewritten: $(cat "$g")"; fi

# --- malformed inputs are a no-op (best-effort, never fatal) --------------------
h="$TD/mal.json"; printf '%s\n' '{"source":"result","input_tokens":10}' > "$h"
augment_usage_with_session_delta "$h" "not-a-tsv" "also-bad" "" && ok "bad TSV -> no-op (rc 0)" || bad "bad TSV aborted"
jq -e '.source=="result" and .input_tokens==10' "$h" >/dev/null && ok "file untouched on bad input" || bad "file mutated: $(cat "$h")"

# absent usage file (/dev/null) is a clean no-op
augment_usage_with_session_delta /dev/null "$before" "$after" "" && ok "/dev/null usage file -> no-op" || bad "/dev/null aborted"

echo "augment-usage-session-delta-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
