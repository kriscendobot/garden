#!/bin/bash
# deploy-garden.sh — the deliberate, drained deploy of the root checkout.
#
# Usage: deploy-garden.sh
#
# The root checkout (`$GARDEN_ROOT`) is a DEPLOYED version of the garden, NOT a
# development tree. It is advanced ONLY by this script — never by a continuous
# fast-forward (the retired garden-deploy-sync and the watchman's old aggressive
# checkout). Development happens in per-subagent worktrees off the dev branch
# (origin/$GARDEN_MAIN_BRANCH); this script merges that accumulated development
# into the root in one deliberate, drained pass. See designs/deliberate-deploy.md.
#
# The pass is deterministic (no LLM) and ordered:
#   0. CANDIDATE GATE. Fetch the candidate and, before engaging the drain or
#               swapping any live path, run the fast deterministic tier from an
#               unpacked candidate tree: `bash -n` for every tracked
#               `scripts/**/*.sh`, then the handler-classifier regression suites.
#               This is intentionally a fast tier rather than all 136 job suites:
#               the full suite is too slow and variable for a deliberate deploy
#               window. Per-suite and total bounds keep this gate from becoming a
#               fleet outage; a failed or timed-out suite aborts by default,
#               writes a kind:error journal entry, and alerts the maintainer.
#               Set GARDEN_DEPLOY_TEST_OVERRIDE=1 only for a deliberate emergency
#               deploy; that exceptional bypass is logged loudly.
#   1. DEFER CHECK. Before engaging the drain, sample the fleet's busy markers. A
#               single gardener running a job longer than the drain budget (the
#               ymax0 chain-state repros, the scholar LangChain/LangGraph ingests)
#               can never quiesce within GARDEN_DEPLOY_DRAIN_TIMEOUT. Engaging the
#               drain on such a doomed attempt would pause the WHOLE fleet (no new
#               claims) for the full budget before aborting, and since the
#               Upgrade-ready signal persists, the next trigger would repeat that
#               fleet-pause. So if a busy gardener has already been mid-job longer
#               than GARDEN_DEPLOY_LONG_JOB_THRESHOLD, DEFER without ever engaging
#               the drain (exit 0, fleet untouched) and let a later trigger retry
#               once the long job finishes. This trades a possibly-later deploy for
#               never pausing the fleet on a doomed attempt (the safe option-1
#               posture: a long job blocks the deploy regardless — half-old/half-new
#               code is never allowed — so the only choice is whether to pause the
#               fleet while it blocks; we choose not to).
#   2. DRAIN.   Engage the draining marker so gardeners finish their in-flight
#               claim and take no new ones, then wait for the host to QUIESCE — no
#               gardener busy marker remains ($GARDEN_STATE/gardeners/*/busy, the
#               same host-local mid-job signal deploy-sync used). Bounded by
#               GARDEN_DEPLOY_DRAIN_TIMEOUT; on timeout the deploy aborts and (if
#               it engaged the drain) lifts it, so a stuck job never strands the
#               fleet drained. The same long-job check runs each poll while we
#               wait: if a gardener we engaged the drain over crosses the threshold
#               mid-drain, we lift the drain and defer rather than burn the rest of
#               the budget paused.
#   3. MERGE.   Advance the root tree to origin/$GARDEN_MAIN_BRANCH as a strict
#               fast-forward, but ATOMICALLY per file (atomic_advance_tree in
#               deploy-tree-swap.sh) rather than by an in-place `git merge`.
#               Because development no longer happens in the root tree, the tree is
#               clean and the ff never wedges; the ancestry/dirty checks below still
#               refuse a diverged or hand-edited root (the no-shared-tree invariant).
#               The atomic per-file swap (stage each new blob as a sibling temp,
#               rename it into place) closes the exec window a plain `git merge`
#               opened — git rewrites a modified file by unlink+create, so a unit
#               that execs mid-merge sees a half-written or absent script and dies
#               rc=127 (the recurring storm). rename(2) is atomic within a
#               filesystem: an opener sees the whole old or whole new file, never a
#               partial one — so NO unit is stopped or masked and no singleton tick
#               is dropped.
#   4. RECORD + LIFT + RESTART. Record the new HEAD as the deployed sha, lift the
#               drain, then restart the long-running services and the gardener
#               fleet so they re-exec onto the new code. Lifting the drain BEFORE
#               the restart is safe: the drained gardeners have already exited, so
#               nothing runs on the old code; the restarted units come up live on
#               the new code and resume claiming.
#
# State: the deployed sha is recorded in $GARDEN_DEPLOYED_SHA_MARKER (host
# standing state, not committed to the dev branch). The upgrade monitor compares
# origin/$GARDEN_MAIN_BRANCH against it.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
# shellcheck source=deploy-restart.sh
source "$HERE/deploy-restart.sh"
# shellcheck source=deploy-tree-swap.sh
source "$HERE/deploy-tree-swap.sh"
# shellcheck source=deploy-release-boundary.sh
source "$HERE/deploy-release-boundary.sh"
GARDEN_TAG="deploy-garden"

