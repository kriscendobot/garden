#!/bin/bash
# gardener.sh — a consumer worker (the SHARED worker spine). Claims jobs off the
# board and works them. "gardener" is the spine's historical name; the SAME file
# runs every worker KIND (gardener | cleric | …), selected by GARDEN_WORKER_KIND
# (default gardener). The loop, the board protocol, the timeout/classification
# machinery, and the drain/deploy semantics are identical across kinds — only the
# job HANDLER, the systemd labels, the per-kind count, and the journal-clone /
# marker namespaces differ, all derived from the worker-kind registry
# (common.sh worker_kind_field). A new backend drops in as a handler + a registry
# row, never a copy of this loop (design §2, cleric-worker-bid-auction-reputation.md).
#
# Usage: gardener.sh <id>            (GARDEN_WORKER_KIND=gardener|cleric)
#
# Loop: claim one job (todo→doin, CAS) → run the job handler in a per-basename
# context → complete (doin→tada report). On an empty board it sleeps and
# retries; set GARDEN_ONESHOT=1 to exit when the board drains (used by tests
# and by a timer-rearmed deployment that prefers short-lived runs).
#
# The actual work is delegated to GARDEN_JOB_HANDLER, invoked as:
#     $GARDEN_JOB_HANDLER <basename> <job-file> <report-out>
# where <job-file> is the claimed job in this worker's journal clone and
# <report-out> is a path the handler must fill with the completion report.
# The default handler is the kind's registry handler (gardener → `claude -p`,
# cleric → `codex exec`); the test harness overrides it with a fast stub.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Whether the OPERATOR set the pre-claim health gate explicitly, captured BEFORE
# common.sh defaults it — so the substituted-handler auto-disable below can defer to
# a deliberate setting instead of clobbering it (the test harness forces the gate ON
# with a stub handler to exercise the spine's park/claim behavior directly).
health_gate_explicit="${GARDEN_WORKER_HEALTH_GATE+set}"
# shellcheck source=common.sh
source "$HERE/common.sh"

id="${1:?usage: gardener.sh <id>}"

# The worker kind selects the handler, the marker/clone namespaces, and the bus
# labels from the registry. Default gardener so a bare `gardener.sh <id>` (and
# every existing test that invokes it) is unchanged.
: "${GARDEN_WORKER_KIND:=gardener}"
KIND="$GARDEN_WORKER_KIND"
export GARDEN_WORKER_KIND
STATE_NS="$(worker_kind_field "$KIND" state_ns)" || die "unknown worker kind '$KIND'"
GARDEN_TAG="$KIND/$id"

# --- git-escape ceiling (the root-repo-corruption backstop) ------------------
# The root checkout ($GARDEN_ROOT) and the journal/ worktree SHARE ONE repo
# ($GARDEN_ROOT/.git). A job that runs a git command in a dir UNDER the root that is
# not itself a repo lets git ASCEND to the root repo and mutate it — the 2026-07-17
# native-git test-fixture escape moved the root's HEAD onto a fixture `feature`
# branch and the fleet ran the corrupted tree for four days. Cap git's upward repo
# discovery at $GARDEN_ROOT for THIS worker and every child it spawns (the `claude`/
# `codex` handler and its git subprocesses inherit the env): an un-inited dir under
# the root now FATALs with "not a git repository" instead of silently latching onto
# $GARDEN_ROOT/.git. Legitimate work is unaffected — a per-job worktree, a project
# checkout, and this worker's own state clone each carry their own .git found without
# any ascent, and an explicit `git -C <dir>` is exempt (the ceiling never excludes a
# named/current dir). This is one layer: the root-repo-guard timer repairs drift that
# still slips through, and the worker prompt (worker-common.sh) forbids running git in
# $GARDEN_ROOT at all.
export GIT_CEILING_DIRECTORIES="$GARDEN_ROOT${GIT_CEILING_DIRECTORIES:+:$GIT_CEILING_DIRECTORIES}"

# Per-instance journal clone lives under the KIND's state namespace, so a cleric-1
# and a gardener-1 never share a working tree. Exported as GARDEN_GARDENER_CLONE —
# the name claim-job.sh / complete-job.sh inherit — so those primitives operate on
# THIS worker's clone without a signature change (the env is the seam).
export GARDEN_GARDENER_CLONE="${GARDEN_GARDENER_CLONE:-$GARDEN_STATE/$STATE_NS/$id/journal}"
CLONE="$GARDEN_GARDENER_CLONE"

: "${GARDEN_IDLE_SLEEP:=5}"
: "${GARDEN_ONESHOT:=0}"
DEFAULT_JOB_HANDLER="$HERE/$(worker_kind_field "$KIND" handler)"
: "${GARDEN_JOB_HANDLER:=$DEFAULT_JOB_HANDLER}"
# --- pre-claim health gate applicability (common.sh § pre-claim worker health gate)
# The gate asserts this KIND's agent CLI resolves, which is the dependency of the
# kind's OWN handler. The spine is backend-pluggable, so a SUBSTITUTED handler (a
# test stub, an operator experiment) has dependencies the spine cannot know — gating
# it on `claude` would park a worker whose handler never wanted claude. Apply the
# gate only for the registry's default handler; GARDEN_WORKER_HEALTH_GATE=0 (honored
# inside worker_health_gate) disables it outright.
if [ "$GARDEN_JOB_HANDLER" != "$DEFAULT_JOB_HANDLER" ] && [ -z "$health_gate_explicit" ]; then
  GARDEN_WORKER_HEALTH_GATE=0
  log "job handler substituted ($GARDEN_JOB_HANDLER); pre-claim agent-CLI health gate does not apply"
fi
# Upper runtime bound for ONE handler invocation (see the wrapped call below).
# INVARIANT: GARDEN_HANDLER_TIMEOUT + GARDEN_HANDLER_KILL_AFTER < GARDEN_CLAIM_TTL
# (reaper.sh, default 14400) so no handler — even one that ignores SIGTERM and is only
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
# Grace (seconds) between the group-wide SIGTERM and SIGKILL when the gardener
# sweeps the handler's process group after it returns (reap_process_group, the
# structural orphan backstop for the 2026-07-20/21 endor-leak incident). Kept SMALL
# and independent of GARDEN_HANDLER_KILL_AFTER: these are already-orphaned
# descendants we want gone fast, and the sweep early-exits the instant the group
# empties, so a clean tree that respects SIGTERM costs ~0s and only a wedged tree
# pays the full grace before the unconditional SIGKILL.
: "${GARDEN_HANDLER_REAP_GRACE:=5}"
# The reaper's stale-claim window (reaper.sh, default 14400 = 4h — the authority).
# Mirrored here ONLY so the optional per-job `handler-timeout:` header (resolved at the
# call site below) can be clamped against the INVARIANT above; keep this default in
# sync with reaper.sh's GARDEN_CLAIM_TTL. The reaper stays the sole owner of the
# requeue. Sized at 4h (not the old 1h) so the per-job budget cap it derives —
# budget_max = GARDEN_CLAIM_TTL − GARDEN_HANDLER_KILL_AFTER − 1 ≈ 14339s (~3.98h) — is
# large enough for a BUILD-HEAVY job (a cold `docker build` legitimately runs a few
# hours) to declare a `handler-timeout:` that fits and actually COMPLETE, instead of
# being SIGTERM-killed at the 40-min default on every requeue. The DEFAULT
# GARDEN_HANDLER_TIMEOUT stays 2400s, so a HEADERLESS job is unchanged; only a job
# carrying an explicit `handler-timeout:` header rides the larger budget. Tradeoff of
# the wider window: a claim whose gardener died SILENTLY (host crash / OOM before it
# could stamp the reap-now hint) now waits up to 4h to be reaped rather than 1h — the
# same-host fast paths (the reap-now hint on a transient death, the live-handler guard)
# are unaffected, so only a rare silent cross-host death pays the longer delay.
: "${GARDEN_CLAIM_TTL:=14400}"

