#!/bin/bash
# Structured Claude stream classification, quota telemetry, and call ceilings.
set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/tmp}/claude-stream-signal.XXXXXX")"; trap 'rm -rf "$TR"' EXIT
export GARDEN=signal-host GARDEN_STATE="$TR/state"
source "$JOBS/common.sh"
P=0 F=0
ok(){ echo "  PASS: $*"; P=$((P+1)); }
bad(){ echo "  FAIL: $*"; F=$((F+1)); }
assert_outcome(){ local want="$1" json="$2"; [ "$(claude_result_outcome "$json")" = "$want" ] && ok "$want classified" || bad "$want classification"; }

clean='{"type":"result","subtype":"success","is_error":false,"stop_reason":"end_turn","terminal_reason":"end_turn","result":"done"}'
quota='{"type":"result","subtype":"error_during_execution","is_error":true,"api_error_status":429,"terminal_reason":"rate_limit","result":"quota exceeded"}'
api='{"type":"result","subtype":"error_during_execution","is_error":true,"api_error_status":500,"terminal_reason":"api_error"}'
policy='{"type":"result","subtype":"error","is_error":true,"permission_denials":[{"tool":"Bash"}],"terminal_reason":"permission_denied"}'
budget='{"type":"result","subtype":"error_max_budget_usd","is_error":true,"terminal_reason":"budget_exhausted"}'
assert_outcome complete-candidate "$clean"
assert_outcome quota-cut "$quota"
assert_outcome api-error "$api"
assert_outcome policy-refusal "$policy"
assert_outcome budget-stop "$budget"

printf '%s\n%s\n' '{"type":"system"}' "$clean" > "$TR/good.jsonl"
[ "$(claude_stream_result "$TR/good.jsonl")" = "$clean" ] && ok "valid stream yields terminal result" || bad "valid stream parse"
printf '%s\n%s\n' '{"type":"system"}' '{"type":"assistant"' > "$TR/truncated.jsonl"
claude_stream_result "$TR/truncated.jsonl" >/dev/null 2>&1 && bad "truncated stream accepted" || ok "truncated stream rejected"
# A resumed session that had left a background task armed first emits a zero-turn
# result for that task's stale notification, then the real result for our prompt.
# The notification result is not the answer; it must not invalidate the stream.
notif='{"type":"result","subtype":"success","is_error":false,"num_turns":0,"stop_reason":null,"result":"","origin":{"kind":"task-notification"}}'
printf '%s\n%s\n%s\n' '{"type":"system"}' "$notif" "$clean" > "$TR/notified.jsonl"
[ "$(claude_stream_result "$TR/notified.jsonl")" = "$clean" ] && ok "task-notification result is excluded; the prompt's result is terminal" \
  || bad "stale task-notification result invalidated the resumed stream"
printf '%s\n' "$notif" > "$TR/notif-only.jsonl"
claude_stream_result "$TR/notif-only.jsonl" >/dev/null 2>&1 && bad "notification-only stream accepted" || ok "notification-only stream rejected"
printf '%s\n%s\n' "$clean" "$clean" > "$TR/double.jsonl"
claude_stream_result "$TR/double.jsonl" >/dev/null 2>&1 && bad "two prompt results accepted" || ok "two prompt results still rejected"
printf '%s\n' '{"type":"assistant"}' > "$TR/missing.jsonl"
claude_stream_result "$TR/missing.jsonl" >/dev/null 2>&1 && bad "missing-result stream accepted" || ok "missing-result stream rejected"

rate='{"type":"rate_limit_event","rate_limit_info":{"status":"allowed","resetsAt":1790061600,"rateLimitType":"five_hour","overageStatus":"rejected","overageDisabledReason":"org_level_disabled","isUsingOverage":false,"unifiedWindows":{"five_hour":{"utilization":0.15,"resetsAt":1790061600},"seven_day":{"utilization":0.40,"resetsAt":1790391600}}}}'
usage_capture_result "$TR/measurement.json" claude-opus-4-8 "$quota"
usage_capture_rate_limit "$TR/measurement.json" "$rate"
jq -e '.terminal.api_error_status==429 and .rate_limit.seven_day.utilization==0.40 and .rate_limit.overage_status=="rejected"' "$TR/measurement.json" >/dev/null \
  && ok "ledger handoff retains terminal and quota fields" || bad "ledger handoff fields"

mkdir -p "$TR/journal/usage" "$TR/journal/config" "$TR/journal/budget/reset-events"
printf '%s\n' 'anthropic:test anthropic weekly-tokens 73000000 measured' > "$TR/journal/config/budget-pools"
printf '%s\n' 'anthropic:test signal-host monk' > "$TR/journal/config/subscription-mapping"
printf '%s\n' '{"cadence":"calendar","schedule_weekday":2,"schedule_time":"00:00","timezone":"UTC","reset_at":"2026-09-22T00:00:00Z"}' > "$TR/journal/budget/reset-events/anthropic:test.jsonl"
jq -cn --arg ts "$(date -u +%FT%TZ)" --argjson rate "$(jq -c '.rate_limit' "$TR/measurement.json")" \
  '{ts:$ts,provider:"anthropic",rate_limit:$rate}' > "$TR/journal/usage/probe.jsonl"
GARDEN_USAGE_NOW="$(date -u +%s)"; export GARDEN_USAGE_NOW
[ "$(subscription_used_percent anthropic:test "$TR/journal")" = 40 ] && ok "true seven-day utilization is primary budget sensor" || bad "true utilization sensor"
[ "$(meter_quota_status anthropic:test "$TR/journal")" = ok ] && ok "pool admission consumes real utilization" || bad "pool admission real utilization"
[ "$(claude_call_budget_usd minion "$TR/journal")" = 6.00 ] && ok "minion ceiling scales USD 10 by 60% headroom" || bad "headroom-scaled call ceiling"

echo "claude-stream-signal-test: $P passed, $F failed"
[ "$F" -eq 0 ]
