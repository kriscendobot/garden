#!/bin/bash
# deploy-restart.sh — re-exec the long-running fleet onto landed script changes.
#
# SOURCE this; do not execute it. It provides one function,
# restart_long_running_fleet, shared by the deliberate deploy (deploy-garden.sh).
# It was extracted from the retired deploy-sync.sh so the "which units hold stale
# code in a live process, and how to restart them safely" knowledge lives in ONE
# place. See designs/deliberate-deploy.md § Retiring the continuous fast-forward.
#
# Why a restart is needed at all: the garden's long-lived `garden-*` units run
# scripts straight from the checkout by absolute path. A timer-driven *oneshot*
# (reaper, foreman, scheduler, watchman) re-reads its script from disk on its NEXT
# firing, so advancing the tree is all it needs. But a *long-running* service
# (garden-gardener@N, garden-bulletin, garden-watcher@) parsed its
# script — and `source`d common.sh — once at start and holds them in memory for
# the life of the process; it picks up new code ONLY on a fresh exec. So after the
# tree advances, the long-running services must be restarted to re-exec.
#
# Expects common.sh already sourced by the caller (for log / unit_ctl /
# GARDEN_ROOT / GARDEN_STATE / fleet_draining).

# List the currently-active instances of a unit (glob) pattern, one unit per line.
# `list-units` (without --all) reports active units; the first field is the unit.
_restart_active_units() {
  unit_ctl list-units "$1" --no-legend 2>/dev/null | awk '{print $1}'
}

