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
# Upper runtime bound for ONE handler invocation (see the wrapped call below).
# INVARIANT: GARDEN_HANDLER_TIMEOUT + GARDEN_HANDLER_KILL_AFTER < GARDEN_CLAIM_TTL
# (reaper.sh, default 3600) so no handler — even one that ignores SIGTERM and is only
# released by the --kill-after SIGKILL escalation — can outlive the reaper's
# stale-claim window; otherwise the reaper would requeue the SAME base while the
# original handler is still running and the job would execute concurrently on two
# gardeners. Set comfortably above GARDEN_DEPLOY_DRAIN_TIMEOUT (deploy-garden.sh,
# default 600) so a legitimately long handler is not killed mid-deploy-drain.
: "${GARDEN_HANDLER_TIMEOUT:=2400}"
# Grace period between the SIGTERM at GARDEN_HANDLER_TIMEOUT and the unconditional
# SIGKILL escalation (timeout's --kill-after). A handler that respects SIGTERM dies
# at the deadline (rc=124) and never reaches this; this bound exists ONLY for a
# handler that IGNORES SIGTERM (a hard deadlock, or a child wedged in an
# uninterruptible state). Without it, `timeout` blocks forever waiting for the
# unkillable child and the gardener worker itself wedges past GARDEN_HANDLER_TIMEOUT,
# breaking the invariant above (the reaper's claim-TTL only requeues the JOB, it
# never frees this stuck worker process). Kept small so the worst-case worker runtime
# stays well under GARDEN_CLAIM_TTL. The SIGKILL escalation surfaces as rc=137, which
# is_external_kill_rc already classifies transient — so, like the rc=124 wall-clock
# kill (is_handler_timeout_rc), it needs no new classification branch.
: "${GARDEN_HANDLER_KILL_AFTER:=60}"
# The reaper's stale-claim window (reaper.sh, default 3600 — the authority). Mirrored
# here ONLY so the optional per-job `handler-timeout:` header (resolved at the call
# site below) can be clamped against the INVARIANT above; keep this default in sync
# with reaper.sh's GARDEN_CLAIM_TTL. The reaper stays the sole owner of the requeue.
: "${GARDEN_CLAIM_TTL:=3600}"

# Elapsed-constancy early-escalation (common.sh § elapsed-constancy). When a
# transient-CLASSIFIED handler failure (a transient-claude signature or a bare
# claude-CLI failure — NOT an external signal-kill or wall-clock timeout) dies at a
# near-CONSTANT elapsed across this many requeue cycles, the gardener emits ONE
# gardener-inbox kind:error flagging a likely DETERMINISTIC overrun misclassified
# as a self-resolving blip — surfacing a genuinely-stuck job in ~2 cycles instead
# of the reaper's ~5-cycle poison threshold. GARDEN_ELAPSED_CONSTANCY_CYCLES is N,
# the size of the trailing elapsed window that must agree; set it to 0 or 1 to
# DISABLE the whole check. GARDEN_ELAPSED_CONSTANCY_TOLERANCE_PCT is the ± band
# (percent) within which the window counts as constant.
: "${GARDEN_ELAPSED_CONSTANCY_CYCLES:=2}"
: "${GARDEN_ELAPSED_CONSTANCY_TOLERANCE_PCT:=15}"

# Deadline-overrun early-escalation (common.sh § deadline-overrun). A handler killed
# by its OWN wall-clock bound (rc=124 via is_handler_timeout_rc) AT the wall — an
# elapsed within GARDEN_HANDLER_DEADLINE_EPSILON seconds of GARDEN_HANDLER_TIMEOUT —
# hit its budget deterministically and will be killed identically on every requeue,
# unlike an external SIGTERM/OOM/drain that varies in elapsed. The gardener stamps a
# `<!-- garden-deadline-overrun: N -->` counter on such a claim so the reaper poisons
# it after GARDEN_REAP_OVERRUN_THRESHOLD (a much lower bound) instead of burning the
# full GARDEN_REAP_POISON_THRESHOLD cycles. The epsilon is the small guard band that
# confirms the handler hit its OWN wall (default: the SIGTERM→SIGKILL grace, so a
# handler killed anywhere in the [TIMEOUT-grace, TIMEOUT+grace] window counts).
: "${GARDEN_HANDLER_DEADLINE_EPSILON:=$GARDEN_HANDLER_KILL_AFTER}"

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

