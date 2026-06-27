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
# (garden-gardener@N, garden-bulletin, garden-driver@, garden-watcher@) parsed its
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

  # Gardeners. With the busy-gate on, defer a mid-job gardener; with it off (the
  # deliberate deploy, post-quiesce) restart every active gardener.
  while read -r unit; do
    [ -n "$unit" ] || continue
    case "$unit" in garden-gardener@*.service) ;; *) continue ;; esac
    if [ "$busy_gate" = "1" ]; then
      idx="${unit#garden-gardener@}"; idx="${idx%.service}"
      if gardener_busy "$idx"; then
        log "restart: gardener $idx is mid-job; deferring its restart"
        deferred=$((deferred+1))
        continue
      fi
    fi
    if unit_ctl restart "$unit" >/dev/null 2>&1; then
      restarted=$((restarted+1))
    else
      log "WARN: restart of $unit failed"; failed=$((failed+1))
    fi
  done < <(_restart_active_units 'garden-gardener@*.service')

  # Other long-running services: the bulletin singleton and the driver/watcher
  # instance pools. Absent units yield an empty list and are a no-op.
  local pat
  for pat in 'garden-bulletin.service' 'garden-driver@*.service' 'garden-watcher@*.service'; do
    while read -r unit; do
      [ -n "$unit" ] || continue
      if unit_ctl restart "$unit" >/dev/null 2>&1; then
        restarted=$((restarted+1)); log "restart: restarted $unit"
      else
        log "WARN: restart of $unit failed"; failed=$((failed+1))
      fi
    done < <(_restart_active_units "$pat")
  done

  log "restart complete: restarted=$restarted deferred(mid-job)=$deferred failed=$failed (now at $new_sha)"
  return 0
}