: "${GARDEN_DEPLOY_DRAIN_TIMEOUT:=600}"   # seconds to wait for the fleet to quiesce
: "${GARDEN_DEPLOY_POLL:=5}"              # seconds between quiesce polls
: "${GARDEN_DEPLOY_NO_BROADCAST:=0}"      # set 1 to skip the post-deploy reread broadcast (tests)
: "${GARDEN_DEPLOY_TEST_OVERRIDE:=0}"     # set 1 only for a deliberate emergency bypass
: "${GARDEN_DEPLOY_TEST_SUITE_TIMEOUT:=60}" # max seconds for one candidate test suite
: "${GARDEN_DEPLOY_TEST_TOTAL_TIMEOUT:=300}" # max seconds for the whole candidate gate
: "${GARDEN_DEPLOY_REPORT_TIMEOUT:=30}"      # max seconds per failure-report sink
# The two bounded classifier regressions directly protect the failure-reporting
# helpers that previously let a deleted common.sh helper reach every host unnoticed.
# The other classifier integrations deliberately exercise multi-minute reaper
# timing, so they belong to the full suite rather than this deploy-window tier.
# Keep the narrowing explicit; a test-only override lets deploy-garden-test.sh
# supply its tiny hermetic probe without weakening the production default.
: "${GARDEN_DEPLOY_TEST_SUITES:=scripts/jobs/test/empty-output-classifier-test.sh scripts/jobs/test/signal-kill-classifier-test.sh}"
# A gardener already mid-job longer than this (its busy marker's age) is treated as
# a long job that would not quiesce within the drain budget: the deploy DEFERS
# rather than pause the fleet over it. Default is half the drain timeout — long
# enough that ordinary jobs drain normally, short enough that the doomed-attempt
# fleet-pause is never engaged. Keep it < GARDEN_DEPLOY_DRAIN_TIMEOUT.
: "${GARDEN_DEPLOY_LONG_JOB_THRESHOLD:=300}"
# When the coherent-release boundary cannot be established (a wedged user-manager
# makes a timer stop time out), the default recovery is to FALL BACK to the plain
# per-file atomic swap (inode-safe, exactly the pre-boundary behavior) with a loud
# WARN + a maintainer alert, so a deploy is never wedged undeployable. Set this to 1
# for the strict posture: abort the deploy rather than advance the tree with the
# timers still live. See deploy-release-boundary.sh § RECOVERY.
: "${GARDEN_DEPLOY_REQUIRE_BOUNDARY:=0}"

# Exit status for a deliberate deferral (a long mid-job gardener; the fleet was
# never paused). Distinct from the abort path (exit 1) and from a real deploy:
# it is NOT a failure — the Upgrade-ready signal persists and a later trigger
# retries — so, like the no-op deploy, it exits 0. The DEFERRED log line is the
# machine- and human-readable marker that this run advanced nothing on purpose.
GARDEN_DEPLOY_DEFER_RC=0

# Did THIS run engage the drain? Used to decide whether an abort should lift it.
# (If an operator pre-drained for maintenance, an aborted deploy must not resume
# their fleet.) A SUCCESSFUL deploy always ends with the fleet running, so it
# lifts the drain regardless — running on the new code is the point of a deploy.
we_drained=0