# --- host-identity assertion at spawn (the endolinbot2 inherited-env drift) ------
# GARDEN (common.sh) is the single key every per-host structure hangs off: the claim
# metadata, the hosts/<host> worker count, the leader predicate. An inherited-env
# GARDEN (environment.d / manager env) that no longer matches this host used to stay
# invisible until it had already corrupted that per-host journal/index state. Surface
# the resolved identity at the point of spawn so the drift is detectable and greppable
# BEFORE any claim keys off it. The design deliberately permits `GARDEN=<unique>`
# parallel pools, so a divergence from `hostname -s` is noted here at INFO level
# (never refused) but NOT escalated here: this per-spawn path runs from every one of
# the ~100 gardeners on every spawn, so a WARN + report at this point is ~100
# identical lines per wake that dominate `journalctl -p warning` and bury unrelated
# warnings. The once-per-tick, host-level escalation (one WARN + one deduped
# kind:error maintainer-inbox report per host per divergence) lives in the
# gardener-scaler identity-drift guard (scripts/jobs/identity-drift-guard.sh) — the
# correct single place to detect the .garden-file / inherited-env drift the scaler's
# reconcile step cannot. A deliberate override recorded in GARDEN_IDENTITY_OVERRIDE
# or $GARDEN_STATE/identity-override (matching the resolved GARDEN) marks the
# divergence as intentional in this log line.
host_short="$(hostname -s 2>/dev/null || echo host)"
log "identity: GARDEN=$GARDEN (hostname -s=$host_short)"
if [ "$GARDEN" != "$host_short" ]; then
  recorded_override="${GARDEN_IDENTITY_OVERRIDE:-}"
  if [ -z "$recorded_override" ] && [ -f "$GARDEN_STATE/identity-override" ]; then
    recorded_override="$(head -1 "$GARDEN_STATE/identity-override" 2>/dev/null || true)"
  fi
  if [ "$recorded_override" = "$GARDEN" ]; then
    log "identity: GARDEN=$GARDEN diverges from hostname -s=$host_short by RECORDED deliberate override (parallel pool)"
  else
    # Genuine unrecorded drift, but escalation is the gardener-scaler guard's job
    # (once per tick, deduped), NOT this per-spawn path — see the note above. Keep a
    # single low-volume info line so one gardener's own log still shows the drift.
    log "identity: GARDEN=$GARDEN diverges from hostname -s=$host_short with no recorded override — the gardener-scaler identity-drift guard raises the once-per-tick escalation"
  fi
fi
# Per-instance identity marker — a cheap, machine-checkable record of THIS gardener's
# resolved GARDEN that the scaler's drift check (sibling job) reads without walking
# /proc. One file per gardener id, rewritten at every spawn.
IDENTITY_MARKER="$GARDEN_STATE/gardeners/$id.garden"
mkdir -p "$(dirname "$IDENTITY_MARKER")" 2>/dev/null || true
printf '%s\n' "$GARDEN" > "$IDENTITY_MARKER" 2>/dev/null || true

log "starting (clone=$CLONE handler=$GARDEN_JOB_HANDLER oneshot=$GARDEN_ONESHOT)"

idle_rounds=0
# Consecutive non-productive ticks, driving idle_backoff()'s exponential growth.
# SEPARATE from idle_rounds (which is ONESHOT drain bookkeeping): this resets on a
# claimed job, idle_rounds resets on a claimed job too but only ever increments
# under ONESHOT. Reset to 1 (attempt 1 = a quick first poll) on a productive tick.
idle_attempt=1

# Consecutive transient handler failures, driving the PER-WORKER failure backoff
# (the failure-path analog of idle_attempt, reusing idle_backoff). On a correlated
# outage — a Claude quota/usage cut — a handler dies transiently, is left in doin
# for the reaper, and the worker would otherwise fall STRAIGHT back to the claim
# head and re-run the next job against the same exhausted quota with zero delay.
# Instead a just-failed worker sleeps idle_backoff("$fail_attempt") before its next
# claim, and the counter GROWS across consecutive transient failures so a sustained
# outage backs a single worker off exponentially (capped at GARDEN_IDLE_SLEEP_CAP).
# SEPARATE from idle_attempt on purpose: idle_attempt resets on every claim (a
# productive tick), which would erase the exponential growth across a claim→fail
# streak; fail_attempt resets ONLY on a genuine completion (a healthy cycle), so it
# keeps growing while the outage persists. Complements the SHARED fleet brake below.
fail_attempt=1

# Graceful drain on stop. Under the unit's KillMode=mixed, a systemd stop/restart
# SIGTERMs only the main worker process (self-heal-run.sh, which forwards the
# signal to THIS loop with a single-process `kill`, never to the handler subtree),
# so the in-flight handler keeps running. Trap that SIGTERM to set a
# "stop after the current job" flag instead of dying: while a handler (or an idle
# sleep) is the running foreground command, bash DEFERS this trap until that
# command returns, so the job finishes uninterrupted; we then notice the flag at
# the between-claims point at the top of the loop and exit cleanly — never
# mid-handler. Without the trap, the default SIGTERM disposition would kill this
# bash immediately (rc=143), abandoning the handler subtree → the job requeues and
# burns a poison cycle. This makes the busy-marker drain authoritative for every
# stop path. The unit's TimeoutStopSec is sized to wait for the in-flight handler
# (≥ GARDEN_HANDLER_TIMEOUT + GARDEN_HANDLER_KILL_AFTER + slack) before systemd
# escalates to a cgroup-wide SIGKILL.
stop_requested=0
trap 'stop_requested=1; log "SIGTERM received; will stop cleanly after the current job (graceful drain)"' TERM

