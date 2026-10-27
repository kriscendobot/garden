#!/bin/bash
# set-maintainer-reserve.sh — CAS-write config/maintainer-reserve, k: the share of
# each subscription pool's week reserved for the maintainer's own sessions at the
# window start, decaying to zero at the reset (designs/budget-road.md § The
# model). Absent means 0.50. Writing it ARMS the road's pool verdict even before
# allocation/road.json exists (no lanes; the arcs' part is all discretion), so it
# is a cutover step, seeded as 1 - config/token-backoff-initial.
# The successor of set-token-backoff-initial.sh.
#
# Usage: set-maintainer-reserve.sh <k, 0<=k<0.90>
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="set-maintainer-reserve"

k="${1:?usage: set-maintainer-reserve.sh <k, 0<=k<0.90>}"
[ "$#" -eq 1 ] || { echo "usage: set-maintainer-reserve.sh <k, 0<=k<0.90>" >&2; exit 1; }
[[ "$k" =~ ^0?\.[0-9]+$|^0$ ]] && awk -v k="$k" -v c="$GARDEN_ROAD_CEILING" 'BEGIN { exit !(k >= 0 && k < c) }' \
  || { echo "bad maintainer reserve '$k' (expected 0 <= k < $GARDEN_ROAD_CEILING)" >&2; exit 1; }

DIR="${GARDEN_PRODUCER_CLONE:-$GARDEN_STATE/producer/journal}"
ensure_clone "$DIR"

for attempt in $(seq 1 20); do
  sync_clone "$DIR"
  printf '%s\n' "$k" > "$DIR/config/maintainer-reserve"
  git -C "$DIR" add config/maintainer-reserve
  rc=0
  commit_and_push "$DIR" "config: maintainer reserve k -> $k" || rc=$?
  case "$rc" in
    0) log "set maintainer-reserve=$k"; exit 0 ;;
    2) log "no change (already $k)"; exit 0 ;;
    *) [ "$attempt" -lt 20 ] && continue ;;
  esac
done
echo "FAILED to write maintainer-reserve=$k after 20 attempts" >&2
exit 1
