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

# Busy marker — a local, lock-free signal that this gardener is mid-job. The
# deliberate deploy (deploy-garden.sh) reads these markers to know when the fleet
# has QUIESCED before it merges, and the shared restart (deploy-restart.sh) uses
# the same marker to restart a gardener BETWEEN claims, never mid-job.
# Present only while a handler runs; absent while idle/between claims.
# Cleared at startup so a marker stranded by a hard crash (the gardener was killed
# before it could clear it) can never permanently exempt this id from re-exec — a
# fresh process is, by definition, not yet mid-job.
# Path comes from the shared helper (common.sh) so the writer here and the readers
# in deploy-sync.sh / install-units.sh scale agree on one definition of "mid-job".
BUSY_MARKER="$(gardener_busy_marker "$id")"
mkdir -p "$(dirname "$BUSY_MARKER")" 2>/dev/null || true
rm -f "$BUSY_MARKER" 2>/dev/null || true

log "starting (clone=$CLONE handler=$GARDEN_JOB_HANDLER oneshot=$GARDEN_ONESHOT)"

idle_rounds=0
while :; do
  if fleet_draining; then log "fleet draining; exiting cleanly"; exit 0; fi

  # Top of the loop is a between-claims point: clear the busy marker so the deploy
  # reconciler may restart this gardener now (it re-exec's onto landed script
  # fixes). The marker is re-set just before the handler runs, below.
  rm -f "$BUSY_MARKER" 2>/dev/null || true

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
  # A transient DNS/connectivity outage during the claim's sync_clone fetch
  # propagates up as GARDEN_OFFLINE_RC (EX_TEMPFAIL, default 75) from
  # common.sh:sync_clone — the offline-tick signal that GARDEN_OFFLINE_RC was
  # designed to make a clean skip-and-retry. A raw git 128 can ALSO still escape
  # the classification on a momentary blip (a ref inconsistency whose stderr the
  # offline signatures do not match); treat it the same way as a belt rather than
  # dying. Treat both like the empty-board case: log, sleep, and retry next tick.
  # Do NOT die (a self-resolving blip would otherwise crash-loop the worker and
  # burn a self-heal responder), and do NOT increment idle_rounds (an offline
  # tick is not a drained board for ONESHOT).
  if [ "$rc" -eq "${GARDEN_OFFLINE_RC:-75}" ] || [ "$rc" -eq 128 ]; then
    log "claim transiently offline (rc=$rc); sleeping and retrying"
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

  # Mark this gardener mid-job so a deploy (deploy-garden.sh quiesce / the shared
  # deploy-restart busy-gate) defers restarting it until it next goes idle
  # (cleared at the top of the next loop iteration).
  : > "$BUSY_MARKER" 2>/dev/null || true

  log "working '$base'"
  if GARDEN_GARDENER_ID="$id" "$GARDEN_JOB_HANDLER" "$base" "$jobfile" "$report" >"$capture" 2>&1; then
    # complete-job.sh runs sync_clone, which exits GARDEN_OFFLINE_RC on a
    # transient outage — under set -e that would crash the worker on a blip after
    # the handler already succeeded. Tolerate the offline rc: the job stays in
    # doin and the reaper requeues it after GARDEN_CLAIM_TTL; the handler's work
    # is idempotent on re-claim. Any other non-zero is still a real failure.
    set +e
    "$HERE/complete-job.sh" "$id" "$base" "$report"; crc=$?
    set -e
    if [ "$crc" -eq "${GARDEN_OFFLINE_RC:-75}" ]; then
      log "offline during completion of '$base' (rc=$crc); left in doin for TTL requeue"
      rm -f "$report" "$capture"
      sleep "$GARDEN_IDLE_SLEEP"
      continue
    fi
    [ "$crc" -ne 0 ] && die "complete-job failed for '$base' (rc=$crc)"
    printf 'gardener-%s on %s completed job %s\n' "$id" "$GARDEN_HOST" "$base" \
      | GARDEN_ROLE=gardener "$HERE/journal-entry.sh" progress || true
  else
    rc=$?  # exit code of the failed handler — capture FIRST, before any command clobbers $?
    # The job handler — the gardening state machine / a `claude -p` inner agent —
    # exited non-zero. Its combined stdout+stderr is in $capture. DO NOT discard
    # it (the prior one-line report did) and DO NOT complete the job doin→tada
    # (which records a failure as done). Classify the failure (below) and, for a
    # real diagnostic, capture the output by hash and escalate the SHA to the
    # gardener inbox via the canonical helper; either way leave the job in `doin`
    # for the reaper's stale-claim requeue (GARDEN_CLAIM_TTL).
    #
    # OPEN — failed-job lane (designs/self-healing-audit.md, maintainer review):
    # whether a failed handler should requeue→todo immediately, move to a
    # dedicated jobs/failed/ lane, or stay in doin for the reaper (current) is a
    # state-machine design decision deliberately left out of this change. Leaving
    # it in doin means a deterministically-failing job is retried after the TTL;
    # which lane is permanent is the question this surfaces.
    log "handler FAILED (rc=$rc) for '$base'; capturing output and classifying transient-vs-real (job left in doin for the reaper)"
    # Most handlers (the default handlers/gardener-claude.sh among them) write their
    # real output to $report, not to their own stdout/stderr, so $capture is often
    # empty even though the handler produced diagnostics. Fold the tail of $report
    # into $capture before hashing so the escalated blob carries the handler's own
    # output rather than the empty git blob (e69de29b).
    if [ -s "$report" ]; then
      printf '\n--- handler report (partial) ---\n' >>"$capture"
      tail -n 200 "$report" >>"$capture" 2>/dev/null || true
    fi
    rm -f "$report"  # folded into $capture above; safe to drop now

    # --- transient-outage classification (mirrors self-heal-run.sh) -------------
    # A `claude -p` handler that dies on an API overload / rate-limit / 5xx / bare
    # connection drop produces NOTHING worth a human: either an empty capture
    # (nothing on stdout/stderr and an empty $report — the bare empty-output-nonzero
    # signature of gardener-claude.sh being killed mid-call) or a capture whose only
    # content is one of the transient signatures below. That is a self-resolving
    # blip, not a deterministic job defect — the reaper already requeues the job
    # after GARDEN_CLAIM_TTL. Escalating it as a kind:error to the gardener inbox
    # spams the error journal and inbox for a blip that needs no triage (both
    # 2026-06-27 self-heal jobs failed this way, seconds apart, with empty output).
    # Classify it as TRANSIENT: emit ONE kind:progress note and SKIP the inbox
    # escalation, leaving the job in doin for the TTL requeue exactly as the
    # escalation path does. Reserve the loud error/escalation path below for a
    # handler that failed with REAL diagnostic output. The capture-empty test runs
    # BEFORE the synthetic-line block (which would otherwise mask the emptiness).
    #
    # An empty capture alone is NOT proof of a blip: the exit code disambiguates.
    # Only a signal/clean-shutdown rc (143/130/137) or the offline rc is a killed-
    # mid-call blip; a non-signal non-zero rc with empty output (rc=127/126 missing
    # / non-executable tool — the jq-outage signature — or a bare rc=1/2) is a
    # DETERMINISTIC defect that must escalate NOW, not after the reaper's multi-hour
    # cycle. is_transient_empty_failure (common.sh) makes that call, mirroring the
    # signal/offline discrimination in self-heal-run.sh that this comment claims.
    transient=0
    if is_external_kill_rc "$rc"; then
      # An EXTERNAL signal-kill (143 SIGTERM / 130 SIGINT / 137 SIGKILL/OOM) is
      # never a deterministic job defect — it is a deploy-window restart, a
      # drain-fleet stop, an OOM, a host shutdown, or the reaper's claim-TTL kill.
      # Classify it transient FIRST, before the empty/non-empty capture split, so
      # capture content is IRRELEVANT for these codes: a gardener killed mid-job
      # that already flushed partial output to $capture (progress lines, the
      # folded tail of $report) must NOT be falsely escalated as a real failure
      # just because it had written something (the 2026-06-27 rc=143 escalation of
      # garden-deliberate-deploy-no-shared-tree-development). The reaper requeues
      # the job after GARDEN_CLAIM_TTL. Only NON-signal rcs fall through to the
      # capture-content-sensitive tests below.
      transient=1
    elif [ ! -s "$capture" ]; then
      # Empty output is transient ONLY when $rc is a signal/clean-shutdown code
      # or the offline rc (a `claude -p` killed mid-call). A non-signal,
      # non-offline non-zero rc with empty output — rc=127/126 (missing /
      # non-executable tool, the jq-outage signature) or a bare rc=1/2 — is a
      # DETERMINISTIC defect: fall through to the real-failure escalation below
      # so it surfaces now rather than after the reaper's TTL. (Gating on $rc is
      # the realignment with self-heal-run.sh that this comment claims.)
      is_transient_empty_failure "$rc" && transient=1
    elif is_transient_claude_signature "$(tail -c 65536 "$capture" 2>/dev/null)"; then
      transient=1   # capture carries only a transient-claude signature
    fi

    if [ "$transient" -eq 1 ]; then
      # Fold the reaper's already-present requeue-cycle count (the
      # `<!-- garden-reaped: N -->` marker on $jobfile) into the note so a job that
      # dies the SAME transient way every cycle is greppable in the journal NOW,
      # instead of looking identical on its 1st and 5th requeue and surfacing only
      # after the reaper's ~5×TTL poison cycle (~5h). reap_count is READ-ONLY of an
      # existing marker — no new state, no CAS — and defaults to 0 on the first
      # pass. This does NOT re-open the OPEN failed-job-lane decision flagged above;
      # it only makes a not-actually-transient job (a wedged scholar fetch, an OOM)
      # visible early to a human or a future watchman self-test.
      cycle="$(reap_count "$jobfile")"
      log "handler outage for '$base' looks transient (rc=$rc, requeue cycle $cycle, signal-kill/empty/transient-signature capture); no escalation, left in doin for reaper requeue"
      printf 'gardener-%s on %s: job %s handler exited rc=%s (signal-kill/empty/transient-signature output); transient handler outage (requeue cycle %s); left in doin for reaper requeue (no escalation)\n' \
        "$id" "$GARDEN_HOST" "$base" "$rc" "$cycle" \
        | GARDEN_ROLE=gardener "$HERE/journal-entry.sh" progress || true
      # We KNOW this claim is dead (the handler was killed/blipped, not failing on a
      # job defect), so don't make the job wait out the full GARDEN_CLAIM_TTL for the
      # reaper to notice its claimed_at is stale. Stamp a reap-now hint on our own
      # still-in-doin claim: the reaper requeues a hinted claim on its NEXT tick
      # (≤10 min) while still incrementing the `<!-- garden-reaped: N -->` poison
      # counter, so a job killed THE SAME WAY every cycle (a wedged Wayback fetch
      # SIGTERM'd each cycle) still escalates to the maintainer as poison after the
      # threshold rather than requeueing forever. The reaper stays the single writer
      # of the requeue; we only hint. Subshell-isolated so a sync_clone offline-exit
      # cannot kill this gardener; best-effort — on failure the TTL requeue still
      # backstops it. (Distinct from the non-signal real-failure branch below, which
      # escalates a diagnostic and stays on the plain reaper-TTL path unchanged.)
      if ( stamp_reap_now_hint "$CLONE" "$JOBS_DOIN/$base.md" ); then
        log "stamped reap-now hint on '$base'; reaper will requeue before TTL (poison cycle still counts)"
      else
        log "could not stamp reap-now hint on '$base' (rc=$?); falling back to the reaper's TTL requeue"
      fi
    else
      # --- real failure: escalate the diagnostic output by hash -----------------
      # Defensive: $capture is non-empty here (the transient branch absorbed the
      # empty case), but keep the synthesize-if-empty guard so a future change to
      # the classifier can never hash the empty git blob.
      if [ ! -s "$capture" ]; then
        printf "handler '%s' exited rc=%s with NO captured output (likely killed/OOM/exec or claude-CLI failure)\n" \
          "$base" "$rc" >>"$capture"
      fi
      sha="$(GARDEN_JOURNAL="$CLONE" "$GARDEN_ROOT/skills/gardener-inbox-error-reporting/report-error.sh" \
               --transcript "$capture" --lane 0 --state handler-nonzero \
               --context "gardener-$id on $GARDEN_HOST: job '$base' handler exited rc=$rc" \
             2>/dev/null || true)"
      # Fall back to a bare local hash if the inbox-append escalation itself failed,
      # so the output is at least durable in this gardener's clone.
      [ -n "$sha" ] || sha="$(capture_blob "$capture" "$CLONE" 2>/dev/null || echo unknown)"
      # Anchor the capture under refs/captures so an off-host responder can fetch it
      # even if the inbox-append push was lost; best-effort (blob stays local in $CLONE).
      [ "$sha" = unknown ] || anchor_blob "$sha" "gardener/$id/$base" "$CLONE" 2>/dev/null || true
      printf 'gardener-%s on %s: job %s handler FAILED (rc=%s); output captured as %s, escalated to the gardener inbox, left in doin for the reaper\n' \
        "$id" "$GARDEN_HOST" "$base" "$rc" "$sha" \
        | GARDEN_ROLE=gardener "$HERE/journal-entry.sh" error || true
    fi
  fi
  rm -f "$report" "$capture"
done
