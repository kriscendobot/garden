#!/bin/bash
# Hermetic contract for subscription-keyed quota ownership, resets, rate
# inference, pacing, and the unknown-source refusal.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TEST_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/garden-subscription-budget.XXXXXX")"
trap 'rm -rf "$TEST_ROOT"' EXIT
export GARDEN=endolin-garden-ece02cb4 GARDEN_STATE="$TEST_ROOT/state"
export GARDEN_USAGE_NOW
GARDEN_USAGE_NOW="$(date -u -d 2026-09-20T12:00:00Z +%s)"
# shellcheck source=../common.sh
source "$JOBS/common.sh"

mkdir -p "$TEST_ROOT/config" "$TEST_ROOT/budget/reset-events" \
  "$TEST_ROOT/budget/manual-checkpoints" "$TEST_ROOT/budget/live/claude-oros/oros-studio-garden-ce242c49"
cp "$JOBS/budget-pools-placeholder.tsv" "$TEST_ROOT/config/budget-pools"
cp "$JOBS/subscription-mapping.tsv" "$TEST_ROOT/config/subscription-mapping"

printf '%s\n' \
  '{"subscription_id":"claude-endolin1","event_type":"declared-schedule","cadence":"calendar","schedule_weekday":5,"schedule_time":"20:00","timezone":"America/Los_Angeles","reset_at_precision":"exact","reset_at":"2026-09-19T03:00:00Z"}' \
  '{"subscription_id":"claude-endolin1","event_type":"scheduled-weekly","cadence":"observed","reset_at_precision":"exact","reset_at":"2026-09-19T03:05:00Z","timezone":"UTC"}' \
  > "$TEST_ROOT/budget/reset-events/claude-endolin1.jsonl"
printf '%s\n' \
  '{"subscription_id":"claude-endolin2","event_type":"declared-schedule","cadence":"calendar","schedule_weekday":5,"schedule_time":"20:00","timezone":"America/Los_Angeles","reset_at_precision":"exact","reset_at":"2026-09-19T03:00:00Z"}' \
  > "$TEST_ROOT/budget/reset-events/claude-endolin2.jsonl"
printf '%s\n' \
  '{"subscription_id":"claude-oros","event_type":"declared-schedule","cadence":"calendar","schedule_weekday":2,"schedule_time":"","timezone":"America/Los_Angeles","reset_at_precision":"day","reset_at":null}' \
  > "$TEST_ROOT/budget/reset-events/claude-oros.jsonl"
printf '%s\n' \
  '{"subscription_id":"codex-endolin","event_type":"manual-reset","cadence":"manual","reset_at":"2026-09-20T05:16:19Z","reset_at_precision":"exact","timezone":"UTC"}' \
  > "$TEST_ROOT/budget/reset-events/codex-endolin.jsonl"

[ "$(budget_subscription_for_host_kind endolin-garden-ece02cb4 cleric "$TEST_ROOT")" = codex-endolin ]
[ "$(budget_subscription_for_host_kind endolin-garden2-5bcdff64 cleric "$TEST_ROOT")" = codex-endolin ]
[ "$(budget_subscription_for_host_kind endolin-garden-ece02cb4 gardener "$TEST_ROOT")" = claude-endolin1 ]
! budget_subscription_for_host_kind oros-studio-garden-ce242c49 cleric "$TEST_ROOT" >/dev/null
[[ "$(pool_admission_refusal unknown:openai:oros:cleric "$TEST_ROOT")" == *"ask the maintainer"* ]]

# Calendar facts stay independent; day-only Tuesday still produces a conservative
# end-of-day deadline, while a manual reset never invents a next cadence.
endolin_next="$(subscription_next_reset_epoch claude-endolin1 "$TEST_ROOT" "$GARDEN_USAGE_NOW")"
oros_next="$(subscription_next_reset_epoch claude-oros "$TEST_ROOT" "$GARDEN_USAGE_NOW")"
[ "$endolin_next" != "$oros_next" ]
[ "$(subscription_window_start_epoch claude-endolin1 "$TEST_ROOT" "$GARDEN_USAGE_NOW")" = "$(date -u -d 2026-09-19T03:05:00Z +%s)" ]
! subscription_next_reset_epoch codex-endolin "$TEST_ROOT" "$GARDEN_USAGE_NOW" >/dev/null

# Two usable samples plus a flagged jump: the discontinuity resets the geometric
# baseline, so only the post-jump sample governs instead of being averaged through.
printf '%s\n' \
  '{"subscription_id":"claude-endolin1","checked_at":"2026-09-19T06:00:00Z","weekly_percent":10,"meter_spend_tokens":10000000,"meter_window_start_epoch":1790132400,"pairing_confidence":"high"}' \
  '{"subscription_id":"claude-endolin1","checked_at":"2026-09-19T12:00:00Z","weekly_percent":90,"meter_spend_tokens":50000000,"meter_window_start_epoch":1790132400,"pairing_confidence":"high","notes":"DISCONTINUITY, flagged not smoothed over"}' \
  '{"subscription_id":"claude-endolin1","checked_at":"2026-09-20T06:00:00Z","weekly_percent":20,"meter_spend_tokens":30000000,"meter_window_start_epoch":1790132400,"pairing_confidence":"high"}' \
  > "$TEST_ROOT/budget/manual-checkpoints/claude-endolin1.jsonl"
rate="$(subscription_rate_json claude-endolin1 "$TEST_ROOT")"
[ "$(jq -r .samples <<<"$rate")" -eq 1 ]
[ "$(jq -r .discontinuity_resets <<<"$rate")" -eq 1 ]

# Oros has abundant quota and less than half its own week remaining, so the
# inverse pacing signal is active without a hand-set worker bump.
bias="$(subscription_pacing_bias claude-oros 10000000 73000000 "$TEST_ROOT" "$GARDEN_USAGE_NOW")"
awk -v bias="$bias" 'BEGIN { exit !(bias > 0) }'
oros_weight="$(subscription_allocation_weight 73000000 "$bias")"
awk -v weight="$oros_weight" 'BEGIN { exit !(weight >= 1200000000) }'

fleet="$(budget_fleet_rate_json "$TEST_ROOT")"
[ "$(jq -r '.tokens_per_day_lower_bound > 0' <<<"$fleet")" = true ]
[ "$(jq -r .complete <<<"$fleet")" = false ]
echo "subscription budget model: PASS"
