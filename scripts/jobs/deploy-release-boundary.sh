#!/bin/bash
# deploy-release-boundary.sh — establish a COHERENT-RELEASE BOUNDARY across the
# multi-file tree swap, closing the cross-file window the per-file rename leaves open.
#
# SOURCE this; do not execute it. It provides three functions used by the
# deliberate deploy (deploy-garden.sh):
#   freeze_timers            stop every active garden-*.timer so no timer-driven
#                            oneshot execs mid-swap and sources a mismatched
#                            common/helper version. Records the frozen set.
#   thaw_timers              restart the frozen timers onto the now-coherent release.
#   verify_coherent_release  confirm the restarted fleet + thawed timers are active,
#                            and the deployed sha is the new one — i.e. every unit
#                            runs from ONE release.
#
# WHY THIS EXISTS — the RESIDUAL after the per-file rename (deploy-tree-swap.sh).
# The per-file rename made each changed blob swap atomically, so an opener never
# sees a half-written or absent FILE. But a release is MANY files, and a process
# that execs mid-swap opens its entrypoint and then, microseconds later, `source`s
# common.sh (and further helpers) as SEPARATE open() calls. If the multi-file swap
# straddles those opens, the process runs a NEW entrypoint over an OLD common.sh
# (or the reverse) — a mismatched, incoherent release. A new entrypoint that calls
# a helper only the new common.sh defines dies `command not found`, rc=127: the
# SAME storm the per-file rename was meant to kill, now sourced ACROSS files instead
# of WITHIN one. Per-file rename gives per-INODE coherence; it cannot give
# cross-file (release-level) coherence on its own.
#
# THE BOUNDARY — freeze the timer-driven exec sources across the swap. The drain
# already quiesces the gardener fleet (no mid-job worker), but it does NOT touch the
# NON-gardener units: the ~40 garden-*.timer units (reaper, foreman, scheduler,
# watchman, issue-inbox, repo-watcher, the gardener-scaler that re-`enable --now`s an
# exited gardener, …) keep firing on their own cadence and are exactly the documented
# rc=127 vectors. Stopping every active garden timer for the (fast, per-file-rename)
# swap window means no timer-driven oneshot STARTS while the release is half-swapped,
# so every unit execs either the whole OLD release (before the boundary) or the whole
# NEW release (after it) — never a mix. A timer stop is instant (a timer only
# triggers execs; it holds no long idle sleep like a worker), so unlike the worker
# restart wave this costs no idle-poll window. After the swap the timers are thawed
# (restarted) onto the coherent new tree; the price is that a stopped-then-started
# timer's next elapse is pushed out by at most one interval — negligible for a
# deliberate, infrequent deploy, and far cheaper than a fleet-wide rc=127 storm.
#
# WHAT THE BOUNDARY DOES NOT COVER (documented residuals, both narrow):
#   * A long-running service that CRASH-restarts inside the swap window re-execs
#     mid-swap. The fleet is drained and idle, so this is vanishingly unlikely, and
#     the per-file rename still makes each file it reads whole (old-or-new).
#   * A triggered oneshot that STARTED just before the freeze and happens to
#     `source` common.sh during the swap. Its entrypoint fd is a stable inode; only
#     the later source() can race, and the window is the sub-second swap. Freezing
#     the timers removes the dominant vector (a NEW oneshot starting mid-swap); this
#     in-flight remainder is left to the per-file atomicity.
#
# RECOVERY — if the boundary cannot be established (a wedged user-manager makes a
# timer stop time out), the deploy does NOT wedge undeployable: by default it FALLS
# BACK to the plain per-file atomic swap (inode-safe, exactly today's behavior) with
# a loud WARN + a maintainer alert, so the deploy still proceeds. Set
# GARDEN_DEPLOY_REQUIRE_BOUNDARY=1 to make an un-establishable boundary ABORT the
# deploy instead (strict posture: never advance the tree with the timers live).
#
# Expects common.sh already sourced by the caller (log / unit_ctl / unit_ctl_bounded
# / worker_kinds / worker_kind_field).

# The frozen set, carried from freeze_timers to thaw_timers (and to the deploy's
# EXIT-trap belt, so an abort mid-swap still thaws what it stopped). thaw_timers
# clears it (so the trap belt cannot double-thaw) and preserves what it restarted in
# THAWED_TIMERS, which verify_coherent_release re-checks.
FROZEN_TIMERS=()
THAWED_TIMERS=()

# List the currently-active garden-*.timer instances, one per line (bare unit name).
# `list-units` (without --all) reports active units; the first field is the unit.
_active_garden_timers() {
  unit_ctl list-units 'garden-*.timer' --no-legend 2>/dev/null | awk '{print $1}'
}