# Elapsed-constancy early-escalation (common.sh § elapsed-constancy). When a
# transient-CLASSIFIED handler failure (a transient-claude signature or a bare
# claude-CLI failure — NOT an external signal-kill or wall-clock timeout) dies at a
# near-CONSTANT elapsed across this many requeue cycles, the gardener emits ONE
# gardener-inbox kind:error flagging a likely DETERMINISTIC overrun misclassified
# as a self-resolving blip — surfacing a genuinely-stuck job in ~2 cycles instead
# of the reaper's ~5-cycle doom threshold. GARDEN_ELAPSED_CONSTANCY_CYCLES is N,
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
# `<!-- garden-deadline-overrun: N -->` counter on such a claim so the reaper dooms
# it after GARDEN_REAP_OVERRUN_THRESHOLD (a much lower bound) instead of burning the
# full GARDEN_REAP_DOOM_THRESHOLD cycles. The epsilon is the small guard band that
# confirms the handler hit its OWN wall (default: the SIGTERM→SIGKILL grace, so a
# handler killed anywhere in the [TIMEOUT-grace, TIMEOUT+grace] window counts).
: "${GARDEN_HANDLER_DEADLINE_EPSILON:=$GARDEN_HANDLER_KILL_AFTER}"

# Minimum-plausible-overrun floor (transient-signature classification, below). A
# handler whose capture carries ONLY a transient-claude signature (an API overload
# / rate-limit / 5xx / session-or-usage-cap line) is normally a self-resolving blip
# and classified TRANSIENT. But NO genuine transient-claude signature can legitimately
# reach the capture in a couple of seconds: the inner `claude -p` must COLD-START (node
# runtime, config, MCP init — seconds on its own) and then make an API round-trip
# before it can be handed back a cap / overload / 429 / 5xx / transport-drop verdict.
# A signature that appears BELOW this floor therefore did NOT come from a started CLI
# talking to the API — it is a setup/spec defect: a broken handler or malformed prompt
# that fails fast while echoing a canned overload-shaped line (the four jobs in the
# 2026-07-03 batch each died at a CONSTANT 1–2s). That is a DETERMINISTIC failure, not
# a self-resolving blip, so it is reclassified a REAL failure OUTRIGHT and escalates a
# diagnostic NOW rather than quietly burning the reaper's full doom cycle. The floor
# is applied to the WHOLE signature set (not just the cap wording) precisely because
# the cold-start argument holds for every signature — a real fast 529/429/ECONNRESET
# still can't predate the CLI's own startup. Set to 0 to DISABLE the reclassification
# (restore the unconditional-transient behavior for any signature match, any elapsed).
: "${GARDEN_MIN_PLAUSIBLE_OVERRUN_SECS:=5}"

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
BUSY_MARKER="$(worker_busy_marker "$KIND" "$id")"
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
IDENTITY_MARKER="$GARDEN_STATE/$STATE_NS/$id.garden"
mkdir -p "$(dirname "$IDENTITY_MARKER")" 2>/dev/null || true
printf '%s\n' "$GARDEN" > "$IDENTITY_MARKER" 2>/dev/null || true

log "starting (kind=$KIND clone=$CLONE handler=$GARDEN_JOB_HANDLER oneshot=$GARDEN_ONESHOT)"

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

