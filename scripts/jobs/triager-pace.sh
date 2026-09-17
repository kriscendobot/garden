#!/bin/bash
# triager-pace.sh — project the next cost-aware triager wake.
#
# Usage: triager-pace.sh <journal-clone> [role]
#
# The result is one JSON object.  status=paced carries the projected wake;
# status=fallback carries the unchanged timer cadence and a machine-readable
# reason.  This command is deliberately read-only: triager.sh owns the wake
# marker, the deduplicated warning, and the decision-ledger record.
set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"

directory="${1:?usage: triager-pace.sh <journal-clone> [role]}"
role="${2:-triager}"
: "${GARDEN_TRIAGE_PACE_FLOOR_SECONDS:=120}"
: "${GARDEN_TRIAGE_PACE_CEILING_SECONDS:=3600}"
: "${GARDEN_TRIAGE_PACE_SAMPLE_COUNT:=21}"
: "${GARDEN_TRIAGE_PACE_COST_MAX_AGE_SECONDS:=2592000}"
: "${GARDEN_TRIAGE_PACE_SNAPSHOT_MAX_AGE_SECONDS:=${GARDEN_BUDGET_SNAPSHOT_MAX_AGE:-1800}}"

now="${GARDEN_TRIAGE_PACE_NOW:-$(date -u +%s)}"
floor_seconds="$GARDEN_TRIAGE_PACE_FLOOR_SECONDS"
ceiling_seconds="$GARDEN_TRIAGE_PACE_CEILING_SECONDS"
sample_count="$GARDEN_TRIAGE_PACE_SAMPLE_COUNT"
cost_max_age="$GARDEN_TRIAGE_PACE_COST_MAX_AGE_SECONDS"
snapshot_max_age="$GARDEN_TRIAGE_PACE_SNAPSHOT_MAX_AGE_SECONDS"

fallback() {
  local reason="$1"
  jq -cn --arg status fallback --arg role "$role" --arg reason "$reason" \
    --argjson wake "$floor_seconds" --argjson floor "$floor_seconds" \
    --argjson ceiling "$ceiling_seconds" \
    '{status:$status,role:$role,wake_after_seconds:$wake,
      floor_seconds:$floor,ceiling_seconds:$ceiling,reason:$reason}'
  exit 0
}

command -v jq >/dev/null 2>&1 || {
  printf '{"status":"fallback","role":"%s","wake_after_seconds":%s,"floor_seconds":%s,"ceiling_seconds":%s,"reason":"jq-unavailable"}\n' \
    "$role" "$floor_seconds" "$floor_seconds" "$ceiling_seconds"
  exit 0
}
[[ "$now" =~ ^[0-9]+$ ]] || fallback invalid-clock
[[ "$floor_seconds" =~ ^[1-9][0-9]*$ ]] || floor_seconds=120
[[ "$ceiling_seconds" =~ ^[1-9][0-9]*$ ]] || ceiling_seconds=3600
[ "$ceiling_seconds" -ge "$floor_seconds" ] || ceiling_seconds="$floor_seconds"
[[ "$sample_count" =~ ^[1-9][0-9]*$ ]] || sample_count=21
[[ "$cost_max_age" =~ ^[1-9][0-9]*$ ]] || cost_max_age=2592000
[[ "$snapshot_max_age" =~ ^[1-9][0-9]*$ ]] || snapshot_max_age=1800

