#!/bin/bash
# budget-refresh.sh - promote machine-marked budget holds after quota refresh.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG=budget-refresh

fleet_draining && exit 0

DIR="${GARDEN_BUDGET_REFRESH_CLONE:-$GARDEN_STATE/budget-refresh/journal}"
ensure_clone "$DIR"
sync_clone "$DIR"

now="${GARDEN_BUDGET_REFRESH_NOW:-$(date -u +%s)}"
[[ "$now" =~ ^[0-9]+$ ]] || { clone_unlock "$DIR"; die "invalid refresh clock '$now'"; }
quota_status="$(meter_quota_status)"
due=()
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
      continue
    fi
  fi
  parked="$(plan_field "$plan" parked_for_budget_at)"
  parked_epoch="$(date -u -d "$parked" +%s 2>/dev/null || true)"
  window="$(plan_field "$plan" budget_window_seconds)"
  [[ "$window" =~ ^[1-9][0-9]*$ ]] || window="$GARDEN_TOKEN_WINDOW_SECS"
  if [[ "$parked_epoch" =~ ^[0-9]+$ ]] \
     && [ "$now" -ge $((parked_epoch + window)) ] \
     && [ "$quota_status" != backoff ]; then
    due+=("$base")
  fi
done
clone_unlock "$DIR"

for base in "${due[@]}"; do
  GARDEN_PRODUCER_CLONE="$DIR" "$HERE/promote-plan.sh" "$base"
  log "promoted budget-held '$base' after quota-window refresh"
done
