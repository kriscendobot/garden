#!/bin/bash
# scholar-preflight.sh — deterministic preflight gate for the scholar schedule.
#
# Usage: scholar-preflight.sh <schedule-name>
#   <schedule-name> is the scheduler's schedules/<name> file (e.g.
#   scholar-library-cycle.md); used only to read its last_dispatched stamp.
#
# Wired into schedules/scholar-library-cycle.md as `preflight: scholar-preflight.sh`.
# The scheduler runs this when the cadence has elapsed and acts on the exit code:
#   exit 0 = work present → dispatch the scholar cycle + advance the clock
#   exit 2 = no work      → advance the clock only, dispatch nothing
# (any other exit is treated by the scheduler as work-present — fail open).
#
# This moves the scholar's idle/active decision off the dispatched LLM agent and
# into plain code, eliminating back-to-back idle scholar dispatches while keeping
# instant pickup the moment real work appears. There is work for a scholar cycle
# when ANY of:
#   1. the scholar role inbox (inbox/scholar/unread) is non-empty;
#   2. a claimable scholar-* job sits in jobs/todo/;
#   3. a role/scholar broadcast is newer than the schedule's last_dispatched.
# Otherwise: no work (exit 2).
#
# Read-only against the board: it reuses common.sh's standing-scan helpers
# (ensure_clone / sync_clone / list_jobs) and never writes or pushes.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="scholar-preflight"

name="${1:-scholar-library-cycle.md}"

DIR="${GARDEN_SCHOLAR_PREFLIGHT_CLONE:-$GARDEN_STATE/scholar-preflight/journal}"
ensure_clone "$DIR"
sync_clone "$DIR"

# 1. Scholar role inbox non-empty (directed asks: ingest-source, writeback review).
if [ -n "$(list_jobs "$DIR" "inbox/scholar/unread")" ]; then
  log "work present: scholar inbox has unread message(s)"
  exit 0
fi

# 2. A claimable scholar-* job already on the board.
for j in $(list_jobs "$DIR" "$JOBS_TODO"); do
  case "$j" in
    scholar-*) log "work present: claimable job $j in $JOBS_TODO"; exit 0 ;;
  esac
done

# 3. A role/scholar broadcast newer than the schedule's last_dispatched. Topic
#    messages are append-only and never deleted, so compare each one's sent_at
#    against the schedule's last successful dispatch stamp; only a FRESH broadcast
#    (arrived since we last ran) counts as work.
last_iso="$(sed -n 's/^last_dispatched:[[:space:]]*//p' "$DIR/schedules/$name" 2>/dev/null | head -1)"
last=0; [ -n "$last_iso" ] && last="$(date -u -d "$last_iso" +%s 2>/dev/null || echo 0)"
for m in $(list_jobs "$DIR" "msgs/role/scholar"); do
  f="$DIR/msgs/role/scholar/$m"
  [ -f "$f" ] || continue
  sent="$(sed -n 's/^sent_at:[[:space:]]*//p' "$f" | head -1)"
  [ -n "$sent" ] || continue
  sts="$(date -u -d "$sent" +%s 2>/dev/null || echo 0)"
  if [ "$sts" -gt "$last" ]; then
    log "work present: role/scholar broadcast $m (sent $sent) newer than last_dispatched ($last_iso)"
    exit 0
  fi
done

log "preflight: no work for $name (empty inbox, no scholar-* job, no fresh role/scholar broadcast)"
exit 2
