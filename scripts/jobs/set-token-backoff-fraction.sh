#!/bin/bash
# set-token-backoff-fraction.sh — CAS-write config/token-backoff-fraction.
#
# Usage: set-token-backoff-fraction.sh <fraction>
#   <fraction>  a number in (0, 1]
#
# The deterministic writer for the journal-backed override
# usage-meter.sh reads (env > this file > the 0.85 default). Designed to be
# wired as a GARDEN_SCHEDULE_PREFLIGHT hook (mirrors
# weekly-capacity-calibration.sh's pattern): always exits 2 ("no work") so the
# scheduler advances the schedule's `once:` entry and posts no job — the write
# below is the entire effect.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="set-token-backoff-fraction"

frac="${1:?usage: set-token-backoff-fraction.sh <fraction 0<f<=1>}"
[[ "$frac" =~ ^0?\.[0-9]+$|^1(\.0+)?$ ]] || { echo "bad fraction '$frac'" >&2; exit 1; }

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"

for attempt in $(seq 1 20); do
  sync_clone "$DIR"
  printf '%s\n' "$frac" > "$DIR/config/token-backoff-fraction"
  git -C "$DIR" add config/token-backoff-fraction
  rc=0
  commit_and_push "$DIR" "config: foreman token-backoff-fraction -> $frac (weekend ramp)" || rc=$?
  case "$rc" in
    0) log "set token-backoff-fraction=$frac"; exit 2 ;;   # done; scheduler posts no job
    2) log "no change (already $frac)"; exit 2 ;;
    *) [ "$attempt" -lt 20 ] && continue ;;
  esac
done
echo "FAILED to write token-backoff-fraction=$frac after 20 attempts" >&2
exit 1
