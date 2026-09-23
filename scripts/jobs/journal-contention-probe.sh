#!/bin/bash
# journal-contention-probe.sh — read-only host-local contention summary.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
# shellcheck source=journal-contention-lib.sh
source "$HERE/journal-contention-lib.sh"
: "${GARDEN_CONTENTION_STATE:=$GARDEN_STATE/journal-contention-watch}"
: "${GARDEN_CONTENTION_WINDOW:=256}"
: "${GARDEN_CONTENTION_CADENCE:=300}"
: "${GARDEN_CONTENTION_MAX_AGE:=21600}"

ring() { printf '%s/%s/%s\n' "$GARDEN_CONTENTION_DIR" "$1" "$2"; }
now="$(date -u +%s)"
export JC_SINCE=$(( now - GARDEN_CONTENTION_MAX_AGE ))  # the checker's sample age-out
tick="$(jc_field "$GARDEN_CONTENTION_STATE/heartbeat" epoch)"
case "$tick" in ''|*[!0-9]*) heartbeat_age=-1;; *) heartbeat_age=$(( now - tick ));; esac
latch=off
if [ -f "$GARDEN_JOURNAL_OUTAGE_MARKER" ]; then
  expiry="$(head -1 "$GARDEN_JOURNAL_OUTAGE_MARKER" 2>/dev/null || echo 0)"
  case "$expiry" in ''|*[!0-9]*) expiry=0;; esac
  [ "$expiry" -gt "$now" ] && latch="on(expiry=$expiry)"
fi

printf 'clone\tlock_p50_s\tlock_p95_s\tfetch_p50_s\tfetch_p95_s\tfetch_cap_s\tpush_p50\tpush_p95\tpush_classes(cas/server/definite)\tbytes\tpacks\tgc_log\n'
while IFS= read -r slug; do
  [ -n "$slug" ] || continue
  IFS=$'\t' read -r _ lp50 lp95 _ _ _ _ _ _ _ <<< "$(jc_numeric_stats "$(ring lock-wait "$slug")" 1000000)"
  IFS=$'\t' read -r _ fp50 fp95 _ _ _ _ _ _ _ <<< "$(jc_numeric_stats "$(ring fetch "$slug")" 1000000)"
  IFS=$'\t' read -r _ pp50 pp95 _ _ _ _ _ _ _ <<< "$(jc_numeric_stats "$(ring push-attempts "$slug")" 1)"
  cas="$(jc_ring_count "$(ring push-class "$slug")" cas)"
  server="$(jc_ring_count "$(ring push-class "$slug")" server-reject)"
  definite="$(jc_ring_count "$(ring push-class "$slug")" definite-fail)"
  clone=""; if jc_resolve_clone "$slug"; then clone="$JC_FOUND_CLONE"; fi
  if [ -n "$clone" ]; then IFS=$'\t' read -r bytes packs gclog <<< "$(jc_clone_metrics "$clone")"; else bytes=0; packs=0; gclog=0; fi
  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s/%s/%s\t%s\t%s\t%s\n' \
    "${clone:-$slug}" "$lp50" "$lp95" "$fp50" "$fp95" "$GARDEN_FETCH_TIMEOUT" \
    "$pp50" "$pp95" "$cas" "$server" "$definite" "$bytes" "$packs" "$gclog"
done < <(jc_all_slugs | LC_ALL=C sort -u)

skips="$(jc_ring_count "$(ring outage-skip host)")"
printf 'host\toutage_skips=%s\tlatch=%s\tchecker_heartbeat_age_s=%s\n' "$skips" "$latch" "$heartbeat_age"
if [ "$heartbeat_age" -lt 0 ] || [ "$heartbeat_age" -gt $(( 3 * GARDEN_CONTENTION_CADENCE )) ]; then
  printf 'alert\tjournal-contention-checker-stale\n'
fi
