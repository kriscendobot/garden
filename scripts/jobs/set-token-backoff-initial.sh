#!/bin/bash
# set-token-backoff-initial.sh — CAS-write config/token-backoff-initial, the
# standing token-backoff ramp's initial reserve r0: the high-water fraction each
# pool admits right after its reset, rising linearly to 1.00 at its next reset
# (designs/standing-token-backoff-ramp.md). Absent means 0.50. This is the
# regular-operation control surface; set-token-backoff-fraction.sh is the
# intervention pin.
#
# Usage: set-token-backoff-initial.sh <fraction 0<f<=1>
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="set-token-backoff-initial"

r0="${1:?usage: set-token-backoff-initial.sh <fraction 0<f<=1>}"
[ "$#" -eq 1 ] || { echo "usage: set-token-backoff-initial.sh <fraction 0<f<=1>" >&2; exit 1; }
[[ "$r0" =~ ^0?\.[0-9]+$|^1(\.0+)?$ ]] && awk -v f="$r0" 'BEGIN { exit !(f > 0) }' \
  || { echo "bad fraction '$r0'" >&2; exit 1; }

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"

for attempt in $(seq 1 20); do
  sync_clone "$DIR"
  printf '%s\n' "$r0" > "$DIR/config/token-backoff-initial"
  git -C "$DIR" add config/token-backoff-initial
  rc=0
  commit_and_push "$DIR" "config: token-backoff initial reserve -> $r0" || rc=$?
  case "$rc" in
    0) log "set token-backoff-initial=$r0"; exit 0 ;;
    2) log "no change (already $r0)"; exit 0 ;;
    *) [ "$attempt" -lt 20 ] && continue ;;
  esac
done
echo "FAILED to write token-backoff-initial=$r0 after 20 attempts" >&2
exit 1