usage_files=("$directory"/usage/*.jsonl)
[ -e "${usage_files[0]}" ] || fallback missing-cost-ledger

# A CostRecord is one engagement.  The estimator is one JOB cost, so first sum
# all metered engagements for a base, then take the upper median of the newest
# jobs for this role.  Unmetered rows are excluded rather than becoming zeroes.
cost_fold="$(jq -sc --arg role "$role" --argjson limit "$sample_count" '
  [ .[]
    | select(.role == $role and (.base | type) == "string" and .base != "")
    | select((.input_tokens | type) == "number" and .input_tokens >= 0)
    | select((.output_tokens | type) == "number" and .output_tokens >= 0)
    | select((.cache_creation_tokens | type) == "number" and .cache_creation_tokens >= 0)
    | . + {timestamp_epoch: ((.ts // "") | sub("\\.[0-9]+Z$"; "Z") | (fromdateiso8601? // -1)),
           billable: (.input_tokens + .output_tokens + .cache_creation_tokens)} ]
  | group_by(.base)
  | map({base: .[0].base,
         timestamp_epoch: (map(.timestamp_epoch) | max),
         billable: (map(.billable) | add)})
  | map(select(.timestamp_epoch >= 0 and .billable > 0))
  | sort_by(.timestamp_epoch) | reverse | .[:$limit]
  | if length == 0 then empty
    else (sort_by(.billable)) as $rows
      | {estimated_cost_tokens: $rows[($rows|length)/2|floor].billable,
         sample_count: ($rows|length),
         newest_sample_epoch: (map(.timestamp_epoch)|max)}
    end
' "${usage_files[@]}" 2>/dev/null || true)"
[ -n "$cost_fold" ] || fallback missing-role-cost-samples

estimated_cost="$(jq -r '.estimated_cost_tokens' <<<"$cost_fold")"
samples="$(jq -r '.sample_count' <<<"$cost_fold")"
newest_sample_epoch="$(jq -r '.newest_sample_epoch' <<<"$cost_fold")"
[[ "$estimated_cost" =~ ^[1-9][0-9]*$ ]] || fallback invalid-role-cost-samples
[[ "$newest_sample_epoch" =~ ^[0-9]+$ ]] || fallback invalid-role-cost-samples
[ "$newest_sample_epoch" -le $((now + 60)) ] || fallback future-role-cost-samples
[ $((now - newest_sample_epoch)) -le "$cost_max_age" ] || fallback stale-role-cost-samples

pool="anthropic:$GARDEN"
pool_file="$directory/config/budget-pools"
[ -r "$pool_file" ] || fallback missing-pace-calibration
pool_row="$(awk -v wanted="$pool" '
  /^[[:space:]]*#/ || /^[[:space:]]*$/ { next }
  $1 == wanted { print $4 "\t" $5 "\t" $6; found=1; exit }
  END { if (!found) exit 1 }
' "$pool_file" 2>/dev/null || true)"
[ -n "$pool_row" ] || fallback missing-pace-calibration
IFS=$'\t' read -r ceiling_kind weekly_cap calibrated_from <<<"$pool_row"
[ "$ceiling_kind" = weekly-tokens ] || fallback unsupported-pace-calibration
[[ "$weekly_cap" =~ ^[1-9][0-9]*$ ]] || fallback invalid-pace-calibration
pool_provenance_uncalibrated "$calibrated_from" && fallback uncalibrated-pace

live_file="$directory/budget/live/$GARDEN"
[ -r "$live_file" ] || fallback missing-live-pace-input
live_field() { sed -n "s/^$1:[[:space:]]*//p" "$live_file" | head -1; }
live_pool="$(live_field pool)"
live_cap="$(live_field cap)"
weekly_spend="$(live_field spend)"
window_start_epoch="$(live_field window_start_epoch)"
sampled_at_epoch="$(live_field sampled_at_epoch)"
[ "$live_pool" = "$pool" ] && [ "$live_cap" = "$weekly_cap" ] \
  || fallback mismatched-live-pace-input
[[ "$weekly_spend" =~ ^[0-9]+$ ]] && [[ "$window_start_epoch" =~ ^[0-9]+$ ]] \
  && [[ "$sampled_at_epoch" =~ ^[0-9]+$ ]] || fallback invalid-live-pace-input
[ "$sampled_at_epoch" -le $((now + 60)) ] || fallback future-live-pace-input
[ $((now - sampled_at_epoch)) -le "$snapshot_max_age" ] || fallback stale-live-pace-input

expected_window_start="$(meter_week_anchor_epoch "$now" 2>/dev/null || true)"
reset_epoch="$(meter_next_reset_epoch "$now" 2>/dev/null || true)"
[[ "$expected_window_start" =~ ^[0-9]+$ ]] && [ "$window_start_epoch" = "$expected_window_start" ] \
  || fallback stale-reset-epoch
[[ "$reset_epoch" =~ ^[0-9]+$ ]] && [ "$reset_epoch" -gt "$now" ] \
  || fallback stale-reset-epoch

remaining_tokens=$((weekly_cap - weekly_spend))
[ "$remaining_tokens" -ge 0 ] || remaining_tokens=0
seconds_to_reset=$((reset_epoch - now))
input_valid_for_seconds=$((sampled_at_epoch + snapshot_max_age - now))
[ "$input_valid_for_seconds" -ge "$floor_seconds" ] || fallback soon-stale-live-pace-input

# Before the reset, projected release is the sustainable weekly pace multiplied
# by elapsed time.  At the reset a fresh cap becomes available.  Integer
# cross-multiplication keeps the projection deterministic and avoids float drift.
if [ "$remaining_tokens" -gt 0 ] && [ "$estimated_cost" -le "$remaining_tokens" ]; then
  wake_after=$(( (estimated_cost * seconds_to_reset + remaining_tokens - 1) / remaining_tokens ))
elif [ "$estimated_cost" -le $((remaining_tokens + weekly_cap)) ]; then
  wake_after="$seconds_to_reset"
else
  wake_after="$ceiling_seconds"
fi
unclamped_wake="$wake_after"
[ "$wake_after" -ge "$floor_seconds" ] || wake_after="$floor_seconds"
[ "$wake_after" -le "$ceiling_seconds" ] || wake_after="$ceiling_seconds"
[ "$wake_after" -le "$input_valid_for_seconds" ] || wake_after="$input_valid_for_seconds"

allowed_pace="$(awk -v remaining="$remaining_tokens" -v seconds="$seconds_to_reset" \
  'BEGIN { if (seconds <= 0) print 0; else printf "%.9f", remaining / seconds }')"
jq -cn --arg status paced --arg role "$role" --arg pool "$pool" \
  --arg calibrated_from "$calibrated_from" --arg allowed_pace "$allowed_pace" \
  --arg reason "trailing role median projected against sustainable weekly pace and reset" \
  --argjson estimated_cost "$estimated_cost" --argjson samples "$samples" \
  --argjson newest_sample "$newest_sample_epoch" --argjson cap "$weekly_cap" \
  --argjson spend "$weekly_spend" --argjson remaining "$remaining_tokens" \
  --argjson reset "$reset_epoch" --argjson unclamped "$unclamped_wake" \
  --argjson input_valid_for "$input_valid_for_seconds" \
  --argjson wake "$wake_after" --argjson floor "$floor_seconds" \
  --argjson ceiling "$ceiling_seconds" \
  '{status:$status,role:$role,pool:$pool,estimated_cost_tokens:$estimated_cost,
    sample_count:$samples,newest_sample_epoch:$newest_sample,
    weekly_cap:$cap,weekly_spend:$spend,remaining_tokens:$remaining,
    reset_epoch:$reset,input_valid_for_seconds:$input_valid_for,
    allowed_pace_tokens_per_second:($allowed_pace|tonumber),
    unclamped_wake_after_seconds:$unclamped,wake_after_seconds:$wake,
    floor_seconds:$floor,ceiling_seconds:$ceiling,
    calibration_provenance:$calibrated_from,reason:$reason}'