lift_drain_if_we_engaged() {
  [ "$we_drained" = "1" ] || return 0
  we_drained=0
  "$HERE/drain-fleet.sh" off >/dev/null 2>&1 || true
  log "drain lifted (deploy aborted; restored pre-deploy run state)"
}

# Belt for an abort AFTER the timers were frozen (the coherent-release boundary was
# engaged) but before the deploy thawed them on its success path — an rc-2 half-swap,
# a signal, any unguarded death. Restart whatever freeze_timers stopped so a crashed
# deploy never strands the garden timers off. On the success path thaw_timers already
# ran (FROZEN_TIMERS is empty), so this no-ops.
thaw_timers_if_frozen() {
  [ "${#FROZEN_TIMERS[@]}" -gt 0 ] || return 0
  thaw_timers >/dev/null 2>&1 || true
  log "timers thawed (deploy aborted after the release boundary was engaged)"
}

deploy_exit_cleanup() { thaw_timers_if_frozen; lift_drain_if_we_engaged; }

report_candidate_gate_failure() { # <candidate-sha> <failed-suite>...
  local candidate="$1"; shift
  local failed joined body
  joined="$(printf '%s, ' "$@")"; joined="${joined%, }"
  body="kind: error

# Deploy candidate test gate rejected main2

candidate: \`$candidate\`
failing suites: $joined

The deployed tree was left in place. Set \`GARDEN_DEPLOY_TEST_OVERRIDE=1\` only
for a deliberate emergency deploy after assessing this failure."
  # Both sinks are deliberately best-effort: inability to reach the journal must
  # never turn a rejected candidate into a deploy. The local log remains loud.
  if printf '%s\n' "$body" | timeout "$GARDEN_DEPLOY_REPORT_TIMEOUT" env GARDEN_SKIP_REF_CHECK=1 GARDEN_SENDER=deploy-garden "$HERE/inbox-send.sh" maintainer >/dev/null 2>&1; then
    log "reported candidate gate kind:error to maintainer inbox"
  else
    log "WARN: could not report candidate gate failure to maintainer inbox"
  fi
  if printf '%s\n' "$body" | timeout "$GARDEN_DEPLOY_REPORT_TIMEOUT" env GARDEN_ROLE=deploy-garden "$HERE/journal-entry.sh" error >/dev/null 2>&1; then
    log "emitted candidate gate kind:error journal entry"
  else
    log "WARN: could not emit candidate gate kind:error journal entry"
  fi
}

report_boundary_not_established() { # <candidate-sha> <mode: fallback|abort>
  local candidate="$1" mode="$2" body
  body="kind: error

# Deploy could not establish the coherent-release boundary

candidate: \`$candidate\`
outcome: $mode

The garden timers could not all be stopped for the swap window (a wedged
user-manager?), so the deploy could not guarantee a cross-file coherent release.
In \`fallback\` mode the tree was still advanced with the inode-safe per-file swap
(pre-boundary behavior); in \`abort\` mode nothing was advanced. Investigate the
user manager, then re-run the deploy."
  # Best-effort, like the candidate-gate reporter: an unreachable journal must never
  # change the deploy outcome.
  if printf '%s\n' "$body" | timeout "$GARDEN_DEPLOY_REPORT_TIMEOUT" env GARDEN_SKIP_REF_CHECK=1 GARDEN_SENDER=deploy-garden "$HERE/inbox-send.sh" maintainer >/dev/null 2>&1; then
    log "reported boundary-not-established kind:error to maintainer inbox"
  else
    log "WARN: could not report boundary-not-established to maintainer inbox"
  fi
  if printf '%s\n' "$body" | timeout "$GARDEN_DEPLOY_REPORT_TIMEOUT" env GARDEN_ROLE=deploy-garden "$HERE/journal-entry.sh" error >/dev/null 2>&1; then
    log "emitted boundary-not-established kind:error journal entry"
  else
    log "WARN: could not emit boundary-not-established kind:error journal entry"
  fi
}

run_candidate_gate() { # <candidate-sha>
  local candidate="$1" gate_root suite path rc now deadline remaining limit
  local -a failed=()
  [ "$GARDEN_DEPLOY_TEST_OVERRIDE" = "1" ] && {
    log "WARN: GARDEN_DEPLOY_TEST_OVERRIDE=1 — bypassing candidate test gate for $candidate"
    return 0
  }
  case "$GARDEN_DEPLOY_TEST_SUITE_TIMEOUT:$GARDEN_DEPLOY_TEST_TOTAL_TIMEOUT" in
    *[!0-9:]*|0:*|*:0) log "FATAL: candidate gate timeouts must be positive integers"; return 1 ;;
  esac
  gate_root="$(mktemp -d "${TMPDIR:-/tmp}/garden-deploy-gate.XXXXXXXX")" || {
    log "FATAL: could not create candidate gate directory"; return 1;
  }
  # archive, rather than the live worktree, is the crucial candidate-tree
  # boundary: a new helper or a changed common.sh is what the suites exercise.
  if ! git -C "$GARDEN_ROOT" archive "$candidate" | tar -x -C "$gate_root"; then
    rm -rf "$gate_root"
    log "FATAL: could not unpack candidate $candidate for its test gate"
    return 1
  fi
  deadline=$(( $(date +%s) + GARDEN_DEPLOY_TEST_TOTAL_TIMEOUT ))
  while IFS= read -r -d '' path; do
    now="$(date +%s)"
    if [ "$now" -ge "$deadline" ]; then failed+=("total-wall-clock"); break; fi
    if ! bash -n "$gate_root/$path"; then failed+=("bash-n:$path"); fi
  done < <(git -C "$GARDEN_ROOT" ls-tree -r -z --name-only "$candidate" -- scripts | while IFS= read -r -d '' path; do case "$path" in *.sh) printf '%s\0' "$path";; esac; done)
  if [ "${#failed[@]}" -eq 0 ]; then
    for suite in $GARDEN_DEPLOY_TEST_SUITES; do
      now="$(date +%s)"
      if [ "$now" -ge "$deadline" ]; then failed+=("total-wall-clock"); break; fi
      if [ ! -f "$gate_root/$suite" ]; then failed+=("missing:$suite"); continue; fi
      remaining=$(( deadline - now )); limit="$GARDEN_DEPLOY_TEST_SUITE_TIMEOUT"
      [ "$remaining" -lt "$limit" ] && limit="$remaining"
      timeout --kill-after=5 "$limit" env GARDEN_TEST=1 bash "$gate_root/$suite" >/dev/null 2>&1 || {
        rc=$?; failed+=("$suite(rc=$rc)")
      }
    done
  fi
  rm -rf "$gate_root"
  if [ "${#failed[@]}" -gt 0 ]; then
    log "ERROR: candidate test gate rejected $candidate; failing suites: ${failed[*]}"
    report_candidate_gate_failure "$candidate" "${failed[@]}"
    return 1
  fi
  log "candidate test gate passed for $candidate (bash -n + ${GARDEN_DEPLOY_TEST_SUITES})"
}

# BELT for the UNANTICIPATED abort: every foreseen failure path below calls
# lift_drain_if_we_engaged explicitly, but this script runs under `set -e` with
# many unguarded commands between drain-engage and drain-lift (rev-parses, the
# marker write inside record_deployed_sha, subprocess hangs killed by a signal).
# Any of those dying used to strand the WHOLE host drained indefinitely — and a
# retriggered deploy then read the orphaned marker as operator-engaged
# (we_drained=0) and deliberately refused to lift it on ITS abort, so one crash
# plus one aborted retry parked the fleet until a human intervened (the
# 2026-07-05 nohup'd-deploy SIGTERM orphaned exactly this way). The trap makes
# the lift unconditional on ANY exit: on success the drain is already lifted
# and we_drained reset, so it no-ops; an operator-engaged drain (we_drained=0)
# is never touched. TERM/INT exit through the EXIT trap via the explicit exit.
trap 'deploy_exit_cleanup' EXIT
trap 'exit 143' TERM
trap 'exit 130' INT

# Is this host's gardener <id> actually a live systemd unit? A busy marker whose
# unit is INACTIVE is STALE — a worker killed mid-job during an outage, or an id
# above the current pool size after a downsize — and no live process will ever
# clear it. Honoring such a marker would DEFER the deploy forever (the real
# incident: gardeners/55/busy, an empty file 28h old with garden-gardener@55
# inactive after the pool was sized to 20, blocked two deploys until an operator
# removed it by hand). Routed through unit_ctl so GARDEN_UNIT_CTL stubs it in the
# tests exactly like the rest of the deploy's unit control.
worker_unit_active() {  # <kind> <id> -> exit 0 if the unit is active, non-zero otherwise
  local unit_base; unit_base="$(worker_kind_field "$1" unit)"
  unit_ctl is-active "${unit_base}$2.service" >/dev/null 2>&1
}

# Sweep a stale busy marker (its worker unit is inactive) and LOG what was removed
# (kind + id + marker age) so it stays diagnosable — never a silent skip. The marker
# path is derived from the kind's own namespace via the shared helper.
sweep_stale_busy() {  # <kind> <id> <age-seconds>
  rm -f "$(worker_busy_marker "$1" "$2")" 2>/dev/null || true
  log "swept STALE busy marker: $1 $2 (unit inactive, marker age ${3}s) — not counted as busy/long-job"
}

# Count this host's mid-job workers ACROSS EVERY KIND by their busy markers. Zero =
# quiesced. A marker whose worker unit is inactive is STALE: it is swept (and
# logged), not counted — otherwise a leftover marker would block quiesce forever.
# The deploy must wait for a mid-job cleric exactly as for a mid-job gardener, so
# this enumerates both kinds' marker namespaces via the registry (design §1.2).
busy_count() {
  local n=0 m idx now mtime age kind ns
  now="$(date +%s)"
  for kind in $(worker_kinds); do
    ns="$(worker_kind_field "$kind" state_ns)"
    for m in "$GARDEN_STATE/$ns"/*/busy; do
      [ -e "$m" ] || continue
      idx="${m%/busy}"; idx="${idx##*/}"
      if ! worker_unit_active "$kind" "$idx"; then
        mtime="$(stat -c %Y "$m" 2>/dev/null || echo "$now")"
        age=$(( now - mtime ))
        sweep_stale_busy "$kind" "$idx" "$age"
        continue
      fi
      n=$((n+1))
    done
  done
  printf '%s\n' "$n"
}

# Echo "<age-seconds> <kind> <idx>" for the worker (any kind) that has been mid-job
# the LONGEST, or "0 - -" when the fleet is idle. A busy marker's mtime is set when
# the worker starts its current job (gardener.sh re-creates it just before invoking
# the handler and clears it at the next between-claims point), so the marker's age is
# exactly how long that worker has been on its current job — the signal that
# distinguishes a long job from a short one without any LLM or job introspection. The
# kind is a separate field so a caller logs "gardener 1" / "cleric 3" naturally.
oldest_busy() {
  local now m mtime age idx oldest=0 oldest_kind="-" oldest_idx="-" kind ns
  now="$(date +%s)"
  for kind in $(worker_kinds); do
    ns="$(worker_kind_field "$kind" state_ns)"
    for m in "$GARDEN_STATE/$ns"/*/busy; do
      [ -e "$m" ] || continue
      idx="${m%/busy}"; idx="${idx##*/}"
      mtime="$(stat -c %Y "$m" 2>/dev/null || echo "$now")"
      age=$(( now - mtime ))
      # A STALE marker (inactive unit) never counts toward the long-job age; sweep
      # it and move on so a leftover marker can never defer the deploy forever.
      if ! worker_unit_active "$kind" "$idx"; then
        sweep_stale_busy "$kind" "$idx" "$age"
        continue
      fi
      if [ "$age" -ge "$oldest" ]; then
        oldest="$age"
        oldest_kind="$kind"
        oldest_idx="$idx"
      fi
    done
  done
  printf '%s %s %s\n' "$oldest" "$oldest_kind" "$oldest_idx"
}

# --- 0. CANDIDATE FETCH + TEST GATE ------------------------------------------

# Fetch before any drain: a bad candidate must not pause the fleet merely to learn
# that its own deterministic regression suites fail. The candidate is unpacked and
# tested above, never overlaid on the deployed root.
git -C "$GARDEN_ROOT" fetch -q origin "$GARDEN_MAIN_BRANCH" 2>/dev/null \
  || { log "WARN: fetch of origin/$GARDEN_MAIN_BRANCH failed (offline?); aborting deploy"; exit 1; }
candidate_sha="$(git -C "$GARDEN_ROOT" rev-parse --verify --quiet "origin/$GARDEN_MAIN_BRANCH" || true)"
[ -n "$candidate_sha" ] || { log "FATAL: cannot resolve fetched origin/$GARDEN_MAIN_BRANCH"; exit 1; }
run_candidate_gate "$candidate_sha" || {
  log "ABORTED: candidate test gate failed; root tree remains unchanged"
  exit 1
}

# --- 1. DEFER CHECK ----------------------------------------------------------
#
# Decide whether to engage the drain at all. If a gardener has ALREADY been mid-job
# longer than the long-job threshold, it will not quiesce within the drain budget;
# engaging the drain would only pause the whole fleet for the full budget before
# aborting, and the next trigger would repeat that pause. Defer instead — without
# ever pausing the fleet. Skipped when an operator pre-drained (the fleet is already
# paused by their explicit choice; deferring here would not un-pause it, and they
# asked to deploy — let the original timeout/abort semantics stand).
if ! fleet_draining; then
  read -r busy_age busy_kind busy_idx < <(oldest_busy)
  if [ "$busy_age" -ge "$GARDEN_DEPLOY_LONG_JOB_THRESHOLD" ]; then
    log "DEFERRED: $busy_kind $busy_idx has been mid-job ${busy_age}s (>= ${GARDEN_DEPLOY_LONG_JOB_THRESHOLD}s long-job threshold)."
    log "  Not engaging the drain — the fleet keeps claiming, never paused on this doomed attempt. The Upgrade-ready"
    log "  signal persists; a later trigger retries once the long job finishes. Nothing was advanced."
    exit "$GARDEN_DEPLOY_DEFER_RC"
  fi
fi

# --- 2. DRAIN ----------------------------------------------------------------

if fleet_draining; then
  log "fleet already draining (operator-engaged); proceeding to quiesce without lifting on abort"
else
  "$HERE/drain-fleet.sh" on "deploy-garden: deliberate deploy in progress" >/dev/null 2>&1 \
    || die "could not engage the draining marker"
  we_drained=1
  log "drain engaged; waiting for the fleet to quiesce (timeout ${GARDEN_DEPLOY_DRAIN_TIMEOUT}s)"
fi

deadline=$(( $(date +%s) + GARDEN_DEPLOY_DRAIN_TIMEOUT ))
while :; do
  n="$(busy_count)"
  if [ "$n" -eq 0 ]; then
    log "fleet quiesced (no mid-job gardeners)"
    break
  fi
  # A gardener we engaged the drain over may grow into a long job while we wait
  # (it was under the threshold at the defer check, then crossed it). Rather than
  # hold the fleet paused for the rest of the budget, lift the drain and defer the
  # moment it crosses. Only when WE engaged the drain — if an operator pre-drained,
  # honor their explicit drain to the full timeout (we don't second-guess it).
  if [ "$we_drained" = "1" ]; then
    read -r busy_age busy_kind busy_idx < <(oldest_busy)
    if [ "$busy_age" -ge "$GARDEN_DEPLOY_LONG_JOB_THRESHOLD" ]; then
      log "DEFERRED: $busy_kind $busy_idx crossed the ${GARDEN_DEPLOY_LONG_JOB_THRESHOLD}s long-job threshold mid-drain (busy ${busy_age}s)."
      log "  Lifting the drain so the fleet resumes; the Upgrade-ready signal persists and a later trigger retries."
      lift_drain_if_we_engaged
      exit "$GARDEN_DEPLOY_DEFER_RC"
    fi
  fi
  if [ "$(date +%s)" -ge "$deadline" ]; then
    log "WARN: quiesce timed out after ${GARDEN_DEPLOY_DRAIN_TIMEOUT}s with $n mid-job gardener(s); aborting deploy"
    lift_drain_if_we_engaged
    exit 1
  fi
  log "waiting for $n mid-job gardener(s) to finish..."
  sleep "$GARDEN_DEPLOY_POLL"
done

# --- 3. MERGE ----------------------------------------------------------------

old_sha="$(git -C "$GARDEN_ROOT" rev-parse --verify --quiet HEAD || true)"
[ -n "$old_sha" ] || { log "FATAL: cannot resolve HEAD in $GARDEN_ROOT"; lift_drain_if_we_engaged; exit 1; }
up_sha="$candidate_sha"

if [ "$up_sha" = "$old_sha" ]; then
  log "root already at origin/$GARDEN_MAIN_BRANCH ($old_sha); nothing to deploy"
  record_deployed_sha "$old_sha"
  # A no-op deploy still lifts the drain it engaged (the fleet should resume).
  [ "$we_drained" = "1" ] && { "$HERE/drain-fleet.sh" off >/dev/null 2>&1 || true; we_drained=0; log "drain lifted (no-op deploy)"; }
  exit 0
fi

# Diverged? The root has a commit not on origin — the no-shared-tree invariant was
# violated (something edited the root). Never clobber; abort and surface it.
if ! git -C "$GARDEN_ROOT" merge-base --is-ancestor "$old_sha" "$up_sha" 2>/dev/null; then
  log "WARN: root has DIVERGED from origin/$GARDEN_MAIN_BRANCH ($old_sha vs $up_sha); not a fast-forward."
  log "  The no-shared-tree invariant was violated — the root carries a local commit. Resolve by hand; aborting deploy."
  lift_drain_if_we_engaged
  exit 1
fi

# Tracked working-tree changes mean someone developed in the root (invariant
# violation) or a half-finished operation. Never clobber; abort.
dirty_tracked="$(git -C "$GARDEN_ROOT" status --porcelain --untracked-files=no 2>/dev/null)"
if [ -n "$dirty_tracked" ]; then
  log "WARN: root worktree has TRACKED changes; the no-shared-tree invariant was violated. Aborting deploy (never clobber)."
  log "  blocking paths: $(printf '%s' "$dirty_tracked" | tr '\n' ';')"
  lift_drain_if_we_engaged
  exit 1
fi

# Establish the COHERENT-RELEASE BOUNDARY for the swap window. The per-file rename
# below protects each script INODE, but a release is many files: a unit that execs
# mid-swap can run a NEW entrypoint over an OLD common.sh (or the reverse) and die
# rc=127 on a helper that only one release defines — the storm sourced ACROSS files
# rather than within one. Freezing every active garden timer means no timer-driven
# oneshot (reaper, foreman, scheduler, watchman, the gardener-scaler, …) STARTS
# while the tree is half-swapped, so every unit execs a whole old-or-new release,
# never a mix. The drain already quiesced the gardener fleet; this extends the
# boundary to the NON-gardener timers/services the drain does not touch. See
# deploy-release-boundary.sh. If the boundary cannot be established (a wedged
# manager), recover: fall back to the inode-safe per-file swap (default), or abort
# under GARDEN_DEPLOY_REQUIRE_BOUNDARY=1.
if freeze_timers; then
  log "coherent-release boundary engaged for the swap"
else
  if [ "$GARDEN_DEPLOY_REQUIRE_BOUNDARY" = "1" ]; then
    log "FATAL: coherent-release boundary could not be established and GARDEN_DEPLOY_REQUIRE_BOUNDARY=1; aborting before touching the tree."
    report_boundary_not_established "$up_sha" abort
    # thaw_timers_if_frozen (EXIT trap) restarts whatever WAS stopped; drain lifts too.
    exit 1
  fi
  log "WARN: coherent-release boundary NOT established; recovering by the inode-safe per-file swap (the cross-file window remains, exactly the pre-boundary behavior)."
  report_boundary_not_established "$up_sha" fallback
fi

# Advance the working tree ATOMICALLY per file (rename each staged blob into
# place) so a unit exec'ing a script mid-swap never sees a half-written or absent
# file. rc 1 = aborted before touching any live path (tree untouched, safe to lift
# and retry); rc 2 = failed part-way (half-advanced) — surface it and abort; the
# next deploy's dirty/divergence check refuses to advance over the half-state.
# `|| ff_rc=$?` (not `; ff_rc=$?`) so `set -e` does not abort on the non-zero
# return before we can branch on it, and the exact code (1 vs 2) is preserved.
ff_rc=0
atomic_advance_tree "$GARDEN_ROOT" "$old_sha" "$up_sha" || ff_rc=$?
if [ "$ff_rc" -eq 1 ]; then
  log "WARN: atomic tree advance to origin/$GARDEN_MAIN_BRANCH aborted before touching the root (no files changed); aborting deploy."
  lift_drain_if_we_engaged
  exit 1
elif [ "$ff_rc" -eq 2 ]; then
  log "FATAL: atomic tree advance FAILED PART-WAY — the root is half-advanced. Not lifting blindly; resolve by hand."
  log "  Inspect 'git -C $GARDEN_ROOT status' in the root; the next deploy's dirty/divergence check will refuse to advance until it is clean."
  lift_drain_if_we_engaged
  exit 1
fi
new_sha="$(git -C "$GARDEN_ROOT" rev-parse --verify HEAD)"
log "advanced the root tree atomically (per-file rename): $old_sha -> $new_sha"

# --- 4. RECORD + LIFT + RESTART ----------------------------------------------

record_deployed_sha "$new_sha"
log "recorded deployed sha: $new_sha"

# Reconcile systemd units to the freshly-deployed tree. A deploy can LAND a unit
# retirement (a unit removed from scripts/systemd/ and added to install-units'
# RETIRED_UNITS) or ADD a new intended unit, but advancing the tree does not by
# itself disable a retired unit or enable a new one — the unit set lives in
# systemd, not the tree. Without this step a retirement landed by a deploy stays
# enabled+active on the host and fires its (now-missing) script every timer tick
# (garden-deploy-sync's rc-127 loop, 2026-06-27). `install` re-renders the
# current unit set; `enable-services` enables every intended unit and
# disables+removes every RETIRED_UNITS unit.
"$HERE/install-units.sh" install >/dev/null 2>&1 \
  || log "WARN: unit render during reconcile failed (continuing)"
if "$HERE/install-units.sh" enable-services >/dev/null 2>&1; then
  log "reconciled systemd units to the deployed tree (enabled intended, retired stale)"
else
  log "WARN: enable-services reconcile failed; check for stale/retired units by hand"
fi

# THAW the frozen timers onto the now-coherent new tree, closing the boundary. Done
# after the tree advanced + units reconciled, so a timer's next firing reads the new
# release. (enable-services above re-`start`s the standalone intended timers; thaw
# also covers the @-instance timers that enable-services leaves to their arming
# path.) On the success path this clears FROZEN_TIMERS so the EXIT-trap belt no-ops.
thaw_timers || log "WARN: not every frozen timer thawed cleanly; a later reconcile tick retries the stragglers"

# Lift the drain BEFORE restarting so the restarted units come up live (the
# drained gardeners have already exited; nothing runs on the old code).
"$HERE/drain-fleet.sh" off >/dev/null 2>&1 || log "WARN: could not lift the draining marker"
we_drained=0   # lifted on the success path; the abort-belt EXIT trap must no-op now
log "drain lifted; fleet may resume"

# Restart the long-running fleet onto the new code (busy-gate off: we quiesced).
restart_long_running_fleet "$old_sha" "$new_sha" 0

# VERIFY the fleet runs from ONE release: the recorded deployed sha is the new sha,
# every restarted long-running service is active, and every thawed timer is active.
# A straggler is an ALERT (a later scaler/reconcile tick restarts it), not a clobber
# — the tree is already advanced — so a verify miss is surfaced, never rolled back.
if ! verify_coherent_release "$new_sha" "$(cat "$GARDEN_DEPLOYED_SHA_MARKER" 2>/dev/null || true)"; then
  log "WARN: coherent-release verification found stragglers (see above); the deploy advanced the tree but a unit did not come back — a later reconcile tick retries it."
fi

# Best-effort post-deploy reread broadcast (the watchman also broadcasts on the
# tree change; this makes the deploy itself announce). Guardable for tests.
if [ "$GARDEN_DEPLOY_NO_BROADCAST" != "1" ]; then
  printf '%s deployed to %s — reread your role and skills as needed.\n' "$GARDEN_MAIN_BRANCH" "$new_sha" \
    | GARDEN_SKIP_REF_CHECK=1 GARDEN_SENDER=deploy-garden "$HERE/send-msg.sh" broadcast >/dev/null 2>&1 \
    || log "post-deploy broadcast skipped (no journal?)"
fi

log "deploy complete: root now at $new_sha"
