#!/bin/bash
# gardener.sh — a consumer worker. Claims jobs off the board and works them.
#
# Usage: gardener.sh <id>
#
# Loop: claim one job (todo→doin, CAS) → run the job handler in a per-basename
# context → complete (doin→tada report). On an empty board it sleeps and
# retries; set GARDEN_ONESHOT=1 to exit when the board drains (used by tests
# and by a timer-rearmed deployment that prefers short-lived runs).
#
# The actual work is delegated to GARDEN_JOB_HANDLER, invoked as:
#     $GARDEN_JOB_HANDLER <basename> <job-file> <report-out>
# where <job-file> is the claimed job in this gardener's journal clone and
# <report-out> is a path the handler must fill with the completion report.
# The default handler dispatches `claude -p` wearing the gardener role; the
# test harness overrides it with a fast stub.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"

id="${1:?usage: gardener.sh <id>}"
GARDEN_TAG="gardener/$id"

export GARDEN_GARDENER_CLONE="${GARDEN_GARDENER_CLONE:-$GARDEN_STATE/gardeners/$id/journal}"
CLONE="$GARDEN_GARDENER_CLONE"

: "${GARDEN_IDLE_SLEEP:=5}"
: "${GARDEN_ONESHOT:=0}"
: "${GARDEN_JOB_HANDLER:=$HERE/handlers/gardener-claude.sh}"

log "starting (clone=$CLONE handler=$GARDEN_JOB_HANDLER oneshot=$GARDEN_ONESHOT)"

idle_rounds=0
while :; do
  if killswitch_engaged; then log "killswitch engaged; exiting cleanly"; exit 0; fi

  # monitor the bus for anything addressed to this role or broadcast, every loop
  "$HERE/read-msgs.sh" "gardener-$id" "role/gardener" "broadcast" || true

  set +e
  base="$("$HERE/claim-job.sh" "$id")"; rc=$?
  set -e

  if [ "$rc" -eq 3 ]; then
    if [ "$GARDEN_ONESHOT" = "1" ]; then
      idle_rounds=$((idle_rounds+1))
      # two clean empty passes => board is drained; exit.
      [ "$idle_rounds" -ge 2 ] && { log "board drained; exiting (oneshot)"; exit 0; }
    fi
    sleep "$GARDEN_IDLE_SLEEP"
    continue
  fi
  [ "$rc" -ne 0 ] && die "claim failed (rc=$rc)"
  idle_rounds=0

  jobfile="$CLONE/$JOBS_DOIN/$base"
  report="$(mktemp "${TMPDIR:-/tmp}/garden-report-$base.XXXXXX")"

  # narrate progress into the journal (garden practice), then drain this job
  # doer's directed inbox (unread → read) before working.
  printf 'gardener-%s on %s claimed job %s\n' "$id" "$GARDEN_HOST" "$base" \
    | GARDEN_ROLE=gardener "$HERE/journal-entry.sh" progress || true
  "$HERE/inbox-read.sh" "$base" || true

  log "working '$base'"
  if GARDEN_GARDENER_ID="$id" "$GARDEN_JOB_HANDLER" "$base" "$jobfile" "$report"; then
    "$HERE/complete-job.sh" "$id" "$base" "$report"
  else
    log "handler FAILED for '$base'; writing a failure report and completing"
    { echo "# $base — FAILED"; echo; echo "handler exited non-zero at $(date -u +%FT%TZ) on $GARDEN_HOST/gardener-$id"; } > "$report"
    "$HERE/complete-job.sh" "$id" "$base" "$report"
  fi
  printf 'gardener-%s on %s completed job %s\n' "$id" "$GARDEN_HOST" "$base" \
    | GARDEN_ROLE=gardener "$HERE/journal-entry.sh" progress || true
  rm -f "$report"
done
