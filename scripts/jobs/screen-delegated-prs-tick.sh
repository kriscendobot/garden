#!/bin/bash
# Bound and supervise one minion.town screening tick. The screener has its own
# timer because normal host-wide GitHub admission contention can legitimately
# make a complete closed-gate pass longer than the proxy's handler budget.
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="${GARDEN_TAG:-minion-screen}"

: "${GARDEN_SCREEN_TICK_TIMEOUT:=1800}"
: "${GARDEN_SCREEN_TICK_KILL_AFTER:=20}"
: "${GARDEN_SCREEN_TICK_COMMAND:=$HERE/screen-delegated-prs.sh}"

state_dir="$GARDEN_STATE/screening"
timeout_marker="$state_dir/tick-timeout"
failure_key="minion-town-screening-tick-failed-$GARDEN"
mkdir -p "$state_dir"

started="$(date -u +%FT%TZ)"
rc=0
timeout --signal=TERM --kill-after="${GARDEN_SCREEN_TICK_KILL_AFTER}s" \
  "${GARDEN_SCREEN_TICK_TIMEOUT}s" "$GARDEN_SCREEN_TICK_COMMAND" || rc=$?

case "$rc" in
  0)
    if [ -e "$timeout_marker" ]; then
      rm -f "$timeout_marker"
      alert_maintainer_clear "$failure_key" \
        "minion.town screening on $GARDEN completed after a bounded tick overrun."
    fi
    exit 0
    ;;
  124|137)
    printf 'started_at: %s\nobserved_at: %s\nrc: %s\ntimeout_seconds: %s\n' \
      "$started" "$(date -u +%FT%TZ)" "$rc" "$GARDEN_SCREEN_TICK_TIMEOUT" \
      > "$timeout_marker.tmp.$$"
    mv -f "$timeout_marker.tmp.$$" "$timeout_marker"
    log "WARN: minion.town screening tick exceeded ${GARDEN_SCREEN_TICK_TIMEOUT}s (rc=$rc); bounded and retrying on its next dedicated timer tick"
    alert_maintainer "$failure_key" "minion.town screening on $GARDEN exceeded its dedicated ${GARDEN_SCREEN_TICK_TIMEOUT}s tick bound (rc=$rc; started $started).

The tick was terminated and will retry from fresh GitHub and journal state on its next timer activation. No screening gate was bypassed and the delegation was not resumed.
Runbook: context/operations/minion-town-screening.md"
    # The overrun is fully surfaced and is retryable. Keep the timer healthy so
    # systemd schedules the next activation rather than leaving a failed unit.
    exit 0
    ;;
  *)
    exit "$rc"
    ;;
esac
