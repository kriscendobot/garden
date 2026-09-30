#!/bin/bash
# set-arc-budget.sh — install or replace one journal-backed rolling arc budget.
# Weekly slices are written by set-apportionment.sh (the accountant); this
# schema-1 writer remains for rolling press budgets such as Ironhorse.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$HERE/common.sh"
export GARDEN_TAG="set-arc-budget"

arc="${1:?usage: set-arc-budget.sh <arc> <token-cap> <window-seconds> <press-interval-seconds>}"
cap="${2:?missing token cap}" window="${3:?missing rolling window seconds}" interval="${4:?missing press interval seconds}"
[ $# -eq 4 ] || die "set-arc-budget.sh accepts exactly four arguments"
case "$arc" in -*|*/*|.*|'') die "illegal arc: '$arc'" ;; esac
for pair in "token cap:$cap" "window seconds:$window" "press interval seconds:$interval"; do
  value="${pair#*:}"
  case "$value" in ''|0|*[!0-9]*) die "${pair%%:*} must be a positive integer" ;; esac
done

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"
for attempt in $(seq 1 "${GARDEN_POST_ATTEMPTS:-50}"); do
  sync_clone "$DIR"
  mkdir -p "$DIR/config/arc-budgets"
  jq -n --arg arc "$arc" --arg by "${GARDEN_SENDER:-producer}" \
    --arg at "$(date -u +%FT%TZ)" --argjson cap "$cap" \
    --argjson window "$window" --argjson interval "$interval" \
    '{schema:1,status:"active",arc:$arc,token_cap:$cap,
      window_seconds:$window,press_interval_seconds:$interval,
      set_by:$by,set_at:$at}' > "$DIR/config/arc-budgets/$arc"
  git -C "$DIR" add "config/arc-budgets/$arc"
  rc=0; commit_and_push "$DIR" "budget($arc) cap=$cap window=${window}s press=${interval}s" || rc=$?
  [ "$rc" -eq 0 ] && { log "set arc budget '$arc'"; exit 0; }
  [ "$rc" -eq 2 ] && { log "arc budget '$arc' unchanged"; exit 0; }
  backoff "$attempt"
done
die "could not set arc budget '$arc'"