while :; do
  if fleet_draining; then log "fleet draining; exiting cleanly"; exit 0; fi
  # A trapped SIGTERM (systemd stop/restart) set this after the running handler
  # returned; this between-claims point is where we honor it, so a stop drains the
  # current job to completion rather than killing it mid-flight.
  if [ "$stop_requested" -eq 1 ]; then log "stop requested; current job drained, exiting cleanly"; exit 0; fi

  # Top of the loop is a between-claims point: clear the busy marker so the deploy
  # reconciler may restart this gardener now (it re-exec's onto landed script
  # fixes). The marker is re-set just before the handler runs, below.
  rm -f "$BUSY_MARKER" 2>/dev/null || true

  # monitor the bus for anything addressed to this role or broadcast, every loop
  "$HERE/read-msgs.sh" "gardener-$id" "role/gardener" "broadcast" || true

  # --- shared fleet brake -----------------------------------------------------
  # A correlated outage (a Claude quota/usage cut) makes many handlers fail at
  # once; each gardener stamps the shared host-local ledger on a transient failure
  # (below). Before claiming, read the fleet-wide transient-failure density and,
  # when it crosses the threshold, PAUSE claiming for a jittered window so the
  # storm drains instead of being fed to an already-exhausted quota. Cadence only:
  # the reaper stays the sole requeue owner and a braked gardener touches no board
  # state; a braked worker records nothing, so the density ages out and the brake
  # releases. Fail-open — an unreadable ledger reads as not-engaged. Checked at
  # this between-claims point (after the drain/stop checks and busy-marker clear
  # above) so a stop or deploy still preempts a braked gardener promptly.
  if fleet_brake_engaged; then
    log "fleet brake ENGAGED (transient-failure density $(transient_failure_density) ≥ threshold ${GARDEN_FLEET_BRAKE_THRESHOLD} over ${GARDEN_FLEET_BRAKE_WINDOW_SECS}s); pausing claims so the quota storm drains instead of being fed"
    fleet_brake_pause
    continue
  fi

  set +e
  base="$("$HERE/claim-job.sh" "$id")"; rc=$?
  set -e

  if [ "$rc" -eq 3 ]; then
    if [ "$GARDEN_ONESHOT" = "1" ]; then
      idle_rounds=$((idle_rounds+1))
      # two clean empty passes => board is drained; exit.
      [ "$idle_rounds" -ge 2 ] && { log "board drained; exiting (oneshot)"; exit 0; }
    fi
    idle_backoff "$idle_attempt"; idle_attempt=$((idle_attempt+1))
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
    idle_backoff "$idle_attempt"; idle_attempt=$((idle_attempt+1))
    continue
  fi
  [ "$rc" -ne 0 ] && die "claim failed (rc=$rc)"
  idle_rounds=0
  idle_attempt=1   # productive tick: a job was claimed — reset to a quick first poll

  jobfile="$CLONE/$JOBS_DOIN/$base.md"
  report="$(mktemp "${TMPDIR:-/tmp}/garden-report-$base.XXXXXX")"
  # divert the handler's combined stdout+stderr here so a failure can be captured
  # by hash instead of vanishing into this gardener's systemd journal.
  capture="$(mktemp "${TMPDIR:-/tmp}/garden-capture-$base.XXXXXX")"
  # Completion sentinel — the DETERMINISTIC "the job genuinely finished" signal
  # (common.sh § job completion signal). The handler writes this path IFF the
  # worker completed (claude exited 0 AND emitted GARDEN_COMPLETION_MARKER as its
  # final act); its PRESENCE — never the handler exit code — gates doin→tada
  # below. Created as a name and removed up front so it is absent until the
  # handler proves completion; a handler that exits 0 WITHOUT writing it (a quota
  # cut mid-response, an unsatisfying run) is requeued, not recorded as done.
  completion_sentinel="$(mktemp "${TMPDIR:-/tmp}/garden-done-$base.XXXXXX")"
  rm -f "$completion_sentinel"

  # Silent-until-error is the default: the happy path emits no claim/complete
  # progress lines (across a ~100-gardener fleet these pairs were the dominant
  # journal volume and burned the supervisor's context with routine noise). The
  # durable record is the completion `result` entry; the failure path captures
  # output by hash and escalates to the gardener inbox. Set
  # GARDEN_GARDENER_VERBOSE=1 to opt back into the claim/complete narration.
  # Drain this job doer's directed inbox (unread → read) before working.
  if [ -n "${GARDEN_GARDENER_VERBOSE:-}" ]; then
    printf 'gardener-%s on %s claimed job %s\n' "$id" "$GARDEN" "$base" \
      | GARDEN_ROLE=gardener "$HERE/journal-entry.sh" progress || true
  fi
  "$HERE/inbox-read.sh" "$base" || true

  # Mark this gardener mid-job so a deploy (deploy-garden.sh quiesce / the shared
  # deploy-restart busy-gate) defers restarting it until it next goes idle
  # (cleared at the top of the next loop iteration).
  : > "$BUSY_MARKER" 2>/dev/null || true

  log "working '$base'"
  # Bound EVERY handler's runtime here at the single call site, not inside each
  # handler, so the cap covers gardener-claude.sh's unbounded `claude -p`, the
  # gardening state machine, and any future handler uniformly. A wedged/runaway
  # handler (network hang, infinite tool loop) would otherwise run forever,
  # pinning one of the ~100 scarce gardener instances and its $BUSY_MARKER — which
  # also stalls every deploy-garden.sh quiesce until GARDEN_DEPLOY_DRAIN_TIMEOUT —
  # and after GARDEN_CLAIM_TTL the reaper requeues the SAME base while the original
  # is still running (duplicate concurrent execution). GARDEN_HANDLER_TIMEOUT +
  # GARDEN_HANDLER_KILL_AFTER < GARDEN_CLAIM_TTL (see the knobs above) closes that
  # hole even against a handler that IGNORES SIGTERM: --kill-after escalates to an
  # unconditional SIGKILL after the grace, so `timeout` cannot block forever on an
  # unkillable child and the worker is guaranteed to return and re-enter the claim
  # loop. Both expiry paths land in the transient classifier below, so neither
  # false-escalates an inherently-long handler. A handler that RESPECTS SIGTERM dies
  # at the deadline and `timeout` reports rc=124 — its own wall-clock-timeout code,
  # NOT a signal code (is_external_kill_rc covers only 143/130/137) — which
  # is_handler_timeout_rc classifies transient. A handler that IGNORES SIGTERM is
  # SIGKILLed by --kill-after and surfaces as rc=137, already an external signal-kill
  # transient via is_external_kill_rc. Either way: ONE kind:progress note, no inbox
  # kind:error, left in doin for the reaper, whose `<!-- garden-reaped: N -->` poison
  # counter escalates a job that times out EVERY cycle (a genuine deadlock) only after
  # the threshold. A genuine deploy-drain kill also arrives as rc=143 and stays
  # transient via is_external_kill_rc.
  #
  # Stamp the handler's wall-clock start (SECONDS, the shell's monotonic
  # seconds-since-start counter) so the failure branch below can report how long
  # the handler ran before it was killed. A near-CONSTANT elapsed across requeue
  # cycles is a positive signal of a DETERMINISTIC overrun (the handler runs into
  # the same fixed bound every time) or a fixed external bound, distinct from a
  # benign deploy-drain blip that lands at a VARIED elapsed near a known deploy —
  # which the rc-only classification cannot tell apart until the reaper's poison
  # threshold. SECONDS is read-only timing state; no new board state.
  handler_start=$SECONDS

  # --- per-job handler budget (optional `handler-timeout:` header) ------------
  # A job may declare a longer run-to-completion budget than the default
  # GARDEN_HANDLER_TIMEOUT by carrying a `handler-timeout: <seconds>` header in its
  # body — for a legitimately long "run to completion" job whose NAME promises
  # completion (e.g. garden-issue-9-run-contract-control-upgrade-test-to-completion)
  # that the fixed 2400s cap would otherwise SIGTERM-kill by construction. It is
  # honored ONLY within the INVARIANT that keeps a claim single-owner (knobs above):
  #     budget + GARDEN_HANDLER_KILL_AFTER < GARDEN_CLAIM_TTL
  # so the largest a single claim can hold is CLAIM_TTL - KILL_AFTER - 1. A request
  # at or under that max is honored verbatim (in place of GARDEN_HANDLER_TIMEOUT). A
  # request OVER it is NOT silently raised into the invariant — doing so would let
  # the reaper requeue the SAME base onto a second gardener while this handler still
  # runs (duplicate concurrent execution, the very hole the invariant closes).
  # Instead we clamp to the safe max AND escalate to the maintainer: a
  # run-to-completion handler that needs longer than one claim can hold cannot be a
  # claim-scoped handler at all and must run detached or be split into claim-sized
  # stages. A non-numeric or <1 header (0 would disable `timeout` entirely, breaking
  # the invariant) is ignored and the default budget stands.
  handler_budget="$GARDEN_HANDLER_TIMEOUT"
  requested_budget="$(sed -n 's/^handler-timeout:[[:space:]]*//p' "$jobfile" 2>/dev/null | head -1 | tr -dc '0-9')"
  if [ -n "$requested_budget" ] && [ "$requested_budget" -ge 1 ] 2>/dev/null; then
    budget_max=$(( GARDEN_CLAIM_TTL - GARDEN_HANDLER_KILL_AFTER - 1 ))
    if [ "$requested_budget" -le "$budget_max" ]; then
      handler_budget="$requested_budget"
      log "job '$base' declared handler-timeout=${requested_budget}s (≤ claim budget max ${budget_max}s); honoring in place of default ${GARDEN_HANDLER_TIMEOUT}s"
    else
      handler_budget="$budget_max"
      log "job '$base' declared handler-timeout=${requested_budget}s > claim budget max ${budget_max}s; clamping to max and escalating (cannot be a claim-scoped handler)"
      alert_maintainer "handler-budget-overrun-$base" \
        "gardener job '$base' declared handler-timeout=${requested_budget}s, which exceeds what a single claim can hold (max ${budget_max}s = GARDEN_CLAIM_TTL ${GARDEN_CLAIM_TTL}s − GARDEN_HANDLER_KILL_AFTER ${GARDEN_HANDLER_KILL_AFTER}s − 1). A run-to-completion handler that needs longer than one claim cannot be claim-scoped without breaking the duplicate-execution guard: after GARDEN_CLAIM_TTL the reaper would requeue the same base onto a second gardener while this one is still running. Run it DETACHED (outside the claim-scoped handler) or SPLIT it into claim-sized stages. This cycle the handler runs clamped at ${budget_max}s and will be SIGTERM-killed at that bound — it will not complete."
    fi
  fi

  # Run the handler and capture its exit code EXPLICITLY (not folded into an `if`
  # compound) so the completion gate below can branch on the three distinct
  # outcomes independently: (0 + sentinel)=complete, (0 + no sentinel)=exit-0-
  # unsatisfying requeue, (non-zero)=the existing transient-vs-real classifier.
  set +e
  GARDEN_GARDENER_ID="$id" GARDEN_COMPLETION_SENTINEL="$completion_sentinel" \
    timeout --signal=TERM --kill-after="$GARDEN_HANDLER_KILL_AFTER" "$handler_budget" \
    "$GARDEN_JOB_HANDLER" "$base" "$jobfile" "$report" >"$capture" 2>&1
  hrc=$?
  set -e
  if [ "$hrc" -eq 0 ] && [ -e "$completion_sentinel" ]; then
    # DETERMINISTIC COMPLETION GATE: the handler both exited 0 AND wrote the
    # completion sentinel (the worker reached its final act and emitted
    # GARDEN_COMPLETION_MARKER). Only now do we record the job done (doin→tada).
    #
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
      rm -f "$report" "$capture" "$completion_sentinel"
      idle_backoff "$idle_attempt"; idle_attempt=$((idle_attempt+1))
      continue
    fi
    [ "$crc" -ne 0 ] && die "complete-job failed for '$base' (rc=$crc)"
    fail_attempt=1   # a genuine completion (a healthy cycle) resets the failure backoff
    if [ -n "${GARDEN_GARDENER_VERBOSE:-}" ]; then
      printf 'gardener-%s on %s completed job %s\n' "$id" "$GARDEN" "$base" \
        | GARDEN_ROLE=gardener "$HERE/journal-entry.sh" progress || true
    fi
  elif [ "$hrc" -eq 0 ]; then
    # EXIT-0-UNSATISFYING: the handler exited 0 but the completion sentinel is
    # absent — it NEVER signaled completion — a `claude` that exited cleanly
    # without finishing: quota/usage cut mid-response, an API error swallowed to a
    # clean exit, or a run that "did not reach a satisfying conclusion." This is
    # the gap the deterministic-requeue directive closes: DO NOT complete it
    # (doin→tada would record unfinished work as done and lose it — the reaper
    # never requeues tada). Instead requeue it the SAME way a transient non-zero
    # failure is requeued: leave it in doin and stamp a reap-now hint so the
    # reaper (the single writer of the requeue AND the poison counter) moves it
    # doin→todo on its next tick and increments `<!-- garden-reaped: N -->`. A job
    # that keeps exiting-0-unsatisfying every cycle therefore escalates to the
    # maintainer as POISON after GARDEN_REAP_POISON_THRESHOLD cycles — bounded
    # requeue, never silently lost, never infinitely requeued. No $capture
    # diagnostic is escalated: a clean exit-0 produced no failure output, so this
    # is a kind:progress note, not a kind:error.
    elapsed=$((SECONDS - handler_start))
    cycle="$(reap_count "$jobfile")"
    log "handler for '$base' exited 0 WITHOUT the completion signal (exit-0-unsatisfying: quota/API/clean-but-unfinished); requeueing (requeue cycle $cycle, elapsed=${elapsed}s), left in doin for reaper requeue"
    printf 'gardener-%s on %s: job %s handler exited 0 but never emitted the completion signal (exit-0-unsatisfying — claude quota/usage cut, swallowed API error, or unfinished run); requeueing doin→todo (requeue cycle %s, elapsed=%ss), left in doin for reaper requeue (no escalation)\n' \
      "$id" "$GARDEN" "$base" "$cycle" "$elapsed" \
      | GARDEN_ROLE=gardener "$HERE/journal-entry.sh" progress || true
    if ( stamp_reap_now_hint "$CLONE" "$JOBS_DOIN/$base.md" ); then
      log "stamped reap-now hint on '$base'; reaper will requeue before TTL (poison cycle still counts)"
    else
      log "could not stamp reap-now hint on '$base' (rc=$?); falling back to the reaper's TTL requeue"
    fi
    rm -f "$report" "$capture" "$completion_sentinel"
    # Transient (quota/API/clean-but-unfinished): feed the SHARED fleet brake and
    # apply the PER-WORKER failure backoff so this just-failed worker does not
    # instantly re-claim and re-run against the same exhausted quota. Cadence only
    # — the reaper still owns the requeue.
    record_transient_failure
    idle_backoff "$fail_attempt"; fail_attempt=$((fail_attempt+1))
  else
    rc=$hrc  # exit code of the failed handler (captured explicitly above)
    elapsed=$((SECONDS - handler_start))  # wall-clock seconds the handler ran before it died
    deadline_overrun=0  # 1 iff the handler hit its OWN wall-clock budget (rc=124 at the wall)
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
    elif is_handler_timeout_rc "$rc"; then
      # A WALL-CLOCK-TIMEOUT kill (rc=124): the handler was terminated by its own
      # `timeout --signal=TERM "$GARDEN_HANDLER_TIMEOUT"` wrapper at the single call
      # site above. `timeout` reports expiry as 124, masking the underlying SIGTERM
      # that would otherwise read as 143 — so this is conceptually a FOURTH external
      # kill (the wall-clock supervisor terminated the handler), not a deterministic
      # job defect. Classify it transient ALONGSIDE the signal-kills, BEFORE the
      # empty/non-empty capture split, so capture content is IRRELEVANT: an
      # inherently-long handler (a shepherd driving CI to green at the 2400s window —
      # shepherd-kriscendobot-agoric-sdk-pr7) flushes legitimate progress output
      # before the bound fires and must NOT be escalated as a defect for having done
      # so. ONE kind:progress note, NO inbox kind:error, left in doin. A genuinely
      # DEADLOCKED handler still times out every cycle, so the reaper's
      # `<!-- garden-reaped: N -->` poison counter escalates it as poison after the
      # threshold — surfacing the deadlock after N cycles instead of spamming a
      # real-error on every requeue.
      transient=1
      # DISTINGUISH a self-wall hit from an external kill masquerading as rc=124.
      # rc=124 is `timeout`'s own expiry code, so it ALREADY means the handler's own
      # wall-clock wrapper fired — but confirm the elapsed is actually AT the wall
      # (within GARDEN_HANDLER_DEADLINE_EPSILON of GARDEN_HANDLER_TIMEOUT) before
      # treating it as a DETERMINISTIC budget overrun. A handler that hit its own
      # 2400s wall will be killed identically every requeue, so requeuing it the full
      # 5 poison cycles (~200 min of gardener wall-clock) before surfacing it is pure
      # waste — two identical deadline hits is already conclusive. Stamp the
      # deadline-overrun counter (below, in the transient block) so the reaper poisons
      # it after GARDEN_REAP_OVERRUN_THRESHOLD instead. The epsilon guard is
      # belt-and-suspenders: an external kill varies in elapsed and reads as 143/137
      # (is_external_kill_rc), not 124, so this rarely excludes anything — but it means
      # only a genuine wall-hit gets the fast-poison treatment.
      if [ "$elapsed" -ge "$(( GARDEN_HANDLER_TIMEOUT - GARDEN_HANDLER_DEADLINE_EPSILON ))" ]; then
        deadline_overrun=1
      fi
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
      # Fold in the handler's elapsed wall-time too. The reap_count alone cannot
      # distinguish a benign deploy-drain blip (killed at a VARIED elapsed near a
      # known deploy) from a job that deterministically overruns and is killed at
      # a CONSTANT elapsed every cycle — they look identical until the poison
      # threshold (~5 cycles). A near-constant elapsed across requeue cycles is a
      # positive signal of a deterministic overrun or a fixed external bound, so a
      # human or a watchman self-test can surface a genuinely-stuck job early
      # instead of waiting out the full poison cycle. elapsed is READ-ONLY of the
      # SECONDS timing captured at the call site — no new state, no CAS.
      log "handler outage for '$base' looks transient (rc=$rc, requeue cycle $cycle, elapsed=${elapsed}s, signal-kill/timeout/empty/transient-signature capture); no escalation, left in doin for reaper requeue"
      printf 'gardener-%s on %s: job %s handler exited rc=%s (signal-kill/timeout/empty/transient-signature output); transient handler outage (requeue cycle %s, elapsed=%ss); left in doin for reaper requeue (no escalation)\n' \
        "$id" "$GARDEN" "$base" "$rc" "$cycle" "$elapsed" \
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
      if [ "${deadline_overrun:-0}" -eq 1 ]; then
        # The handler hit its OWN wall-clock budget (rc=124, elapsed≈GARDEN_HANDLER_TIMEOUT):
        # a DETERMINISTIC overrun that will be killed identically on every requeue, NOT a
        # varying external kill. Stamp the deadline-overrun COUNTER alongside the reap-now
        # hint (stamp_deadline_overrun_hint does both) so the reaper escalates it to POISON
        # after GARDEN_REAP_OVERRUN_THRESHOLD (2) cycles instead of the full
        # GARDEN_REAP_POISON_THRESHOLD (5) — two identical deadline hits is already
        # conclusive, and requeuing it 5× (~5×GARDEN_HANDLER_TIMEOUT of gardener
        # wall-clock, ~200 min) before surfacing it is pure waste.
        log "handler for '$base' hit its OWN wall-clock budget (rc=124, elapsed=${elapsed}s ≈ GARDEN_HANDLER_TIMEOUT=${GARDEN_HANDLER_TIMEOUT}s): deterministic deadline overrun, stamping the overrun counter for early poison"
        printf 'gardener-%s on %s: job %s handler hit its OWN wall-clock budget (rc=124, elapsed=%ss ≈ GARDEN_HANDLER_TIMEOUT=%ss) — a DETERMINISTIC deadline overrun, not a varying external kill; stamping <!-- garden-deadline-overrun --> so the reaper poisons it after GARDEN_REAP_OVERRUN_THRESHOLD cycles instead of the full poison threshold; left in doin for the reaper\n' \
          "$id" "$GARDEN" "$base" "$elapsed" "$GARDEN_HANDLER_TIMEOUT" \
          | GARDEN_ROLE=gardener "$HERE/journal-entry.sh" progress || true
        if ( stamp_deadline_overrun_hint "$CLONE" "$JOBS_DOIN/$base.md" ); then
          log "stamped deadline-overrun hint on '$base'; reaper will requeue before TTL and poison early (overrun cycle counts)"
        else
          log "could not stamp deadline-overrun hint on '$base' (rc=$?); falling back to the reaper's TTL requeue"
        fi
      elif ( stamp_reap_now_hint "$CLONE" "$JOBS_DOIN/$base.md" ); then
        log "stamped reap-now hint on '$base'; reaper will requeue before TTL (poison cycle still counts)"
      else
        log "could not stamp reap-now hint on '$base' (rc=$?); falling back to the reaper's TTL requeue"
      fi

      # --- elapsed-constancy early-escalation --------------------------------
      # The transient classification above leaves the job in doin for the reaper —
      # correct for a genuine blip. But a transient CLASSIFICATION is not proof of a
      # self-resolving blip: a job that deterministically OVERRUNS and dies with a
      # transient-claude signature (a Claude Code session/usage cap that trips at the
      # same point every run — the 2026-07-01 incident — or a prompt that always
      # drives the CLI to the same failure) is classified transient here and requeued
      # UNCHANGED through all GARDEN_REAP_POISON_THRESHOLD cycles before the reaper's
      # poison counter surfaces it (~5×TTL). Its tell is a near-CONSTANT elapsed
      # across requeue cycles. Recover the prior cycles' elapsed for this base
      # (READ-ONLY grep of this clone's already-synced progress entries — no new
      # state, no CAS, the reaper stays the sole requeue writer) and, once the
      # trailing N-cycle window agrees within a tolerance band on a NON-external-kill
      # rc WITH real output, emit ONE gardener-inbox kind:error flagging the likely
      # misclassification so a human sees it in ~2 cycles instead of ~5. Gated by
      # GARDEN_ELAPSED_CONSTANCY_CYCLES (N; 0/1 disables). The rc/capture gate is
      # deliberate: an external signal-kill (is_external_kill_rc) or wall-clock
      # timeout (is_handler_timeout_rc) is a legitimate EXTERNAL termination (a
      # deploy-drain, an inherently-long shepherd hitting the 2400s bound) that does
      # NOT indicate a deterministic defect even at a constant elapsed, and an
      # EMPTY-capture transient (an offline/signal blip) is not a claude-signature
      # overrun — both are excluded so only a transient-claude-signature / claude-CLI
      # failure with diagnostic output can trip this.
      constancy_n="$GARDEN_ELAPSED_CONSTANCY_CYCLES"
      # A misconfigured (non-integer) tunable DISABLES the check rather than crashing
      # the gardener loop on the arithmetic test below (this runs on every failed job).
      case "$constancy_n" in ''|*[!0-9]*) constancy_n=0 ;; esac
      if [ "$constancy_n" -ge 2 ] && [ "$cycle" -ge 2 ] && [ -s "$capture" ] \
         && ! is_external_kill_rc "$rc" && ! is_handler_timeout_rc "$rc"; then
        # Prior cycles' elapsed (this clone was synced at claim time, so it holds the
        # prior notes but NOT this cycle's) with the current elapsed appended, then
        # the trailing N-cycle window; require a FULL window before judging constancy.
        series="$(prior_transient_elapsed_series "$CLONE" "$base"; printf '%s\n' "$elapsed")"
        window="$(printf '%s\n' "$series" | grep -E '^[0-9]+$' | tail -n "$constancy_n" || true)"
        count="$(printf '%s\n' "$window" | grep -cE '^[0-9]+$' || true)"
        # Fire at most ONCE per base: dedup on the marker the kind:error entry below
        # carries. The clone was synced at claim, so a prior cycle's escalation entry
        # (pushed to origin, pulled into this clone) is visible here — no new state.
        already=0
        if grep -rlqF "elapsed-constancy overrun-suspect: $base" "$CLONE/entries" 2>/dev/null; then already=1; fi
        tol="$GARDEN_ELAPSED_CONSTANCY_TOLERANCE_PCT"
        if [ "${count:-0}" -ge "$constancy_n" ] && [ "$already" -eq 0 ] \
           && elapsed_within_band "$tol" $window; then
          series_csv="$(printf '%s\n' "$window" | paste -sd, - || true)"
          # Escalate a diagnostic to the gardener inbox (the ONE kind:error). Build a
          # self-describing transcript; report-error.sh hashes it and appends the
          # inbox section. GARDEN_JOURNAL="$CLONE" mirrors the real-failure branch.
          constancy_tr="$(mktemp "${TMPDIR:-/tmp}/garden-constancy-$base.XXXXXX")"
          {
            printf 'elapsed-constancy overrun-suspect: %s\n\n' "$base"
            printf 'gardener-%s on %s: job %s was classified TRANSIENT (rc=%s) but its\n' "$id" "$GARDEN" "$base" "$rc"
            printf 'handler has now died at a near-CONSTANT elapsed across the last %s requeue\n' "$constancy_n"
            printf 'cycles (elapsed window, oldest->newest: %ss; requeue cycle %s; tolerance +/-%s%%).\n\n' "$series_csv" "$cycle" "$tol"
            printf 'That is the signature of a DETERMINISTIC overrun MISclassified as a\n'
            printf 'self-resolving blip (a Claude Code session/usage cap tripping at the same\n'
            printf 'point every run, or a prompt that drives the CLI to the same failure), NOT\n'
            printf 'an external signal-kill or wall-clock timeout (those vary in elapsed and\n'
            printf 'are excluded). Left in doin for the reaper (requeue ownership UNCHANGED);\n'
            printf 'it will otherwise burn all %s poison cycles before surfacing. Triage the\n' "${GARDEN_REAP_POISON_THRESHOLD:-5}"
            printf 'job spec / handler rather than waiting out the poison threshold.\n'
          } > "$constancy_tr"
          sha="$(GARDEN_JOURNAL="$CLONE" "$GARDEN_ROOT/skills/gardener-inbox-error-reporting/report-error.sh" \
                   --transcript "$constancy_tr" --lane 0 --state elapsed-constancy-overrun-suspect \
                   --context "gardener-$id on $GARDEN: job '$base' transient-classified (rc=$rc) but elapsed near-constant (${series_csv}s) over $constancy_n cycles — likely deterministic overrun, not a blip" \
                 2>/dev/null || true)"
          rm -f "$constancy_tr"
          log "elapsed-constancy early-escalation for '$base': transient-classified rc=$rc but elapsed near-constant (${series_csv}s) over $constancy_n cycles; escalated ONE kind:error to the gardener inbox (sha=${sha:-unknown}), left in doin (requeue ownership unchanged)"
          printf 'gardener-%s on %s: job %s handler exited rc=%s classified transient, but elapsed is near-constant (%ss) across the last %s requeue cycles (cycle %s) — likely a DETERMINISTIC overrun misclassified as a blip, not an external kill/timeout; escalated ONE kind:error to the gardener inbox (elapsed-constancy overrun-suspect: %s, sha=%s), left in doin for the reaper (requeue ownership unchanged)\n' \
            "$id" "$GARDEN" "$base" "$rc" "$series_csv" "$constancy_n" "$cycle" "$base" "${sha:-unknown}" \
            | GARDEN_ROLE=gardener "$HERE/journal-entry.sh" error || true
        fi
      fi

      # Feed the SHARED fleet brake and apply the PER-WORKER failure backoff: a
      # transient handler outage (a signal-kill/timeout/empty/transient-claude
      # signature) is exactly the correlated-quota-storm signal the brake watches
      # for, and a just-failed worker must not fall straight back to the claim head
      # and re-run against the same exhausted quota with zero delay. Both are
      # CADENCE ONLY — the job is already left in doin and the reaper stays the sole
      # requeue owner (nothing above changed that). fail_attempt grows across
      # consecutive transient failures (reset only on a genuine completion), so a
      # sustained outage backs this worker off exponentially up to the idle cap.
      record_transient_failure
      idle_backoff "$fail_attempt"; fail_attempt=$((fail_attempt+1))
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
               --context "gardener-$id on $GARDEN: job '$base' handler exited rc=$rc" \
             2>/dev/null || true)"
      # Fall back to a bare local hash if the inbox-append escalation itself failed,
      # so the output is at least durable in this gardener's clone.
      [ -n "$sha" ] || sha="$(capture_blob "$capture" "$CLONE" 2>/dev/null || echo unknown)"
      # Anchor the capture under refs/captures so an off-host responder can fetch it
      # even if the inbox-append push was lost; best-effort (blob stays local in $CLONE).
      [ "$sha" = unknown ] || anchor_blob "$sha" "gardener/$id/$base" "$CLONE" 2>/dev/null || true
      printf 'gardener-%s on %s: job %s handler FAILED (rc=%s); output captured as %s, escalated to the gardener inbox, left in doin for the reaper\n' \
        "$id" "$GARDEN" "$base" "$rc" "$sha" \
        | GARDEN_ROLE=gardener "$HERE/journal-entry.sh" error || true
    fi
  fi
  rm -f "$report" "$capture" "$completion_sentinel"
done
