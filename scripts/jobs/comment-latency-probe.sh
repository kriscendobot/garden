#!/bin/bash
# comment-latency-probe.sh — read-only summary of ack latency and watcher health.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
: "${GARDEN_COMMENT_LATENCY_STATE:=$GARDEN_STATE/comment-latency-watch}"
field() { sed -n "s/^$2: *//p" "$1" 2>/dev/null | head -1 || true; }
iso_epoch() { [ -n "${1:-}" ] && date -u -d "$1" +%s 2>/dev/null || printf '0\n'; }

if [ "${1:-}" = --live ]; then
  rows="$(mktemp)"; live_state="$(mktemp -d)"
  cleanup_live_probe() {
    rm -f "$rows"
    case "$live_state" in "${TMPDIR:-/tmp}"/*|/tmp/*) rm -rf "$live_state" ;; esac
  }
  trap 'cleanup_live_probe' EXIT
  GARDEN_COMMENT_LATENCY_STATE="$live_state" "$HERE/comment-latency-watch.sh" --report-only > "$rows"
  printf 'repo\tp50_s\tp95_s\tsamples\tstates\n'
  cut -f1 "$rows" | sort -u | while IFS= read -r repo; do
    values="$(awk -F '\t' -v repo="$repo" '$1 == repo && $3 ~ /^[0-9]+$/ { print $3 }' "$rows" | sort -n)"
    count="$(printf '%s\n' "$values" | grep -c . || true)"
    if [ "$count" -gt 0 ]; then
      p50i=$(( (count + 1) / 2 )); p95i=$(( (95 * count + 99) / 100 ))
      p50="$(printf '%s\n' "$values" | sed -n "${p50i}p")"
      p95="$(printf '%s\n' "$values" | sed -n "${p95i}p")"
    else p50=-; p95=-; fi
    states="$(awk -F '\t' -v repo="$repo" '$1 == repo { n[$2]++ } END { for (s in n) printf "%s%s=%s", sep, s, n[s]; sep="," }' "$rows")"
    printf '%s\t%s\t%s\t%s\t%s\n' "$repo" "$p50" "$p95" "$count" "${states:-no-samples}"
  done
  exit 0
fi

now="$(date -u +%s)"
printf 'repo\tp50_s\tp95_s\tsamples\tlast_ack\theartbeat\theartbeat_age_s\n'
declare -A SLUGS=()
for path in "$GARDEN_COMMENT_LATENCY_STATE"/stats/* "$GARDEN_STATE"/comment-watcher/heartbeat/*; do
  [ -f "$path" ] && SLUGS["$(basename "$path")"]=1
done
for slug in "${!SLUGS[@]}"; do
  stats="$GARDEN_COMMENT_LATENCY_STATE/stats/$slug"
  repo="$(field "$stats" repo)"; [ -n "$repo" ] || repo="$slug"
  p50="$(field "$stats" p50)"; p95="$(field "$stats" p95)"
  count="$(field "$stats" sample_count)"; last="$(field "$stats" last_ack_at)"
  hb="$GARDEN_STATE/comment-watcher/heartbeat/$slug"
  outcome="$(field "$hb" outcome)"; tick="$(field "$hb" last_tick_at)"
  tick_epoch="$(iso_epoch "$tick")"
  [ "$tick_epoch" -gt 0 ] && age=$(( now - tick_epoch )) || age=-1
  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' "$repo" "${p50:--}" "${p95:--}" "${count:-0}" "${last:--}" "${outcome:-missing}" "$age"
done

for watcher in issue-inbox-watcher/heartbeat/garden mention-watcher/heartbeat/github-wide; do
  hb="$GARDEN_STATE/$watcher"; [ -f "$hb" ] || continue
  outcome="$(field "$hb" outcome)"; tick="$(field "$hb" last_tick_at)"
  tick_epoch="$(iso_epoch "$tick")"
  [ "$tick_epoch" -gt 0 ] && age=$(( now - tick_epoch )) || age=-1
  printf '%s\t-\t-\t0\t-\t%s\t%s\n' "${watcher%%/*}" "${outcome:-missing}" "$age"
done

checker="$GARDEN_COMMENT_LATENCY_STATE/heartbeat"; tick="$(field "$checker" last_tick_at)"
tick_epoch="$(iso_epoch "$tick")"
[ "$tick_epoch" -gt 0 ] && age=$(( now - tick_epoch )) || age=-1
printf 'checker\tlast_tick=%s\tage_s=%s\n' "${tick:-missing}" "$age"