# freeze_timers — stop every active garden timer so no timer-driven oneshot starts
# during the swap. Populates FROZEN_TIMERS with what it stopped (for thaw). Returns:
#   0  boundary established (every active timer's stop returned success)
#   1  boundary NOT fully established (a stop failed/timed out) — the caller takes
#      its recovery path; FROZEN_TIMERS still holds whatever WAS stopped, so thaw
#      restores them.
# A blocking (bounded) `stop` is used deliberately — its success means the timer is
# actually stopped before we touch a file, which is the boundary predicate. The
# bound is only a wedged-manager backstop; a real timer stop returns at once.
freeze_timers() {
  FROZEN_TIMERS=()
  local unit
  while read -r unit; do
    [ -n "$unit" ] || continue
    FROZEN_TIMERS+=("$unit")
  done < <(_active_garden_timers)

  if [ "${#FROZEN_TIMERS[@]}" -eq 0 ]; then
    log "release-boundary: no active garden timers to freeze (boundary trivially established)"
    return 0
  fi

  local failed=0 stopped=0
  for unit in "${FROZEN_TIMERS[@]}"; do
    if unit_ctl_bounded stop "$unit" >/dev/null 2>&1; then
      stopped=$((stopped+1))
    else
      log "release-boundary: WARN could not stop $unit (rc=$?); the coherent-release boundary is incomplete"
      failed=$((failed+1))
    fi
  done

  if [ "$failed" -ne 0 ]; then
    log "release-boundary: froze $stopped/${#FROZEN_TIMERS[@]} timer(s); $failed would not stop — boundary NOT established"
    return 1
  fi
  log "release-boundary: froze ${#FROZEN_TIMERS[@]} garden timer(s) for the swap window (coherent-release boundary established)"
  return 0
}

# thaw_timers — restart every timer freeze_timers stopped, onto the now-coherent new
# tree, and clear the frozen set. Idempotent: a timer enable-services already
# restarted is simply started again. Returns 0 when every thaw succeeded, non-zero
# otherwise (the caller decides whether a straggler matters — verify_coherent_release
# re-checks). Safe to call when nothing was frozen (a clean no-op).
thaw_timers() {
  local unit started=0 failed=0
  if [ "${#FROZEN_TIMERS[@]}" -eq 0 ]; then
    return 0
  fi
  THAWED_TIMERS=("${FROZEN_TIMERS[@]}")
  # Clear the frozen set FIRST so the EXIT-trap belt cannot re-enter thaw and double
  # a start (the round-trip is recorded in THAWED_TIMERS for verify).
  FROZEN_TIMERS=()
  for unit in "${THAWED_TIMERS[@]}"; do
    [ -n "$unit" ] || continue
    if unit_ctl_bounded start "$unit" >/dev/null 2>&1; then
      started=$((started+1))
    else
      log "release-boundary: WARN thaw (start) of $unit failed (rc=$?); a later reconcile tick retries it"
      failed=$((failed+1))
    fi
  done
  log "release-boundary: thawed timers onto the new release: started=$started failed=$failed"
  [ "$failed" -eq 0 ]
}

# List the long-running service units the deploy restarts onto the new release, one
# per line: every worker kind's active instances, the bulletin singleton, and the
# watcher instance pool. Mirrors restart_long_running_fleet's target set so the
# verify below checks exactly what was re-exec'd.
_long_running_service_units() {
  local wkind wunit_base unit pat
  for wkind in $(worker_kinds); do
    wunit_base="$(worker_kind_field "$wkind" unit)"   # garden-gardener@ / garden-cleric@
    while read -r unit; do
      [ -n "$unit" ] || continue
      printf '%s\n' "$unit"
    done < <(unit_ctl list-units "${wunit_base}*.service" --no-legend 2>/dev/null | awk '{print $1}')
  done
  for pat in 'garden-bulletin.service' 'garden-watcher@*.service'; do
    while read -r unit; do
      [ -n "$unit" ] || continue
      printf '%s\n' "$unit"
    done < <(unit_ctl list-units "$pat" --no-legend 2>/dev/null | awk '{print $1}')
  done
}

# verify_coherent_release <expected_sha> — after the swap + record + reconcile +
# restart + thaw, confirm every unit runs from ONE release:
#   * the recorded deployed sha equals the new sha (the swap advanced exactly once),
#   * every long-running service the restart re-exec'd is active,
#   * every thawed timer is active again.
# Returns 0 when the fleet is coherent; non-zero (with a loud, itemized WARN) when a
# unit failed to come back. The tree is already advanced, so a failure here is an
# ALERT, never a clobber: a later scaler/reconcile tick restarts the stragglers. The
# caller surfaces it but does not roll back.
verify_coherent_release() {  # <expected_sha> [<deployed-sha-marker-value>]
  local expected="${1:?expected_sha}" recorded="${2:-}" unit down=0 total=0
  local -a stragglers=()

  if [ -n "$recorded" ] && [ "$recorded" != "$expected" ]; then
    log "release-boundary: VERIFY WARN recorded deployed sha ($recorded) != new sha ($expected)"
    stragglers+=("deployed-sha:$recorded")
  fi

  while read -r unit; do
    [ -n "$unit" ] || continue
    total=$((total+1))
    if ! unit_ctl is-active "$unit" >/dev/null 2>&1; then
      stragglers+=("$unit"); down=$((down+1))
    fi
  done < <({ _long_running_service_units; printf '%s\n' "${THAWED_TIMERS[@]:-}"; })

  if [ "${#stragglers[@]}" -gt 0 ]; then
    log "release-boundary: VERIFY WARN $down of $total unit(s) NOT active after the deploy: ${stragglers[*]}"
    log "release-boundary:   the tree is advanced to $expected; a later scaler/reconcile tick restarts the stragglers."
    return 1
  fi
  log "release-boundary: verified coherent release — deployed=$expected, all $total restarted/thawed unit(s) active"
  return 0
}
