#!/bin/bash
# budget-live-percent-label-test.sh — the per-pool budget-live publisher never
# pairs mismatched units. A percent pool (codex) gates on used_percent against a
# percentage ceiling while spend stays a raw token count; its commit message,
# zone alert, and persisted fields must say so instead of printing
# spend=<tokens>/100. A weekly-tokens pool keeps its spend=<tokens>/<cap-tokens>.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-budget-live-label.XXXXXX")"
trap 'rm -rf "$TR"' EXIT

export GARDEN_TEST=1
export GARDEN=endolin-garden-ece02cb4
export GARDEN_STATE="$TR/state"
GARDEN_USAGE_NOW="$(date -u -d 2026-09-28T07:45:00Z +%s)"
export GARDEN_USAGE_NOW
export GARDEN_CODEX_LOGDIR="$TR/codex"
export GARDEN_CCUSAGE_LOGDIR="$TR/claude"
export GARDEN_BUDGET_PUBLISH_ATTEMPTS=1

D="$TR/journal"
mkdir -p "$D/config" "$D/budget/reset-events" "$GARDEN_CODEX_LOGDIR/2026/09/28" "$GARDEN_CCUSAGE_LOGDIR/p"
git init -q "$D"
printf '%s\n' \
  'claude-endolin1 anthropic weekly-tokens 1000 test-calibrated -' \
  'codex-endolin openai percent 100 codex-cli-rate-limit -' > "$D/config/budget-pools"
printf 'claude-endolin1\t%s\tmonk\ncodex-endolin\t%s\tcleric\n' "$GARDEN" "$GARDEN" > "$D/config/subscription-mapping"
printf '%s\n' \
  '{"subscription_id":"codex-endolin","event_type":"manual-reset","cadence":"manual","reset_at":"2026-09-20T05:16:19Z","reset_at_precision":"exact","timezone":"UTC"}' \
  > "$D/budget/reset-events/codex-endolin.jsonl"
printf '%s\n' \
  '{"subscription_id":"claude-endolin1","event_type":"manual-reset","cadence":"manual","reset_at":"2026-09-26T00:00:00Z","reset_at_precision":"exact","timezone":"UTC"}' \
  > "$D/budget/reset-events/claude-endolin1.jsonl"

# Codex: 48285769 billable tokens at 95% of the plan window.
printf '%s\n' \
  '{"timestamp":"2026-09-28T07:00:00.000Z","type":"event_msg","payload":{"type":"token_count","info":{"last_token_usage":{"input_tokens":48285769,"cached_input_tokens":0,"output_tokens":0}},"rate_limits":{"primary":{"used_percent":95.0},"plan_type":"pro"}}}' \
  > "$GARDEN_CODEX_LOGDIR/2026/09/28/rollout.jsonl"
# Claude: 900 tokens against a 1000-token weekly cap.
printf '%s\n' \
  '{"type":"assistant","timestamp":"2026-09-27T03:00:01Z","message":{"id":"live","usage":{"input_tokens":900,"output_tokens":0,"cache_creation_input_tokens":0,"cache_read_input_tokens":0}}}' \
  > "$GARDEN_CCUSAGE_LOGDIR/p/session.jsonl"

# shellcheck source=../common.sh
source "$JOBS/common.sh"
MSGS="$TR/messages"; ALERTS="$TR/alerts"; : > "$MSGS"; : > "$ALERTS"
commit_and_push() { printf '%s\n' "$2" >> "$MSGS"; return 0; }
alert_maintainer() { printf '%s\n' "$2" >> "$ALERTS"; return 0; }

fail() { echo "FAIL: $*"; echo "--- messages"; cat "$MSGS"; echo "--- alerts"; cat "$ALERTS"; exit 1; }

_budget_publish_local_pool_once "$D" || fail "publication failed"

codex="$D/budget/live/codex-endolin/$GARDEN"
claude="$D/budget/live/claude-endolin1/$GARDEN"
[ -r "$codex" ] || fail "no codex snapshot"
[ -r "$claude" ] || fail "no claude snapshot"

# Percent pool: the label pairs percent with percent, tokens stand alone.
grep -qx "budget-live($GARDEN) backoff spend=95.0%/100% tokens=48285769" "$MSGS" \
  || fail "percent-pool commit message does not pair percent with percent"
grep -q 'spend=[0-9]*/100$' "$MSGS" && fail "a commit message still pairs raw tokens with the percent cap"
grep -qx "subscription codex-endolin changed zone unpublished -> backoff at spend=95.0%/100% tokens=48285769." "$ALERTS" \
  || fail "percent-pool zone alert does not pair percent with percent"
grep -qx 'spend: 48285769' "$codex" || fail "percent snapshot lost the raw token spend"
grep -qx 'spend_unit: tokens' "$codex" || fail "percent snapshot does not name the spend unit"
grep -qx 'cap_percent: 100' "$codex" || fail "percent snapshot does not name the percent ceiling"
grep -q '^cap:' "$codex" && fail "percent snapshot pairs spend: tokens with a percent cap:"
grep -qx 'used_percent: 95.0' "$codex" || fail "percent snapshot lost used_percent"
grep -qx 'status: backoff' "$codex" || fail "percent snapshot gate changed"

# Readers are unchanged: quota-panel's fleet token aggregate and the percent read.
[ "$(meter_remote_snapshot_total "$D" codex-endolin - "$(subscription_window_start_epoch codex-endolin "$D")" 2>/dev/null)" = 48285769 ] \
  || fail "meter_remote_snapshot_total no longer sums the codex token spend"
[ "$(subscription_used_percent codex-endolin "$D")" = 95.0 ] || fail "subscription_used_percent lost the percent"

# Weekly-tokens pool: tokens over token cap, exactly as before.
grep -qx "budget-live($GARDEN) backoff spend=900/1000" "$MSGS" \
  || fail "weekly-tokens commit message changed"
grep -qx 'cap: 1000' "$claude" || fail "weekly-tokens snapshot lost cap:"
grep -q '^spend_unit:\|^cap_percent:' "$claude" && fail "weekly-tokens snapshot grew percent-pool fields"

# An unavailable codex rate-limit reading (-1) is labeled unknown, not -1%.
printf '%s\n' \
  '{"timestamp":"2026-09-28T08:00:00.000Z","type":"event_msg","payload":{"type":"token_count","info":{"last_token_usage":{"input_tokens":1,"cached_input_tokens":0,"output_tokens":0}}}}' \
  >> "$GARDEN_CODEX_LOGDIR/2026/09/28/rollout.jsonl"
GARDEN_USAGE_NOW=$((GARDEN_USAGE_NOW + 3600)); : > "$MSGS"
_budget_publish_local_pool_once "$D" || fail "second publication failed"
grep -qx "budget-live($GARDEN) ok spend=unknown%/100% tokens=48285770" "$MSGS" \
  || fail "unavailable percent is not labeled unknown"

echo 'PASS: budget-live labels pair percent with percent and tokens with tokens'
