#!/bin/bash
# budget-refresh.sh - promote machine-marked budget holds after quota refresh.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG=budget-refresh

fleet_draining && exit 0

DIR="${GARDEN_BUDGET_REFRESH_CLONE:-$GARDEN_STATE/budget-refresh/journal}"
ensure_clone "$DIR"
sync_clone "$DIR"

now="${GARDEN_BUDGET_REFRESH_NOW:-$(date -u +%s)}"
[[ "$now" =~ ^[0-9]+$ ]] || { clone_unlock "$DIR"; die "invalid refresh clock '$now'"; }
quota_status="$(meter_quota_status "anthropic:$GARDEN" "$DIR")"
due=()
due_trigger=()
due_reset_at=()
for name in $(list_jobs "$DIR" "$JOBS_PLAN"); do
  plan="$DIR/$JOBS_PLAN/$name"
  [ "$(plan_field "$plan" park_reason)" = over-token-budget ] || continue
  [ "$(plan_field "$plan" budget_hold)" = true ] || continue
  base="${name%.md}"
  explicit="$(plan_field "$plan" budget_resets_at)"
  if [ -n "$explicit" ]; then
    reset_epoch="$(date -u -d "$explicit" +%s 2>/dev/null || true)"
    if [[ "$reset_epoch" =~ ^[0-9]+$ ]] && [ "$now" -ge "$reset_epoch" ]; then
      due+=("$base")
      due_trigger+=(explicit-reset)
      due_reset_at+=("$explicit")
      continue
    fi
  fi
  parked="$(plan_field "$plan" parked_for_budget_at)"
  parked_epoch="$(date -u -d "$parked" +%s 2>/dev/null || true)"
  reset_epoch=""
  [[ "$parked_epoch" =~ ^[0-9]+$ ]] \
    && reset_epoch="$(meter_next_reset_epoch "$parked_epoch" 2>/dev/null || true)"
  if [[ "$reset_epoch" =~ ^[0-9]+$ ]] \
     && [ "$now" -ge "$reset_epoch" ] \
     && [ "$quota_status" != backoff ]; then
    due+=("$base")
    due_trigger+=(quota-window-or-cap-recovery)
    due_reset_at+=("$(date -u -d "@$reset_epoch" +%FT%TZ)")
  fi
done
clone_unlock "$DIR"

for index in "${!due[@]}"; do
  base="${due[$index]}"
  GARDEN_PRODUCER_CLONE="$DIR" "$HERE/promote-plan.sh" "$base"
  log "promoted budget-held '$base' after quota-window refresh"
  if decision_input_json="$(jq -cn --arg base "$base" \
    --arg trigger "${due_trigger[$index]}" --arg reset_at "${due_reset_at[$index]}" \
    --arg quota_status "$quota_status" \
    '{base:$base,recovery_trigger:$trigger,reset_at:$reset_at,quota_status:$quota_status,prior_gate:"go-ahead",prior_park_reason:"over-token-budget"}')"; then
    record_decision --loop budget-refresh --input-json "$decision_input_json" \
      --decision release-budget-hold \
      --from-json "$(jq -cn --arg value "$JOBS_PLAN/$base.md" '$value')" \
      --to-json "$(jq -cn --arg value "$JOBS_TODO/$base.md" '$value')" \
      --reason "recorded quota back-off elapsed and budget hold became recoverable" \
      --outcome applied --outcome-detail "promote-plan CAS accepted"
  fi
done
