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
#   3. a role/scholar broadcast is newer than the schedule's last_dispatched AND
#      carries an actionable scholar marker (an ingest `library_action:` field or
#      a writeback-review request). A fresh but purely informational broadcast
#      (deterministic-projection notice, deploy/leadership announcement) does NOT
#      count — dispatching the LLM on it just drains and exits with nothing.
# Otherwise: no work (exit 2).
#
# Read-only against the board: it reuses common.sh's standing-scan helpers
# (ensure_clone / sync_clone / list_jobs) and never writes or pushes.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="scholar-preflight"

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

# 3. A role/scholar broadcast newer than the schedule's last_dispatched AND
#    carrying an actionable scholar marker. Topic messages are append-only and
#    never deleted, so compare each one's sent_at against the schedule's last
#    successful dispatch stamp; only a FRESH broadcast (arrived since we last ran)
#    is a candidate. Freshness alone is not enough: a purely informational
#    broadcast (a deterministic-projection notice, a deploy/leadership
#    announcement) carries no scholar work, and dispatching the LLM on it just
#    drains and exits with nothing — the exact idle cycle this gate exists to
#    prevent. So a fresh broadcast counts as work ONLY when its body carries an
#    actionable scholar marker, derived from roles/scholar/AGENT.md § Per-job
#    procedure step 2 (which surfaces "library_action: ingest-source asks and
#    writeback-review requests"):
#      * an ingest `library_action:` field (ingest-source and its kin), or
#      * a writeback-review request (the library-lookup "writebacks" handoff).
#    The grep is read-only and fails OPEN: a marker match dispatches, and a grep
#    error (file unreadable — parse ambiguity) also dispatches; only an
#    unambiguous absence of every marker skips a fresh broadcast.
SCHOLAR_ACTIONABLE_RE='^[[:space:]]*library_action:|writeback'
last_iso="$(sed -n 's/^last_dispatched:[[:space:]]*//p' "$DIR/schedules/$name" 2>/dev/null | head -1)"
last=0; [ -n "$last_iso" ] && last="$(date -u -d "$last_iso" +%s 2>/dev/null || echo 0)"
for m in $(list_jobs "$DIR" "msgs/role/scholar"); do
  f="$DIR/msgs/role/scholar/$m"
  [ -f "$f" ] || continue
  sent="$(sed -n 's/^sent_at:[[:space:]]*//p' "$f" | head -1)"
  [ -n "$sent" ] || continue
  sts="$(date -u -d "$sent" +%s 2>/dev/null || echo 0)"
  [ "$sts" -gt "$last" ] || continue
  # Fresh broadcast: dispatch only if it carries an actionable scholar marker
  # (fail open on a grep error, treating an unreadable file as a marker match).
  rc=0; grep -qiE "$SCHOLAR_ACTIONABLE_RE" "$f" 2>/dev/null || rc=$?
  if [ "$rc" -eq 0 ] || [ "$rc" -ge 2 ]; then
    log "work present: actionable role/scholar broadcast $m (sent $sent) newer than last_dispatched ($last_iso)"
    exit 0
  fi
  log "skipping informational role/scholar broadcast $m (sent $sent, no actionable marker)"
done

log "preflight: no work for $name (empty inbox, no scholar-* job, no fresh actionable role/scholar broadcast)"
exit 2
