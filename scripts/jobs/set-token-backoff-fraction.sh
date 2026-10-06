#!/bin/bash
# set-token-backoff-fraction.sh — CAS-write or clear the token-backoff
# INTERVENTION override, journal config/token-backoff-fraction.
#
# Usage: set-token-backoff-fraction.sh <fraction> [--until <RFC3339 instant>]
#        set-token-backoff-fraction.sh --clear
#   <fraction>  a number in (0, 1]
#   --until     the pin holds until this instant, then readers resume the ramp.
#               Quota availability never ends it early.
#   --clear     delete the pin; the standing ramp resumes at once.
#
# Regular operation needs no pin: the high-water fraction is the per-pool
# standing ramp computed when read (designs/standing-token-backoff-ramp.md),
# whose only control surface is config/token-backoff-initial. While this file
# exists it pins EVERY pool fleet-wide (precedence: env > this pin > ramp >
# 0.95 fallback), and readers report source=override so a forgotten pin shows.
#
# Still usable as a GARDEN_SCHEDULE_PREFLIGHT hook: it always exits 2 ("no
# work") after a successful write, so the scheduler advances the schedule's
# `once:` entry and posts no job — the write below is the entire effect.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="set-token-backoff-fraction"

usage() { echo "usage: set-token-backoff-fraction.sh <fraction 0<f<=1> [--until <RFC3339>] | --clear" >&2; exit 1; }

frac="" until="" clear=false
while [ "$#" -gt 0 ]; do
  case "$1" in
    --clear) clear=true; shift ;;
    --until) [ "$#" -ge 2 ] || usage; until="$2"; shift 2 ;;
    --until=*) until="${1#--until=}"; shift ;;
    -*) usage ;;
    *) [ -z "$frac" ] || usage; frac="$1"; shift ;;
  esac
done
if $clear; then
  [ -z "$frac" ] && [ -z "$until" ] || usage
else
  [ -n "$frac" ] || usage
  [[ "$frac" =~ ^0?\.[0-9]+$|^1(\.0+)?$ ]] && awk -v f="$frac" 'BEGIN { exit !(f > 0) }' \
    || { echo "bad fraction '$frac'" >&2; exit 1; }
  if [ -n "$until" ]; then
    until_epoch="$(date -u -d "$until" +%s 2>/dev/null)" || { echo "bad --until '$until'" >&2; exit 1; }
    [ "$until_epoch" -gt "$(date +%s)" ] || { echo "--until '$until' is not in the future" >&2; exit 1; }
    until="$(date -u -d "@$until_epoch" +%Y-%m-%dT%H:%M:%SZ)"
  fi
fi

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"

if $clear; then
  what="cleared"; msg="config: clear foreman token-backoff intervention override (standing ramp resumes)"
elif [ -n "$until" ]; then
  what="$frac until $until"; msg="config: foreman token-backoff intervention override -> $frac until $until"
else
  what="$frac"; msg="config: foreman token-backoff intervention override -> $frac"
fi

for attempt in $(seq 1 20); do
  sync_clone "$DIR"
  if $clear; then
    [ -e "$DIR/config/token-backoff-fraction" ] || { log "no override to clear"; exit 2; }
    git -C "$DIR" rm -q config/token-backoff-fraction
  elif [ -n "$until" ]; then
    printf 'fraction: %s\nuntil: %s\n' "$frac" "$until" > "$DIR/config/token-backoff-fraction"
    git -C "$DIR" add config/token-backoff-fraction
  else
    printf '%s\n' "$frac" > "$DIR/config/token-backoff-fraction"
    git -C "$DIR" add config/token-backoff-fraction
  fi
  rc=0
  commit_and_push "$DIR" "$msg" || rc=$?
  case "$rc" in
    0) log "token-backoff override $what"; exit 2 ;;   # done; scheduler posts no job
    2) log "no change (override already $what)"; exit 2 ;;
    *) [ "$attempt" -lt 20 ] && continue ;;
  esac
done
echo "FAILED to write token-backoff override ($what) after 20 attempts" >&2
exit 1