# restart_long_running_fleet <old_sha> <new_sha> [<gardener-busy-gate:1|0>]
#
# Compare <old_sha>..<new_sha> in $GARDEN_ROOT; if anything under scripts/ changed,
# restart the long-running services so they re-exec onto the new code. Timer-driven
# oneshots are deliberately NOT restarted (they re-read on the next firing). Echoes
# a one-line summary via log.
#
# Unit-file reconciliation (render + disable/remove retired units) is NOT this
# function's job: the deliberate deploy owns it in a dedicated, UNCONDITIONAL
# reconcile step (deploy-garden.sh, right after record_deployed_sha) that runs
# every deploy regardless of whether a scripts/systemd/ file changed, so the
# deploy itself is the authority that no retired unit survives. The caller must
# have reconciled the unit set before calling this — deploy-garden.sh does.
#
# The third argument controls the gardener busy-gate. With 1 (the default), a
# gardener carrying its mid-job busy marker is DEFERRED, not restarted — the
# deploy-sync posture, restart-between-claims-not-mid-job. The deliberate deploy
# passes 0: it has already drained and quiesced the fleet, so there is no mid-job
# gardener to protect and every gardener should re-exec now.
#
# Returns 0 always (a failed individual restart is logged, never fatal); the
# caller decides whether a partial restart matters.
restart_long_running_fleet() {
  local old_sha="${1:?old_sha}" new_sha="${2:?new_sha}" busy_gate="${3:-1}"

  if [ "$old_sha" = "$new_sha" ]; then
    log "restart: tree unchanged ($new_sha); no re-exec needed"
    return 0
  fi

  local scripts_changed=0 path
  while read -r path; do
    [ -n "$path" ] || continue
    case "$path" in
      scripts/*) scripts_changed=1 ;;
    esac
  done < <(git -C "$GARDEN_ROOT" diff --name-only "$old_sha" "$new_sha" 2>/dev/null)

  if [ "$scripts_changed" -ne 1 ]; then
    log "restart: no scripts/ changes in $old_sha..$new_sha; no service re-exec needed"
    return 0
  fi

  # No unit re-render here: a changed [Service]/[Timer] was already rendered by the
  # deploy's reconcile step (see the header) before this function ran. A former
  # units_changed-gated `install` at this point was redundant with that reconcile
  # and, being a render only, never disabled a retired unit — exactly the gap that
  # let a retired unit survive a deploy that did not touch scripts/systemd/.

  local restarted=0 deferred=0 failed=0 unit idx
  local -a to_restart=()

  # Gather the worker units to re-exec, across EVERY worker kind (gardener, cleric,
  # …) via the registry. With the busy-gate on, defer a mid-job worker; with it off
  # (the deliberate deploy, post-quiesce) take every active worker. We only COLLECT
  # here; the actual restarts are issued concurrently below so the per-unit stop
  # windows overlap instead of summing. The busy check keys on the kind's own marker
  # namespace (worker_busy), so a mid-job cleric is deferred exactly like a gardener.
  local wkind wunit_base
  for wkind in $(worker_kinds); do
    wunit_base="$(worker_kind_field "$wkind" unit)"      # garden-gardener@ / garden-cleric@
    while read -r unit; do
      [ -n "$unit" ] || continue
      case "$unit" in "$wunit_base"*.service) ;; *) continue ;; esac
      if [ "$busy_gate" = "1" ]; then
        idx="${unit#"$wunit_base"}"; idx="${idx%.service}"
        if worker_busy "$wkind" "$idx"; then
          log "restart: $wkind $idx is mid-job; deferring its restart"
          deferred=$((deferred+1))
          continue
        fi
      fi
      to_restart+=("$unit")
    done < <(_restart_active_units "${wunit_base}*.service")
  done

  # Other long-running services: the bulletin singleton and the watcher instance
  # pool. Absent units yield an empty list and are a no-op. They restart in the
  # same concurrent wave as the gardeners.
  local pat
  for pat in 'garden-bulletin.service' 'garden-watcher@*.service'; do
    while read -r unit; do
      [ -n "$unit" ] || continue
      to_restart+=("$unit")
    done < <(_restart_active_units "$pat")
  done

  # Restart every collected unit CONCURRENTLY, not one at a time.
  #
  # Why this matters (the ~14-min-deploy bug, 2026-06-29): a `systemctl restart`
  # client BLOCKS until its unit's stop+start job completes, and a gardener stop
  # is slow. An idle gardener is parked in gardener.sh's idle-poll `sleep` (up to
  # GARDEN_IDLE_SLEEP_CAP, default 30s). Under the unit's KillMode=mixed, a stop
  # SIGTERMs only the main process (self-heal-run.sh), which forwards the signal
  # to gardener.sh — but bash DEFERS a trapped signal until the foreground `sleep`
  # returns, and the sleep itself is never signaled. So each unit's stop waits out
  # the remainder of its idle sleep (~11s observed) before the worker reaches its
  # between-claims point and exits and the cgroup empties. Issued serially, N such
  # stops cost N × that latency: 77 gardeners × ~11s ≈ 14 minutes, almost all of it
  # inside this function, which at the ~15-min main2 commit cadence kept the leader
  # in near-continuous drain/restart.
  #
  # Restarting concurrently overlaps every unit's stop window, so the whole fleet
  # restart costs ~one idle-poll window (≤ GARDEN_IDLE_SLEEP_CAP) plus start
  # overhead, instead of the sum. systemd runs the queued jobs in parallel anyway;
  # the only thing we change is to stop blocking on N client waits one-at-a-time.
  # Each unit keeps its own `unit_ctl restart` invocation so per-unit accounting
  # and failure isolation are preserved (one bad unit does not abort the wave).
  if [ "${#to_restart[@]}" -gt 0 ]; then
    local -a pids=() ulist=()
    for unit in "${to_restart[@]}"; do
      unit_ctl restart "$unit" >/dev/null 2>&1 &
      pids+=("$!"); ulist+=("$unit")
    done
    local i
    for i in "${!pids[@]}"; do
      if wait "${pids[$i]}"; then
        restarted=$((restarted+1))
      else
        log "WARN: restart of ${ulist[$i]} failed"; failed=$((failed+1))
      fi
    done
  fi

  log "restart complete: restarted=$restarted deferred(mid-job)=$deferred failed=$failed (now at $new_sha)"
  return 0
}