# Consecutive PARKED ticks under the pre-claim health gate, driving idle_backoff on
# the self-disqualification path (the failure-path analog of idle_attempt, third of
# its kind). SEPARATE from both so a park streak backs off exponentially on its own
# schedule and is reset the instant the CLI resolves — the re-probe cadence that
# makes recovery automatic after an `npm install -g` window closes.
health_attempt=1

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
# burns a doom cycle. This makes the busy-marker drain authoritative for every
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

  # monitor the bus for anything addressed to this worker, its role, or broadcast,
  # every loop. The inbox key and role channel are kind-scoped so a cleric reads
  # role/cleric and a gardener reads role/gardener.
  "$HERE/read-msgs.sh" "$KIND-$id" "role/$KIND" "broadcast" || true

  # --- pre-claim health gate (the ps23 work-sink outage) ----------------------
  # THE INVARIANT: a worker that cannot run a job never takes one. The agent CLI
  # used to be probed INSIDE the handler — after the claim had already stolen the
  # job from the shared board — so a host without the CLI failed every job in about
  # a second, returned to this loop faster than any healthy worker doing real work,
  # and won claim races disproportionately: a work SINK that drained the fleet's
  # board into doin/ and doomed it while every healthy host sat idle. And no peer
  # could stop it (set-gardeners.sh refuses a cross-host write; drain-fleet.sh's
  # marker is host-local), so the only actor that can take a broken worker out of
  # rotation is that worker. Probe BEFORE the claim; on failure park and re-poll
  # rather than exiting into a systemd restart loop, so the worker resumes by itself
  # the moment the binary reappears (an `npm install -g` window closing). The gate
  # reports ONE journal entry per host per kind per EDGE, not per tick — see
  # common.sh § pre-claim worker health gate. Placed after the drain/stop checks and
  # the bus read so a parked worker still honors a stop, a deploy, and its messages.
  if ! worker_health_gate "$KIND" "$id"; then
    if [ "$GARDEN_ONESHOT" = "1" ]; then
      # A ONESHOT run is timer-rearmed and short-lived by contract; parking in a
      # sleep loop would hold the slot until the timer's own kill. Exit CLEAN (never
      # a failure rc, which would arm a self-heal responder against an environmental
      # condition no code fix addresses) — the next tick re-probes and self-heals.
      log "agent CLI unresolvable; SELF-DISQUALIFIED — claiming nothing and exiting cleanly (oneshot; the next timer tick re-probes)"
      exit 0
    fi
    log "agent CLI unresolvable; SELF-DISQUALIFIED — claiming nothing, parked and re-probing (park tick $health_attempt)"
    idle_backoff "$health_attempt"; health_attempt=$((health_attempt+1))
    continue
  fi
  health_attempt=1

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
  # Claim-time eligibility is only an optimization. Re-probe freshly after the
  # accepted claim so an AWS key/session that expired or rotated in the race is
  # reported as a blocked completion instead of reaching the agent handler.
  if ! job_requirements_available "$jobfile" fresh; then
    missing="$(job_requirements_missing "$jobfile" fresh)"
    {
      printf '# blocked: host requirements\n\n'
      printf 'Job %q was claimed on host %s, but its post-claim capability check failed: %s.\n' "$base" "$GARDEN" "${missing:-invalid-requires-header}"
      printf 'The shared host-capability predicate was re-run fresh after claim; no handler was started.\n'
    } > "$report"
    log "post-claim host-requirements check failed for '$base': ${missing:-invalid-requires-header}; completing blocked"
    "$HERE/complete-job.sh" "$id" "$base" "$report" || die "could not complete blocked requirements report for '$base'"
    rm -f "$report"
    continue
  fi
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
  # A private code-only handoff from a provider handler.  The agent never sees
  # this path.  The spine also snapshots the job's own session dirs so a killed
  # handler (which cannot write the handoff) still gets a deterministic delta.
  usage_file="$(mktemp "${TMPDIR:-/tmp}/garden-usage-$base.XXXXXX")"
  rm -f "$usage_file"
  usage_before="$(meter_job_session_usage "$base" 2>/dev/null || true)"

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
  # kind:error, left in doin for the reaper, whose `<!-- garden-reaped: N -->` doom
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
  # which the rc-only classification cannot tell apart until the reaper's doom
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
  # The BASE budget is per-role (common.sh job_handler_budget_base): a build role
  # defaults to GARDEN_BUILD_HANDLER_TIMEOUT rather than the fleet default, because
  # a build blows through 40 minutes by construction and the producer cannot be
  # relied on to stamp a header. reaper.sh derives the SAME base from the SAME
  # helper — they must agree or a live build gets requeued onto a second gardener.
  base_budget="$(job_handler_budget_base "$jobfile")"
  handler_budget="$base_budget"
  if [ "$base_budget" != "$GARDEN_HANDLER_TIMEOUT" ]; then
    log "job '$base' role '$(plan_role "$jobfile" 2>/dev/null || true)' -> default handler budget ${base_budget}s (fleet default ${GARDEN_HANDLER_TIMEOUT}s)"
  fi
  requested_budget="$(sed -n 's/^handler-timeout:[[:space:]]*//p' "$jobfile" 2>/dev/null | head -1 | tr -dc '0-9')"
  if [ -n "$requested_budget" ] && [ "$requested_budget" -ge 1 ] 2>/dev/null; then
    budget_max=$(( GARDEN_CLAIM_TTL - GARDEN_HANDLER_KILL_AFTER - 1 ))
    if [ "$requested_budget" -le "$budget_max" ]; then
      handler_budget="$requested_budget"
      log "job '$base' declared handler-timeout=${requested_budget}s (≤ claim budget max ${budget_max}s); honoring in place of default ${base_budget}s"
    else
      handler_budget="$budget_max"
      log "job '$base' declared handler-timeout=${requested_budget}s > claim budget max ${budget_max}s; clamping to max and escalating (cannot be a claim-scoped handler)"
      alert_maintainer "handler-budget-overrun-$base" \
        "gardener job '$base' declared handler-timeout=${requested_budget}s, which exceeds what a single claim can hold (max ${budget_max}s = GARDEN_CLAIM_TTL ${GARDEN_CLAIM_TTL}s − GARDEN_HANDLER_KILL_AFTER ${GARDEN_HANDLER_KILL_AFTER}s − 1). A run-to-completion handler that needs longer than one claim cannot be claim-scoped without breaking the duplicate-execution guard: after GARDEN_CLAIM_TTL the reaper would requeue the same base onto a second gardener while this one is still running. Run it DETACHED (outside the claim-scoped handler) or SPLIT it into claim-sized stages. This cycle the handler runs clamped at ${budget_max}s and will be SIGTERM-killed at that bound — it will not complete."
    fi
  fi

  # PRODUCTIVE-CYCLE baseline. Snapshot the HEADs of this job's isolated per-job
  # worktrees BEFORE the handler runs; comparing against the after-snapshot below tells
  # us whether THIS cycle committed real work (a per-job worktree HEAD advanced). A job
  # on the sanctioned resume treadmill (push commits, exit-0 without the signal before
  # the wall, resume next claim) re-enters a PERSISTED worktree, so its HEAD sits in
  # this baseline and its fresh commits show as an advance — the signal that stops the
  # reaper false-dooming a productive long job (common.sh § productive-cycle hint).
  progress_before="$(job_worktree_heads "$base" 2>/dev/null || true)"

  # Run the handler and capture its exit code EXPLICITLY (not folded into an `if`
  # compound) so the completion gate below can branch on the three distinct
  # outcomes independently: (0 + sentinel)=complete, (0 + no sentinel)=exit-0-
  # unsatisfying requeue, (non-zero)=the existing transient-vs-real classifier.
  #
  # PROCESS-GROUP ISOLATION (structural orphan backstop; incident 2026-07-20/21:
  # the xs2rust-endor-press leaked 356 orphaned endor/endor-xst/node procs, all
  # reparented to `systemd --user` with no agent watching, because a killed/doomed
  # handler left its spawned OS tree running headless). `set -m` (job control) places
  # the backgrounded handler in its OWN process group whose pgid == the launched
  # `timeout` pid ($!), so the handler AND its whole non-detaching descendant tree
  # share one addressable group. `timeout --foreground` stops `timeout` from creating
  # a SECOND inner group of its own (which would split the tree off the pgid we
  # capture); the tree therefore all lands in the group we own, and this gardener —
  # the one process that knows that pgid and shares the host — sweeps it below.
  # timeout still enforces the wall on the direct handler (rc=124 unchanged); the
  # group-wide SIGTERM→SIGKILL escalation now comes from reap_process_group, not from
  # timeout's own group signal.
  # Candidate-gate fixtures are unpacked beneath /tmp, which is noexec on garden
  # hosts.  The explicit test seam lets such a fixture request Bash interpretation
  # without changing the normal executable-handler production path.
  handler_cmd=("$GARDEN_JOB_HANDLER")
  [ "${GARDEN_JOB_HANDLER_BASH:-0}" = "1" ] && handler_cmd=(bash "$GARDEN_JOB_HANDLER")
  set +e
  set -m
  GARDEN_GARDENER_ID="$id" GARDEN_COMPLETION_SENTINEL="$completion_sentinel" GARDEN_USAGE_FILE="$usage_file" \
    timeout --foreground --signal=TERM --kill-after="$GARDEN_HANDLER_KILL_AFTER" "$handler_budget" \
    "${handler_cmd[@]}" "$base" "$jobfile" "$report" >"$capture" 2>&1 &
  handler_pgid=$!
  set +m
  # Wait for the handler, RESUMING across any trapped-signal interruption. A
  # deploy-drain SIGTERM to THIS gardener (self-heal-run.sh signals only the worker
  # process, never the in-flight handler) fires the TERM trap above and interrupts
  # `wait`, which returns 143 while the handler is STILL RUNNING in its background
  # group. The graceful-drain contract is that the current handler RUNS TO
  # COMPLETION (the old foreground `timeout` deferred the trap until it returned), so
  # we re-`wait` rather than mistake the interruption for the handler's own exit —
  # which would both misclassify the outcome AND make reap_process_group kill a
  # legitimately-running job's tree mid-work. `kill -0` distinguishes the two:
  # process gone → `wait` returned the real exit code (break); still alive → the wait
  # was signal-interrupted (loop).
  while :; do
    wait "$handler_pgid"; hrc=$?
    kill -0 "$handler_pgid" 2>/dev/null || break
  done
  set -e

  # REAP the handler's process group UNCONDITIONALLY, for every outcome. On an
  # rc=124 wall-clock overrun timeout killed only the direct handler (--foreground),
  # so its descendants (the `claude -p` → node → xsnap/endor tree) are still alive
  # here; on a self-exit into doom/requeue-exhaustion (a `claude` that crashed or
  # hit a quota cut mid-run) the handler returned but may have left a runaway tree;
  # on clean completion the group is already empty and this is a fast no-op. Either
  # way ZERO descendants outlive the job. Safe by construction: reap_process_group
  # only ever signals THIS job's own freshly-minted group id, never a peer's (see
  # common.sh). Subshell-guarded so a stray failure cannot abort the gardener loop.
  ( reap_process_group "$handler_pgid" "$GARDEN_HANDLER_REAP_GRACE" ) || true

  # Resolve the capture ladder once, before any branch deletes the report or
  # session transcript.  Provider terminal usage wins; otherwise subtract the
  # per-base session snapshots.  A failure at every layer is explicitly recorded
  # as source:none, never mistaken for a zero-token engagement.
  elapsed_usage=$((SECONDS - handler_start))
  if command -v jq >/dev/null 2>&1 && [ -s "$usage_file" ] && jq -e . >/dev/null 2>&1 < "$usage_file"; then
    usage_measurement="$(cat "$usage_file")"
  else
    usage_after="$(meter_job_session_usage "$base" 2>/dev/null || true)"
    if [[ "$usage_before" =~ ^[0-9]+$'\t'[0-9]+$'\t'[0-9]+$'\t'[0-9]+$ ]] && [[ "$usage_after" =~ ^[0-9]+$'\t'[0-9]+$'\t'[0-9]+$'\t'[0-9]+$ ]] && command -v jq >/dev/null 2>&1; then
      usage_measurement="$(awk -F'\t' 'NR==1 {for(i=1;i<=4;i++) a[i]=$i} NR==2 {for(i=1;i<=4;i++){d=$i-a[i]; if(d<0)d=0; printf "%s%d", (i==1?"":","),d}}' <(printf '%s\n' "$usage_before") <(printf '%s\n' "$usage_after") | awk -F, '{printf "{\\\"source\\\":\\\"fallback\\\",\\\"input_tokens\\\":%s,\\\"output_tokens\\\":%s,\\\"cache_creation_tokens\\\":%s,\\\"cache_read_tokens\\\":%s}", $1,$2,$3,$4}')"
    else
      usage_measurement='{"source":"none"}'
    fi
  fi
  append_usage() { # <tada|requeue|fail>; isolated by every caller
    "$HERE/usage-append.sh" "$base" "$elapsed_usage" "$1" "$usage_measurement" >/dev/null 2>&1 || true
  }

  # PRODUCTIVE-CYCLE detection. For any NON-completion outcome (the job is about to be
  # left in doin for the reaper to requeue), decide whether the handler made real
  # progress this cycle and, if so, stamp the productive marker on our own still-in-doin
  # claim. The reaper then RESETS the reap/doom counter for a productive cycle instead
  # of incrementing it, so a job pushing work every cycle never dooms while a job that
  # truly fails every cycle (no HEAD movement) still dooms at the threshold. Stamped
  # HERE, before the branch-specific reap-now/deadline hints below, so those hints (which
  # rewrite the whole file, preserving body lines) carry it forward in the same claim.
  # Subshell-isolated so a sync_clone offline-exit cannot kill this gardener; best-effort.
  if [ "$hrc" -ne 0 ] || [ ! -e "$completion_sentinel" ]; then
    progress_after="$(job_worktree_heads "$base" 2>/dev/null || true)"
    if job_cycle_productive "$progress_before" "$progress_after"; then
      if ( stamp_productive_cycle_hint "$CLONE" "$JOBS_DOIN/$base.md" ); then
        log "productive cycle for '$base' (a per-job worktree HEAD advanced this cycle); reaper will RESET its doom counter, not increment"
      else
        log "could not stamp productive-cycle hint on '$base' (rc=$?); the reaper will count this cycle toward doom"
      fi
    fi
  fi
  # A completed feature build has one more mandatory completion edge: its open
  # draft PR must receive a gauntlet job before this build is allowed into tada.
  # Historically the generic Claude handler only *instructed* the builder to
  # continue, so builds posted by post-plan --blocked completed and vanished
  # from the board with their draft PRs stranded. Keep the handoff inside the
  # worker's durable completion path. A posting failure becomes a normal failed
  # claim below, which the reaper retries, rather than a silent stalled build.
  if [ "$hrc" -eq 0 ] && [ -e "$completion_sentinel" ]; then
    set +e
    "$HERE/auto-gauntlet-handoff.sh" "$base" "$jobfile" "$report" >>"$capture" 2>&1
    handoff_rc=$?
    set -e
    if [ "$handoff_rc" -ne 0 ]; then
      hrc=$handoff_rc
      log "auto-gauntlet handoff FAILED for '$base' (rc=$hrc); leaving build in doin for retry"
    fi
  fi

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
    GARDEN_JOB_DURATION_SECS=$elapsed_usage GARDEN_ENGAGEMENT_USAGE="$usage_measurement" \
      "$HERE/complete-job.sh" "$id" "$base" "$report"; crc=$?
    set -e
    if [ "$crc" -eq "${GARDEN_OFFLINE_RC:-75}" ]; then
      append_usage requeue
      log "offline during completion of '$base' (rc=$crc); left in doin for TTL requeue"
      rm -f "$report" "$capture" "$completion_sentinel" "$usage_file"
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
    append_usage requeue
    # EXIT-0-UNSATISFYING: the handler exited 0 but the completion sentinel is
    # absent — it NEVER signaled completion — a `claude` that exited cleanly
    # without finishing: quota/usage cut mid-response, an API error swallowed to a
    # clean exit, or a run that "did not reach a satisfying conclusion." This is
    # the gap the deterministic-requeue directive closes: DO NOT complete it
    # (doin→tada would record unfinished work as done and lose it — the reaper
    # never requeues tada). Instead requeue it the SAME way a transient non-zero
    # failure is requeued: leave it in doin and stamp a reap-now hint so the
    # reaper (the single writer of the requeue AND the doom counter) moves it
    # doin→todo on its next tick and increments `<!-- garden-reaped: N -->`. A job
    # that keeps exiting-0-unsatisfying every cycle therefore escalates to the
    # maintainer as DOOM after GARDEN_REAP_DOOM_THRESHOLD cycles — bounded
    # requeue, never silently lost, never infinitely requeued. No $capture
    # diagnostic is escalated: a clean exit-0 produced no failure output, so this
    # is a kind:progress note, not a kind:error.
    elapsed=$((SECONDS - handler_start))
    cycle="$(reap_count "$jobfile")"
    log "handler for '$base' exited 0 WITHOUT the completion signal (exit-0-unsatisfying: quota/API/clean-but-unfinished); requeueing (requeue cycle $cycle, elapsed=${elapsed}s), left in doin for reaper requeue"
    # SILENT-UNTIL-REPEAT. A `kind:progress` note on EVERY exit-0-unsatisfying
    # requeue is routine self-healing progress. A CYCLE-1 exit-0-unsatisfying is a
    # benign, expected transient — a quota/usage cut, a swallowed API error, a run
    # that clean-exited without finishing — that the reaper requeues silently and
    # escalates to DOOM only after GARDEN_REAP_DOOM_THRESHOLD cycles. So a
    # single-cycle note is routine progress that burns supervisor/journal context,
    # the silent-until-error violation the mentor brief flags (seen in the digest:
    # job fix-stale-bulletin-leader-singleton, requeue cycle 1). CYCLE-1 TRANSIENTS
    # THEREFORE LOG LOCALLY ONLY: the local `log` above stays UNCONDITIONAL
    # (stderr/systemd/journalctl operator visibility), but the SHARED-journal note
    # fires only on a REPEAT (cycle >= 2) — a second requeue indicates a
    # deterministic, non-transient cut worth a note, distinct from a one-off blip.
    # The reaper — the single writer of the requeue AND the `<!-- garden-reaped:
    # N -->` doom counter — still owns the authoritative escalation; as a repeat
    # nears it (the reaper computes count=cycle+1 and dooms at count>=threshold,
    # so cycle>=threshold-1 is the last requeue before doom) the note additionally
    # flags ABOUT TO ESCALATE.
    doom_threshold="${GARDEN_REAP_DOOM_THRESHOLD:-5}"
    case "$doom_threshold" in ''|*[!0-9]*) doom_threshold=5 ;; esac
    # SNAPSHOT THE PRIOR SERIES *BEFORE* THIS CYCLE'S OWN NOTE IS WRITTEN.
    # The constancy check below needs the elapsed of the PRIOR cycles; it appends
    # this cycle's $elapsed itself. Reading the series after the note below is
    # pushed — and after stamp_reap_now_hint's sync_clone hard-resets $CLONE to the
    # origin tip that now CONTAINS that note — makes the series' last element THIS
    # cycle's elapsed, which the check then appends a second time. The window is
    # then [current, current]: bit-identical by construction, so constancy is
    # ALWAYS "confirmed", on the very first cycle, for every job. That is not
    # hypothetical: on 2026-07-28 it stamped the early-doom counter on nine
    # unrelated jobs in eight minutes on one host, each reported as a perfectly
    # constant pair at a different value (12,12s / 61,61s / 1403,1403s …) — and at
    # GARDEN_REAP_OVERRUN_THRESHOLD=1 the reaper doom-parked four of them, one
    # (fu-endojs-endo-but-for-bots-pr825-8840fcdb-2) on the only cycle it had ever
    # run. Snapshotting here restores the invariant the check was written against.
    prior_series0="$(prior_transient_elapsed_series "$CLONE" "$base")"
    if [ "$cycle" -ge 2 ]; then
      near_doom=""
      [ "$cycle" -ge "$(( doom_threshold - 1 ))" ] && near_doom=" — ABOUT TO ESCALATE as doom"
      printf 'gardener-%s on %s: job %s handler exited 0 but never emitted the completion signal (exit-0-unsatisfying — claude quota/usage cut, swallowed API error, or unfinished run); requeueing doin→todo (requeue cycle %s of doom threshold %s, elapsed=%ss), left in doin for reaper requeue%s\n' \
        "$id" "$GARDEN" "$base" "$cycle" "$doom_threshold" "$elapsed" "$near_doom" \
        | GARDEN_ROLE=gardener "$HERE/journal-entry.sh" progress || true
    fi
    if ( stamp_reap_now_hint "$CLONE" "$JOBS_DOIN/$base.md" ); then
      log "stamped reap-now hint on '$base'; reaper will requeue before TTL (doom cycle still counts)"
    else
      log "could not stamp reap-now hint on '$base' (rc=$?); falling back to the reaper's TTL requeue"
    fi

    # --- elapsed-constancy early-escalation (exit-0-unsatisfying wedge) ---------
    # Mirror of the rc!=0 transient branch's elapsed-constancy check (below) into the
    # exit-0 path. Requeueing an exit-0-unsatisfying job is correct for a genuine
    # blip (a quota/usage cut, a swallowed API error, a run that clean-exited without
    # finishing), but an exit-0-unsatisfying CLASSIFICATION is not proof of a
    # self-resolving blip: a child that keeps exiting 0 without finishing at a
    # near-CONSTANT elapsed every cycle — with NO further HEAD movement — is the
    # WEDGE the xs2rust-endor-press note flagged ("repeated exit-0-unsatisfying
    # cycles with no further HEAD movement would mean the child is wedged, not
    # working"), burning ~2000s per cycle silently up to GARDEN_REAP_DOOM_THRESHOLD
    # times before the reaper dooms it. Its tell is the SAME near-constant elapsed
    # the rc!=0 overrun check watches for. Recover the prior cycles' elapsed for this
    # base (READ-ONLY grep of this clone's already-synced progress notes — the exit-0
    # note above carries the same `job <base> handler exited … elapsed=<N>s` anchor
    # prior_transient_elapsed_series reads — no new state, no CAS, the reaper stays
    # the sole requeue writer) and, once the trailing N-cycle window agrees within the
    # tolerance band, emit ONE gardener-inbox kind:error flagging the likely wedge so
    # a human sees it in ~2 cycles instead of the reaper's ~5-cycle doom burn.
    # Gated by GARDEN_ELAPSED_CONSTANCY_CYCLES (N; 0/1 disables). No rc/capture gate
    # is needed: an exit-0-unsatisfying handler produced NO failure output by
    # construction, and there is only one kind here to watch — a clean exit that
    # never finished. (The rc!=0 branch's is_external_kill_rc/is_handler_timeout_rc
    # exclusions have no analogue on the exit-0 path.)
    constancy_n0="$GARDEN_ELAPSED_CONSTANCY_CYCLES"
    # A misconfigured (non-integer) tunable DISABLES the check rather than crashing
    # the gardener loop on the arithmetic test below.
    case "$constancy_n0" in ''|*[!0-9]*) constancy_n0=0 ;; esac
    # SUPPRESS during a fleet-wide outage: the constancy check reads a near-constant
    # elapsed as "a WEDGED child, not a working one", but under an ENGAGED fleet brake
    # a constant elapsed is just as consistent with an environmental storm (a usage cap
    # tripping at the same point every run — the 2026-07-01 incident) that will
    # self-resolve. Firing a wedge advisory then is a false alarm, so skip it while the
    # brake is engaged; the outage-cycle hint (below) already spares the doom counter.
    if [ "$constancy_n0" -ge 2 ] && [ "$cycle" -ge 2 ] && ! fleet_brake_engaged; then
      # Prior cycles' elapsed (SNAPSHOTTED above, before this cycle's own note was
      # written and before stamp_reap_now_hint re-synced $CLONE onto a tip carrying
      # it — see the snapshot comment) with the current elapsed appended, then the
      # trailing N-cycle window; require a FULL window before judging constancy.
      series0="$(printf '%s\n' "$prior_series0"; printf '%s\n' "$elapsed")"
      window0="$(printf '%s\n' "$series0" | grep -E '^[0-9]+$' | tail -n "$constancy_n0" || true)"
      count0="$(printf '%s\n' "$window0" | grep -cE '^[0-9]+$' || true)"
      # Fire at most ONCE per base: dedup on the marker the kind:error entry below
      # carries (distinct from the rc!=0 overrun-suspect marker, so a job that flaps
      # between the two failure kinds surfaces each independently). The clone was
      # synced at claim, so a prior cycle's escalation entry is visible here.
      already0=0
      if grep -rlqF "elapsed-constancy exit0-wedge-suspect: $base" "$CLONE/entries" 2>/dev/null; then already0=1; fi
      tol0="$GARDEN_ELAPSED_CONSTANCY_TOLERANCE_PCT"
      if [ "${count0:-0}" -ge "$constancy_n0" ] && [ "$already0" -eq 0 ] \
         && elapsed_within_band "$tol0" $window0; then
        series0_csv="$(printf '%s\n' "$window0" | paste -sd, - || true)"
        # Escalate a diagnostic to the gardener inbox (the ONE kind:error). Build a
        # self-describing transcript; report-error.sh hashes it and appends the inbox
        # section. GARDEN_JOURNAL="$CLONE" mirrors the real-failure branch.
        constancy0_tr="$(mktemp "${TMPDIR:-/tmp}/garden-exit0-constancy-$base.XXXXXX")"
        {
          printf 'elapsed-constancy exit0-wedge-suspect: %s\n\n' "$base"
          printf 'gardener-%s on %s: job %s keeps exiting 0 WITHOUT the completion signal\n' "$id" "$GARDEN" "$base"
          printf '(exit-0-unsatisfying) at a near-CONSTANT elapsed across the last %s requeue\n' "$constancy_n0"
          printf 'cycles (elapsed window, oldest->newest: %ss; requeue cycle %s; tolerance +/-%s%%).\n\n' "$series0_csv" "$cycle" "$tol0"
          printf 'That is the signature of a WEDGED child, not a working one: a clean exit\n'
          printf 'that never reaches a satisfying conclusion, burning the same wall-time every\n'
          printf 'cycle with no further progress (the xs2rust-endor-press wedge — repeated\n'
          printf 'exit-0-unsatisfying cycles with no further HEAD movement mean the child is\n'
          printf 'wedged, not working), NOT a one-off quota/usage cut or swallowed API error\n'
          printf '(those vary in elapsed). Left in doin for the reaper (requeue ownership\n'
          printf 'UNCHANGED); it will otherwise burn all %s doom cycles before surfacing.\n' "${GARDEN_REAP_DOOM_THRESHOLD:-5}"
          printf 'Triage the job spec / handler rather than waiting out the doom threshold.\n'
        } > "$constancy0_tr"
        sha0="$(GARDEN_JOURNAL="$CLONE" "$GARDEN_ROOT/skills/gardener-inbox-error-reporting/report-error.sh" \
                 --transcript "$constancy0_tr" --lane 0 --state elapsed-constancy-exit0-wedge-suspect \
                 --context "gardener-$id on $GARDEN: job '$base' exit-0-unsatisfying but elapsed near-constant (${series0_csv}s) over $constancy_n0 cycles — likely a wedged child, not a working one" \
               2>/dev/null || true)"
        rm -f "$constancy0_tr"
        log "elapsed-constancy early-escalation for '$base': exit-0-unsatisfying but elapsed near-constant (${series0_csv}s) over $constancy_n0 cycles; escalated ONE kind:error to the gardener inbox (sha=${sha0:-unknown}), left in doin (requeue ownership unchanged)"
        printf 'gardener-%s on %s: job %s handler keeps exiting 0 without the completion signal (exit-0-unsatisfying), and elapsed is near-constant (%ss) across the last %s requeue cycles (cycle %s) — likely a WEDGED child, not a working one (the xs2rust-endor-press wedge), not a one-off quota/API blip; escalated ONE kind:error to the gardener inbox (elapsed-constancy exit0-wedge-suspect: %s, sha=%s), left in doin for the reaper (requeue ownership unchanged)\n' \
          "$id" "$GARDEN" "$base" "$series0_csv" "$constancy_n0" "$cycle" "$base" "${sha0:-unknown}" \
          | GARDEN_ROLE=gardener "$HERE/journal-entry.sh" error || true
      fi
    fi

    rm -f "$report" "$capture" "$completion_sentinel" "$usage_file"
    # Transient (quota/API/clean-but-unfinished): feed the SHARED fleet brake and
    # apply the PER-WORKER failure backoff so this just-failed worker does not
    # instantly re-claim and re-run against the same exhausted quota. Cadence only
    # — the reaper still owns the requeue.
    record_transient_failure
    # If this transient failure is part of a fleet-wide correlated outage (the shared
    # brake is now engaged — many handlers failing at once, not a defect in THIS job),
    # stamp the outage-cycle hint so the reaper PAUSES the doom counter for this cycle:
    # an environmental storm must never doom an otherwise-healthy job (the 2026-07-01
    # dozen-job dooming; common.sh § outage-cycle hint). Checked AFTER recording so
    # this failure counts toward the density. Best-effort, subshell-isolated so a
    # sync_clone offline-exit cannot kill this gardener.
    if fleet_brake_engaged; then
      if ( stamp_outage_cycle_hint "$CLONE" "$JOBS_DOIN/$base.md" ); then
        log "fleet brake ENGAGED at failure time for '$base'; stamped outage-cycle hint — reaper will PAUSE the doom counter this cycle (sustained environmental transient, not counted toward doom)"
      else
        log "could not stamp outage-cycle hint on '$base' (rc=$?); this cycle will count toward doom"
      fi
    fi
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
      # `<!-- garden-reaped: N -->` doom counter escalates it as doom after the
      # threshold — surfacing the deadlock after N cycles instead of spamming a
      # real-error on every requeue.
      transient=1
      # DISTINGUISH a self-wall hit from an external kill masquerading as rc=124.
      # rc=124 is `timeout`'s own expiry code, so it ALREADY means the handler's own
      # wall-clock wrapper fired — but confirm the elapsed is actually AT the wall
      # (within GARDEN_HANDLER_DEADLINE_EPSILON of the ACTUAL budget this run used
      # — handler_budget, which a `handler-timeout:` job header may have lowered
      # below GARDEN_HANDLER_TIMEOUT; comparing against the global constant made a
      # per-job budget's wall-hit read as an ordinary transient and burn the full
      # doom threshold instead of the fast overrun path) before
      # treating it as a DETERMINISTIC budget overrun. A handler that hit its own
      # 2400s wall will be killed identically every requeue, so requeuing it the full
      # 5 doom cycles (~200 min of gardener wall-clock) before surfacing it is pure
      # waste — two identical deadline hits is already conclusive. Stamp the
      # deadline-overrun counter (below, in the transient block) so the reaper dooms
      # it after GARDEN_REAP_OVERRUN_THRESHOLD instead. The epsilon guard is
      # belt-and-suspenders: an external kill varies in elapsed and reads as 143/137
      # (is_external_kill_rc), not 124, so this rarely excludes anything — but it means
      # only a genuine wall-hit gets the fast-doom treatment.
      if [ "$elapsed" -ge "$(( handler_budget - GARDEN_HANDLER_DEADLINE_EPSILON ))" ]; then
        deadline_overrun=1
      fi
    elif is_environmental_rc "$rc"; then
      # An ENVIRONMENTAL failure (rc=GARDEN_ENV_RC/GARDEN_OFFLINE_RC, EX_TEMPFAIL):
      # the handler could not RUN — its agent CLI was absent from PATH and from every
      # known install location after a bounded retry (die_environmental, common.sh
      # § agent-CLI resolution), or the tick lost connectivity. Nothing about the
      # CLAIMED JOB caused it, so — exactly like the signal-kills and the wall-clock
      # timeout above — classify it transient BEFORE the capture-content split:
      # die_environmental deliberately WRITES a diagnostic to the capture, and a
      # well-explained environmental failure is still not a job defect. This is the
      # ps23 fix: an in-place `npm install -g @anthropic-ai/claude-code` unlinked
      # /usr/local/bin/claude for a few seconds and every job claimed in that window
      # was escalated as a defect in itself. The reaper requeues after the TTL, by
      # which time the relink has completed.
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
      # A capture carrying ONLY a transient-claude signature normally means a
      # self-resolving blip → transient. But a GENUINE overload/5xx overrun cannot
      # trip in a couple of seconds (the CLI must cold-start, reach the API, and be
      # told to stop). An AMBIGUOUS overload-shaped signature that appears BELOW the
      # GARDEN_MIN_PLAUSIBLE_OVERRUN_SECS floor is implausibly fast for a real
      # overload and is a setup/spec defect echoing an overload-shaped line (the four
      # 1–2s jobs of the 2026-07-03 batch) — a DETERMINISTIC failure. Leave
      # transient=0 so it falls through to the real-failure escalation NOW instead of
      # burning the full doom cycle. A floor of 0 disables the reclassification
      # (unconditional transient).
      # EXCEPTION: an EXPLICIT session/usage-cap wording (is_explicit_cap_signature,
      # common.sh) is transient by CONTENT regardless of elapsed — a real cap
      # rejection is one fast API round trip, so it legitimately dies under the
      # floor (the 2026-07-17 00:43Z incident: rc=1 after 2s, "You've hit your
      # session limit · resets 2am (UTC)", misclassified deterministic twice). The
      # floor keeps its bite only for the AMBIGUOUS overload-shaped signatures it
      # was built for.
      floor="$GARDEN_MIN_PLAUSIBLE_OVERRUN_SECS"
      case "$floor" in ''|*[!0-9]*) floor=0 ;; esac   # misconfigured → disabled, never crash the loop
      # FAIL SAFE IF THE EXEMPTION HELPER IS ABSENT. A call to an undefined shell
      # function under `if` is not an error here — bash prints `command not found`
      # to stderr, returns 127, and the branch simply reads FALSE. So a common.sh
      # that has LOST is_explicit_cap_signature does not break the classifier
      # loudly; it silently deletes the exemption and every capped handler falls
      # into the else-branch as a DETERMINISTIC defect. That is not hypothetical:
      # a0cd3eae13 (2026-07-21) clobbered this helper out of common.sh from a stale
      # base and the fleet ran that way for a week (restored 2026-07-28 by
      # da2572a260). The cost was paid on the REAL-FAILURE branch below, which —
      # unlike the transient branch — leaves the claim in doin WITHOUT a reap-now
      # hint, so each misclassified cycle stranded the job for the full
      # GARDEN_CLAIM_TTL (4h) instead of requeueing on the next reaper tick:
      # endojs-endo-but-for-bots-pr882-shepherd burned `garden-reaped: 4` and ~12.5h
      # of latency on a PR whose CI had been green since the previous 22:27Z, then
      # completed in 114s once a host with the helper claimed it (243 kind:error
      # escalations fleet-wide across 2026-07-28/29). The exemption's whole purpose
      # is to keep a cap TRANSIENT, so when it cannot be evaluated the conservative
      # answer is transient (a bounded, doom-counted requeue on the next tick),
      # never a 4h strand plus an inbox escalation. Log it as its own line so the
      # missing helper is greppable instead of buried as a bare bash diagnostic.
      if [ "$floor" -gt 0 ] && [ "$elapsed" -lt "$floor" ] && ! declare -F is_explicit_cap_signature >/dev/null 2>&1; then
        log "handler for '$base' died in only ${elapsed}s (< GARDEN_MIN_PLAUSIBLE_OVERRUN_SECS=${floor}s) but the cap-exemption helper is_explicit_cap_signature is UNDEFINED (common.sh is missing it — check for a stale-base clobber, cf. a0cd3eae13/da2572a260); cannot evaluate the exemption, so failing SAFE and keeping transient (transient=1)"
        transient=1
      elif [ "$floor" -gt 0 ] && [ "$elapsed" -lt "$floor" ]; then
        if is_explicit_cap_signature "$(tail -c 65536 "$capture" 2>/dev/null)"; then
          log "handler for '$base' died in only ${elapsed}s (< GARDEN_MIN_PLAUSIBLE_OVERRUN_SECS=${floor}s) but the capture carries an EXPLICIT session/usage-cap wording — a real cap rejection IS this fast; keeping transient (transient=1)"
          transient=1   # explicit cap statement: transient by content, elapsed irrelevant
        else
          log "handler for '$base' emitted a transient-claude signature but died in only ${elapsed}s (< GARDEN_MIN_PLAUSIBLE_OVERRUN_SECS=${floor}s): too fast for a genuine usage/session cap — treating as a DETERMINISTIC setup/spec defect, escalating as a real failure (transient=0)"
          transient=0   # sub-few-second signature: a setup/spec defect, not a blip
        fi
      else
        transient=1   # capture carries only a transient-claude signature
      fi
    fi

    if [ "$transient" -eq 1 ]; then
      append_usage requeue
      # Fold the reaper's already-present requeue-cycle count (the
      # `<!-- garden-reaped: N -->` marker on $jobfile) into the note so a job that
      # dies the SAME transient way every cycle is greppable in the journal NOW,
      # instead of looking identical on its 1st and 5th requeue and surfacing only
      # after the reaper's ~5×TTL doom cycle (~5h). reap_count is READ-ONLY of an
      # existing marker — no new state, no CAS — and defaults to 0 on the first
      # pass. This does NOT re-open the OPEN failed-job-lane decision flagged above;
      # it only makes a not-actually-transient job (a wedged scholar fetch, an OOM)
      # visible early to a human or a future watchman self-test.
      cycle="$(reap_count "$jobfile")"
      # Fold in the handler's elapsed wall-time too. The reap_count alone cannot
      # distinguish a benign deploy-drain blip (killed at a VARIED elapsed near a
      # known deploy) from a job that deterministically overruns and is killed at
      # a CONSTANT elapsed every cycle — they look identical until the doom
      # threshold (~5 cycles). A near-constant elapsed across requeue cycles is a
      # positive signal of a deterministic overrun or a fixed external bound, so a
      # human or a watchman self-test can surface a genuinely-stuck job early
      # instead of waiting out the full doom cycle. elapsed is READ-ONLY of the
      # SECONDS timing captured at the call site — no new state, no CAS.
      log "handler outage for '$base' looks transient (rc=$rc, requeue cycle $cycle, elapsed=${elapsed}s, signal-kill/timeout/empty/transient-signature capture); no escalation, left in doin for reaper requeue"
      # SILENT-UNTIL-ESCALATION (same rationale as the exit-0-unsatisfying branch
      # above): the reaper dooms a job that keeps failing the same transient way
      # after GARDEN_REAP_DOOM_THRESHOLD cycles, so a per-cycle shared-journal note
      # on each routine requeue (a deploy-drain SIGTERM, a shepherd hitting the 2400s
      # wall as rc=124, an empty-output blip) just duplicates self-healing progress.
      # Keep the local `log` (stderr/systemd) and fire the SHARED-journal note only as
      # the job APPROACHES the reaper's doom escalation (cycle>=threshold-1).
      #
      # EXCEPTION — the elapsed-constancy early-escalation below reconstructs its input
      # elapsed SERIES by grepping THESE per-cycle transient notes out of the journal
      # (common.sh prior_transient_elapsed_series). Silencing them for the subset it
      # watches — a transient-claude-signature / bare claude-CLI failure WITH output,
      # NOT an external signal-kill, wall-clock timeout, or empty-capture blip — would
      # blind that check (it would never assemble a full window and could not surface a
      # deterministic overrun misclassified as a blip in ~2 cycles). So keep writing the
      # note for exactly that subset; only the noisy escalation-less routine requeues
      # (which no downstream check consumes) are quieted until doom is imminent.
      doom_threshold="${GARDEN_REAP_DOOM_THRESHOLD:-5}"
      case "$doom_threshold" in ''|*[!0-9]*) doom_threshold=5 ;; esac
      # SNAPSHOT THE PRIOR SERIES *BEFORE* THIS CYCLE'S OWN NOTE IS WRITTEN — same
      # self-sample defect, and the same fix, as the exit-0 branch above (see the
      # snapshot comment there for the 2026-07-28 incident this closes). Here the
      # re-sync that pulls this cycle's note into $CLONE comes from
      # stamp_reap_now_hint / stamp_deadline_overrun_hint below.
      prior_series="$(prior_transient_elapsed_series "$CLONE" "$base")"
      constancy_n_g="$GARDEN_ELAPSED_CONSTANCY_CYCLES"
      case "$constancy_n_g" in ''|*[!0-9]*) constancy_n_g=0 ;; esac
      constancy_applicable=0
      if [ "$constancy_n_g" -ge 2 ] && [ -s "$capture" ] \
         && ! is_external_kill_rc "$rc" && ! is_handler_timeout_rc "$rc" \
         && ! is_environmental_rc "$rc"; then
        constancy_applicable=1
      fi
      # GATE OUT the deadline-overrun path: an rc=124 handler that hit its OWN wall
      # (deadline_overrun=1) gets the accurate, distinctive deadline-overrun progress
      # entry emitted below — NOT this generic one. Emitting both produced two
      # contradictory journal entries per event (this one says "no escalation" while
      # the block below stamps an early-doom hint). So this generic note fires only
      # on the OTHER transient paths (external signal-kill, plain timeout below the
      # wall, empty-capture blip, transient-claude signature). The local `log` above
      # is unconditional and stays.
      if { [ "$cycle" -ge "$(( doom_threshold - 1 ))" ] || [ "$constancy_applicable" -eq 1 ]; } \
         && [ "${deadline_overrun:-0}" -ne 1 ]; then
        printf 'gardener-%s on %s: job %s handler exited rc=%s (signal-kill/timeout/empty/transient-signature output); transient handler outage, requeue cycle %s of doom threshold %s (elapsed=%ss); left in doin for reaper requeue\n' \
          "$id" "$GARDEN" "$base" "$rc" "$cycle" "$doom_threshold" "$elapsed" \
          | GARDEN_ROLE=gardener "$HERE/journal-entry.sh" progress || true
      fi
      # We KNOW this claim is dead (the handler was killed/blipped, not failing on a
      # job defect), so don't make the job wait out the full GARDEN_CLAIM_TTL for the
      # reaper to notice its claimed_at is stale. Stamp a reap-now hint on our own
      # still-in-doin claim: the reaper requeues a hinted claim on its NEXT tick
      # (≤10 min) while still incrementing the `<!-- garden-reaped: N -->` doom
      # counter, so a job killed THE SAME WAY every cycle (a wedged Wayback fetch
      # SIGTERM'd each cycle) still escalates to the maintainer as doom after the
      # threshold rather than requeueing forever. The reaper stays the single writer
      # of the requeue; we only hint. Subshell-isolated so a sync_clone offline-exit
      # cannot kill this gardener; best-effort — on failure the TTL requeue still
      # backstops it. (Distinct from the non-signal real-failure branch below, which
      # escalates a diagnostic and stays on the plain reaper-TTL path unchanged.)
      if [ "${deadline_overrun:-0}" -eq 1 ]; then
        # The handler hit its OWN wall-clock budget (rc=124, elapsed≈GARDEN_HANDLER_TIMEOUT):
        # a DETERMINISTIC overrun that will be killed identically on every requeue, NOT a
        # varying external kill. Stamp the deadline-overrun COUNTER alongside the reap-now
        # hint (stamp_deadline_overrun_hint does both) so the reaper escalates it to DOOM
        # after GARDEN_REAP_OVERRUN_THRESHOLD (1) cycle instead of the full
        # GARDEN_REAP_DOOM_THRESHOLD (5) — a job that overran its budget will overrun it
        # identically on every requeue, so ONE deadline hit is already conclusive, and
        # requeuing it 5× (~5×the handler budget of gardener wall-clock) before surfacing
        # it is pure waste. A productive wall-hit (HEAD advanced — the sanctioned resume
        # treadmill) is spared: the reaper RESETS this counter on a productive cycle.
        log "handler for '$base' hit its OWN wall-clock budget (rc=124, elapsed=${elapsed}s ≈ handler-budget=${handler_budget}s): deterministic deadline overrun, stamping the overrun counter for early doom"
        printf 'gardener-%s on %s: job %s handler hit its OWN wall-clock budget (rc=124, elapsed=%ss ≈ handler-budget=%ss) — a DETERMINISTIC deadline overrun, not a varying external kill; stamping <!-- garden-deadline-overrun --> so the reaper dooms it after GARDEN_REAP_OVERRUN_THRESHOLD cycles instead of the full doom threshold; left in doin for the reaper\n' \
          "$id" "$GARDEN" "$base" "$elapsed" "$handler_budget" \
          | GARDEN_ROLE=gardener "$HERE/journal-entry.sh" progress || true
        # EARLY ACTIONABLE DIAGNOSIS to the maintainer. A job that DECLARES an
        # over-large `handler-timeout:` gets the clamp-path alert above (line ~358)
        # before it ever runs; a job that runs under the DEFAULT budget and
        # deterministically overruns (rc=124 at the wall — the xs2rust-endor-stage4-
        # modules case: 2400s default, always killed) gets no such signal, so today
        # the maintainer must reverse-engineer "too big for one claim" from the
        # reaper's generic doom report cycles later. Emit the same diagnosis HERE,
        # deterministically, under the SAME dedup key as the clamp path so both
        # surfaces of the one root cause collapse onto a single throttled alert. The
        # two overrun cycles before doom (GARDEN_REAP_OVERRUN_THRESHOLD=2) are
        # ~one handler-budget + requeue-latency apart (≈2400-3000s < the 3600s
        # default GARDEN_ALERT_THROTTLE_SECS), so the key dedups them to one alert.
        # Best-effort/subshell-isolated like the surrounding stamps — never fail the
        # gardener (alert_maintainer already swallows its own errors).
        ( alert_maintainer "handler-budget-overrun-$base" \
            "gardener job '$base' DETERMINISTICALLY overran its handler budget (rc=124 at the wall, elapsed=${elapsed}s ≈ handler-budget=${handler_budget}s). It does not fit in a single claim-scoped handler and will be DOOMED after GARDEN_REAP_OVERRUN_THRESHOLD (${GARDEN_REAP_OVERRUN_THRESHOLD:-2}) cycles without completing. Same root cause as an over-large declared handler-timeout, but under the default budget it gets no early signal — surfaced here so you don't have to reverse-engineer it from the reaper's generic doom report. Remedy: SPLIT it into claim-sized stages, or run it DETACHED outside the claim-scoped handler." ) || true
        if ( stamp_deadline_overrun_hint "$CLONE" "$JOBS_DOIN/$base.md" ); then
          log "stamped deadline-overrun hint on '$base'; reaper will requeue before TTL and doom early (overrun cycle counts)"
        else
          log "could not stamp deadline-overrun hint on '$base' (rc=$?); falling back to the reaper's TTL requeue"
        fi
      elif ( stamp_reap_now_hint "$CLONE" "$JOBS_DOIN/$base.md" ); then
        log "stamped reap-now hint on '$base'; reaper will requeue before TTL (doom cycle still counts)"
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
      # UNCHANGED through all GARDEN_REAP_DOOM_THRESHOLD cycles before the reaper's
      # doom counter surfaces it (~5×TTL). Its tell is a near-CONSTANT elapsed
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
      # SUPPRESS during a fleet-wide outage. This path does more than advise — it stamps
      # the early-doom deadline-overrun counter (below) so a "deterministic overrun"
      # dooms after GARDEN_REAP_OVERRUN_THRESHOLD (1) cycle. But under an ENGAGED fleet
      # brake a near-constant elapsed is equally the signature of an environmental storm
      # (a session/usage cap tripping at the same point every run — the 2026-07-01
      # incident) that will self-resolve, NOT a per-job defect. Stamping the overrun
      # counter then would doom a healthy job via the overrun path on its first stamp,
      # DEFEATING the outage-cycle doom-pause. So skip the whole early-escalation while the brake is
      # engaged; the outage-cycle hint (above) spares the requeue counter for these cycles.
      if [ "$constancy_n" -ge 2 ] && [ "$cycle" -ge 2 ] && [ -s "$capture" ] \
         && ! is_external_kill_rc "$rc" && ! is_handler_timeout_rc "$rc" \
         && ! is_environmental_rc "$rc" && ! fleet_brake_engaged; then
        # Prior cycles' elapsed (SNAPSHOTTED above, before this cycle's own note was
        # written and before the stamp helpers re-synced $CLONE onto a tip carrying
        # it) with the current elapsed appended, then the trailing N-cycle window;
        # require a FULL window before judging constancy.
        series="$(printf '%s\n' "$prior_series"; printf '%s\n' "$elapsed")"
        window="$(printf '%s\n' "$series" | grep -E '^[0-9]+$' | tail -n "$constancy_n" || true)"
        count="$(printf '%s\n' "$window" | grep -cE '^[0-9]+$' || true)"
        # Fire at most ONCE per base: dedup on the marker the kind:error entry below
        # carries. The clone was synced at claim, so a prior cycle's escalation entry
        # (pushed to origin, pulled into this clone) is visible here — no new state.
        already=0
        if grep -rlqF "elapsed-constancy overrun-suspect: $base" "$CLONE/entries" 2>/dev/null; then already=1; fi
        tol="$GARDEN_ELAPSED_CONSTANCY_TOLERANCE_PCT"
        if [ "${count:-0}" -ge "$constancy_n" ] && elapsed_within_band "$tol" $window; then
          series_csv="$(printf '%s\n' "$window" | paste -sd, - || true)"
          # The window CONFIRMS a deterministic overrun. Two responses, at DIFFERENT
          # cadences:
          #
          # (1) EARLY-DOOM HINT — EVERY confirming cycle. Reuse the deadline-overrun
          # COUNTER (stamp_deadline_overrun_hint, the SAME early-doom mechanism the
          # rc=124 wall-hit path uses) so the reaper escalates this job to DOOM after
          # GARDEN_REAP_OVERRUN_THRESHOLD (1) cycle instead of burning the full
          # GARDEN_REAP_DOOM_THRESHOLD (5) — exactly what happened to the four 1–2s
          # jobs in the 2026-07-03 batch, each of which emitted ONE advisory and then
          # burned all ~5 cycles. The counter must INCREMENT each confirming cycle to
          # reach the threshold, so this is deliberately NOT deduped (unlike the loud
          # kind:error at (2)). The marker is identical to the wall-hit path's — the
          # reaper knows only the one `garden-deadline-overrun` counter — but a distinct
          # commit reason keeps the git audit trail honest. Subshell-isolated (sync_clone
          # may offline-exit); best-effort — the reaper's full doom threshold still
          # backstops it on failure. Stamped alongside the reap-now hint already placed
          # above, so the reaper requeues promptly and the overrun count accrues.
          if ( stamp_deadline_overrun_hint "$CLONE" "$JOBS_DOIN/$base.md" "elapsed-constancy deterministic overrun" ); then
            log "elapsed-constancy for '$base': stamped the early-doom overrun counter (constant elapsed ${series_csv}s over $constancy_n cycles); reaper will doom after GARDEN_REAP_OVERRUN_THRESHOLD instead of the full doom threshold"
          else
            log "elapsed-constancy for '$base': could not stamp the early-doom overrun counter (rc=$?); falling back to the reaper's full doom threshold"
          fi
          # (2) LOUD kind:error — at most ONCE per base (dedup on $already), so a human
          # sees the diagnostic without a fresh inbox section on every confirming cycle.
          # Build a self-describing transcript; report-error.sh hashes it and appends the
          # inbox section. GARDEN_JOURNAL="$CLONE" mirrors the real-failure branch.
          if [ "$already" -eq 0 ]; then
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
              printf 'are excluded). Left in doin for the reaper (requeue ownership UNCHANGED),\n'
              printf 'with the early-doom overrun counter stamped so it surfaces after\n'
              printf 'GARDEN_REAP_OVERRUN_THRESHOLD cycles instead of the full %s. Triage the\n' "${GARDEN_REAP_DOOM_THRESHOLD:-5}"
              printf 'job spec / handler rather than waiting out the doom threshold.\n'
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
      # If this transient failure is part of a fleet-wide correlated outage (the shared
      # brake is now engaged), stamp the outage-cycle hint so the reaper PAUSES the doom
      # counter for this cycle: an environmental storm must never doom an otherwise-
      # healthy job (the 2026-07-01 dozen-job dooming; common.sh § outage-cycle hint).
      # Checked AFTER recording so this failure counts toward the density. Best-effort,
      # subshell-isolated. Rides alongside the reap-now/deadline-overrun hint stamped above.
      if fleet_brake_engaged; then
        if ( stamp_outage_cycle_hint "$CLONE" "$JOBS_DOIN/$base.md" ); then
          log "fleet brake ENGAGED at failure time for '$base'; stamped outage-cycle hint — reaper will PAUSE the doom counter this cycle (sustained environmental transient, not counted toward doom)"
        else
          log "could not stamp outage-cycle hint on '$base' (rc=$?); this cycle will count toward doom"
        fi
      fi
      idle_backoff "$fail_attempt"; fail_attempt=$((fail_attempt+1))
    else
      append_usage fail
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
      # When report-error.sh returns a SHA it has ALSO committed the capture as a
      # tracked file (inboxes/<host>/captures/<sha>), so the blob rides the normal
      # journal2 push and any responder resolves it after a plain fetch — no anchor
      # needed. Only when that escalation failed outright do we fall back to a bare
      # local hash, and then anchor it under refs/captures so an off-host responder
      # has *some* route (a ref an ordinary fetch does not retrieve, but one that
      # `git fetch origin refs/captures/*:refs/captures/*` can reach); best-effort.
      if [ -z "$sha" ]; then
        sha="$(capture_blob "$capture" "$CLONE" 2>/dev/null || echo unknown)"
        [ "$sha" = unknown ] || anchor_blob "$sha" "gardener/$id/$base" "$CLONE" 2>/dev/null || true
      fi
      printf 'gardener-%s on %s: job %s handler FAILED (rc=%s); output captured as %s, escalated to the gardener inbox, left in doin for the reaper\n' \
        "$id" "$GARDEN" "$base" "$rc" "$sha" \
        | GARDEN_ROLE=gardener "$HERE/journal-entry.sh" error || true

      # --- hermit capability probe (design hermit-failure-capability-demerit.md) --
      # A local/ollama (hermit) worker that DETERMINISTICALLY failed this job — a REAL
      # failure, the classifier above having already excluded external signal-kills,
      # wall-clock timeouts, environmental/offline rcs, and transient-claude blips — is
      # the signal the maintainer (2026-07-27) asked us to MEASURE: would a capable
      # reference model (claude/codex) have completed the same work? Fire a BOUNDED,
      # best-effort, once-per-base follow-up probe that re-attempts the work on a capable
      # model in an ISOLATED throwaway worktree (measurement-only: it never pushes, never
      # touches this job's board entry, never double-runs live work). On
      # capable-succeeds-where-hermit-failed it records a DEMERIT against the (local,
      # hermit, work-class) reputation arm, building the routing signal that local
      # inference is unfit for that job class. ONLY for the hermit kind — a capable
      # gardener's own real failure says nothing about local inference. Subshell-isolated
      # and internally time-bounded so it can never strand or wedge the loop; it skips
      # itself under the fleet brake (budget freeze). It runs INLINE on this just-failed
      # worker (which is about to idle-backoff anyway), so no orphan process escapes the
      # spine's supervision.
      if [ "$KIND" = hermit ] && [ "${GARDEN_HERMIT_PROBE:-1}" = 1 ]; then
        ( "$HERE/hermit-capability-probe.sh" "$base" "$jobfile" ) >>"$capture" 2>&1 \
          || log "hermit capability probe for '$base' returned non-zero (best-effort; ignored)"
      fi
    fi
  fi
  rm -f "$report" "$capture" "$completion_sentinel" "$usage_file"
done
