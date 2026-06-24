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

  jobfile="$CLONE/$JOBS_DOIN/$base.md"
  report="$(mktemp "${TMPDIR:-/tmp}/garden-report-$base.XXXXXX")"
  # divert the handler's combined stdout+stderr here so a failure can be captured
  # by hash instead of vanishing into this gardener's systemd journal.
  capture="$(mktemp "${TMPDIR:-/tmp}/garden-capture-$base.XXXXXX")"

  # narrate progress into the journal (garden practice), then drain this job
  # doer's directed inbox (unread → read) before working.
  printf 'gardener-%s on %s claimed job %s\n' "$id" "$GARDEN_HOST" "$base" \
    | GARDEN_ROLE=gardener "$HERE/journal-entry.sh" progress || true
  "$HERE/inbox-read.sh" "$base" || true

  log "working '$base'"
  if GARDEN_GARDENER_ID="$id" "$GARDEN_JOB_HANDLER" "$base" "$jobfile" "$report" >"$capture" 2>&1; then
    "$HERE/complete-job.sh" "$id" "$base" "$report"
    printf 'gardener-%s on %s completed job %s\n' "$id" "$GARDEN_HOST" "$base" \
      | GARDEN_ROLE=gardener "$HERE/journal-entry.sh" progress || true
  else
    # The job handler — the gardening state machine / a `claude -p` inner agent —
    # exited non-zero. Its combined stdout+stderr is in $capture. DO NOT discard
    # it (the prior one-line report did) and DO NOT complete the job doin→tada
    # (which records a failure as done). Capture the output by hash and escalate
    # the SHA to the gardener inbox via the canonical helper, then leave the job
    # in `doin` for the reaper's stale-claim requeue (GARDEN_CLAIM_TTL).
    #
    # OPEN — failed-job lane (designs/self-healing-audit.md, maintainer review):
    # whether a failed handler should requeue→todo immediately, move to a
    # dedicated jobs/failed/ lane, or stay in doin for the reaper (current) is a
    # state-machine design decision deliberately left out of this change. Leaving
    # it in doin means a deterministically-failing job is retried after the TTL;
    # which lane is permanent is the question this surfaces.
    log "handler FAILED for '$base'; capturing output and escalating to the gardener inbox (job left in doin for the reaper)"
    sha="$(GARDEN_JOURNAL="$CLONE" "$GARDEN_ROOT/skills/gardener-inbox-error-reporting/report-error.sh" \
             --transcript "$capture" --lane 0 --state handler-nonzero \
             --context "gardener-$id on $GARDEN_HOST: job '$base' handler exited non-zero" \
           2>/dev/null || true)"
    # Fall back to a bare local hash if the inbox-append escalation itself failed,
    # so the output is at least durable in this gardener's clone.
    [ -n "$sha" ] || sha="$(capture_blob "$capture" "$CLONE" 2>/dev/null || echo unknown)"
    # Anchor the capture under refs/captures so an off-host responder can fetch it
    # even if the inbox-append push was lost; best-effort (blob stays local in $CLONE).
    [ "$sha" = unknown ] || anchor_blob "$sha" "gardener/$id/$base" "$CLONE" 2>/dev/null || true
    printf 'gardener-%s on %s: job %s handler FAILED; output captured as %s, escalated to the gardener inbox, left in doin for the reaper\n' \
      "$id" "$GARDEN_HOST" "$base" "$sha" \
      | GARDEN_ROLE=gardener "$HERE/journal-entry.sh" error || true
  fi
  rm -f "$report" "$capture"
done
