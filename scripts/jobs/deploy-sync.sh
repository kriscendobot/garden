#!/bin/bash
# deploy-sync.sh — reconcile the running fleet onto landed script fixes.
#
# Usage: deploy-sync.sh
#
# The garden's long-lived `garden-*` systemd units run scripts straight from this
# checkout (their ExecStart names @GARDEN_ROOT@/scripts/... by absolute path). Two
# things therefore have to happen for a fix that lands on origin/main2 to actually
# REACH the fleet:
#
#   1. The checkout must advance to the new code. A timer-driven *oneshot* unit
#      (reaper, foreman, scheduler, watchman, …) re-reads its script from disk on
#      its NEXT firing, so advancing the tree is all it needs. But a *long-running*
#      service (garden-gardener@N, garden-bulletin, garden-driver@, garden-watcher@)
#      parsed its script — and `source`d common.sh — once at start and holds them in
#      memory for the life of the process; it never re-reads the file. It picks up
#      new code ONLY on a fresh exec.
#   2. So when scripts/ actually changed, the long-running services must be
#      restarted to re-exec onto the new code.
#
# Without step 2 every reliability fix the fleet lands on itself is dead on arrival
# until a manual maintainer restart: the 2026-06-27 case where the gardener
# claim-path self-heal fix had already landed on origin/main2 yet 9 healthy
# long-running gardeners kept crash-looping on the OLD code (`claim failed
# (rc=128)`), because nothing re-exec'd them.
#
# This runs on a short cadence (garden-deploy-sync.timer, ~2–5 min). Each tick:
#   * fetch origin/main2;
#   * advance the checkout ONLY by a strict fast-forward of a CLEAN tree
#     (`git merge --ff-only`); skip-and-log if the tree has diverged — the live
#     tree may carry a concurrent gardener's in-flight edits (the isolated-worktree
#     convention), and we NEVER clobber them. If the tree is tracked-dirty (or an
#     untracked file collides with an incoming path), post a resolve-wedge job to
#     the board (trigger_wedge_resolution, shared with the watchman) so a gardener
#     cleans it losslessly and autonomously — the maintainer is NOT paged
#     (directive 2026-06-27);
#   * if anything under scripts/ changed, restart the long-running services so they
#     re-exec; if a unit FILE under scripts/systemd/ changed, re-render + reload the
#     units first.
#
# Gardener safety — restart BETWEEN claims, not mid-job. A gardener is restarted
# only when it is NOT running a job: gardener.sh drops a local busy marker
# ($GARDEN_STATE/gardeners/<id>/busy) while a handler runs and clears it the moment
# the job ends, so a mid-job gardener is deferred to a later tick (its fix lands
# when it next goes idle). A crash-looping gardener never reaches the handler, so it
# carries no marker and is restarted immediately — and it would also re-exec onto
# the fix on its own via Restart=on-failure once the file lands; this just makes the
# HEALTHY long-running workers (which never crash, so never re-exec) converge too.
#
# This is the deploy half of the watchman's notify half: the watchman advances the
# tree and tells gardeners to REREAD their roles/skills (context a `claude -p` reads
# fresh each tick); deploy-sync re-execs the long-lived SHELL processes onto the new
# code (which a running process does not re-read). Advancing the tree here is
# idempotent with the watchman's own fast-forward: whichever runs first advances,
# the other sees no change.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
# shellcheck source=wedge-resolve.sh
source "$HERE/wedge-resolve.sh"
GARDEN_TAG="deploy-sync"
: "${GARDEN_MAIN_BRANCH:=main2}"
: "${GARDEN_DEPLOY_SYNC:=1}"

[ "$GARDEN_DEPLOY_SYNC" = "1" ] || { log "GARDEN_DEPLOY_SYNC=$GARDEN_DEPLOY_SYNC; disabled, skipping"; exit 0; }

# --- advance the checkout (clean strict fast-forward only) -------------------

git -C "$GARDEN_ROOT" fetch -q origin "$GARDEN_MAIN_BRANCH" 2>/dev/null \
  || { log "fetch of origin/$GARDEN_MAIN_BRANCH failed (offline?); skipping tick"; exit 0; }

old_sha="$(git -C "$GARDEN_ROOT" rev-parse --verify --quiet "$GARDEN_MAIN_BRANCH" || true)"
[ -n "$old_sha" ] || die "cannot resolve local $GARDEN_MAIN_BRANCH in $GARDEN_ROOT"
up_sha="$(git -C "$GARDEN_ROOT" rev-parse --verify --quiet "origin/$GARDEN_MAIN_BRANCH" || echo "$old_sha")"

if [ "$up_sha" = "$old_sha" ]; then
  log "no change on $GARDEN_MAIN_BRANCH ($old_sha); nothing to deploy"
  exit 0
fi

# Diverged (not a strict fast-forward)? Skip-and-log; never reset/rebase a tree
# that may hold a peer's work.
if ! git -C "$GARDEN_ROOT" merge-base --is-ancestor "$old_sha" "$up_sha" 2>/dev/null; then
  log "WARN: $GARDEN_MAIN_BRANCH has DIVERGED from origin ($old_sha vs $up_sha); not a fast-forward, skipping deploy"
  exit 0
fi

# Tracked working-tree changes block the fast-forward — leave them alone and skip.
# Untracked files (scratch, stray sibling worktrees, build artifacts) are NOT WIP
# and must not wedge the deploy (mirrors watchman.sh --untracked-files=no).
dirty_tracked="$(git -C "$GARDEN_ROOT" status --porcelain --untracked-files=no 2>/dev/null)"
if [ -n "$dirty_tracked" ]; then
  log "WARN: $GARDEN_MAIN_BRANCH worktree has TRACKED changes; skipping deploy (tree carries in-flight edits), posting resolve-wedge job"
  log "blocking paths: $(printf '%s' "$dirty_tracked" | tr '\n' ';')"
  # Trigger autonomous resolution rather than wedging indefinitely. Idempotent with
  # the watchman: the same (host, target, paths) signature posts one job, claimed
  # once. Never page the maintainer (directive 2026-06-27).
  trigger_wedge_resolution "$old_sha" "$up_sha" "tracked working-tree changes block the fast-forward" "$dirty_tracked"
  exit 0
fi

if ! git -C "$GARDEN_ROOT" merge --ff-only "origin/$GARDEN_MAIN_BRANCH" >/dev/null 2>&1; then
  # No tracked WIP yet ff was refused — typically an untracked file colliding with
  # an incoming tracked path. Resolve autonomously and skip; never clobber.
  log "WARN: ff-merge to origin/$GARDEN_MAIN_BRANCH refused (an untracked file collides with an incoming path?); posting resolve-wedge job"
  trigger_wedge_resolution "$old_sha" "$up_sha" "fast-forward refused (an untracked file collides with an incoming tracked path)" ""
  exit 0
fi
log "deployed $GARDEN_MAIN_BRANCH: $old_sha -> $up_sha"

# --- what changed? -----------------------------------------------------------

scripts_changed=0
units_changed=0
while read -r path; do
  [ -n "$path" ] || continue
  case "$path" in
    scripts/systemd/*) units_changed=1; scripts_changed=1 ;;
    scripts/*)         scripts_changed=1 ;;
  esac
done < <(git -C "$GARDEN_ROOT" diff --name-only "$old_sha" "$up_sha" 2>/dev/null)

if [ "$scripts_changed" -ne 1 ]; then
  log "no scripts/ changes in $old_sha..$up_sha; tree advanced, no service re-exec needed"
  exit 0
fi

# Draining: the fleet is deliberately paused. Advancing the tree is harmless,
# but a restart would re-exec a worker that then exits-clean on the draining marker
# and (with Restart=on-failure) stay DOWN, breaking the intended pause. Skip restarts.
if fleet_draining; then
  log "scripts/ changed but fleet draining; tree advanced, deferring service re-exec"
  exit 0
fi

# --- re-render units when a unit FILE changed --------------------------------

if [ "$units_changed" -eq 1 ]; then
  log "scripts/systemd/ changed; re-rendering units + daemon-reload"
  "$HERE/install-units.sh" install >/dev/null 2>&1 \
    || log "WARN: install-units.sh install failed (continuing to restart)"
fi

# --- restart the long-running services so they re-exec onto new code ----------
#
# Only long-running (Type=exec/simple, Restart=) units hold stale code in a live
# process; timer-driven oneshots re-read their script on the next firing, so they
# are deliberately NOT restarted here.

# List the currently-active instances of a unit (glob) pattern, one unit per line.
# `list-units` (without --all) reports active units; the first field is the unit.
active_units() {
  unit_ctl list-units "$1" --no-legend 2>/dev/null | awk '{print $1}'
}

restarted=0
deferred=0
failed=0

# Gardeners — restart only those NOT mid-job (busy-marker gate); defer the rest.
while read -r unit; do
  [ -n "$unit" ] || continue
  case "$unit" in garden-gardener@*.service) ;; *) continue ;; esac
  idx="${unit#garden-gardener@}"; idx="${idx%.service}"
  if gardener_busy "$idx"; then
    log "gardener $idx is mid-job; deferring its restart to a later tick"
    deferred=$((deferred+1))
    continue
  fi
  if unit_ctl restart "$unit" >/dev/null 2>&1; then
    restarted=$((restarted+1))
  else
    log "WARN: restart of $unit failed"; failed=$((failed+1))
  fi
done < <(active_units 'garden-gardener@*.service')

# Other long-running services: the bulletin singleton and the driver/watcher
# instance pools. Restarted directly (no mid-job marker for these); absent units
# yield an empty list and are a no-op.
for pat in 'garden-bulletin.service' 'garden-driver@*.service' 'garden-watcher@*.service'; do
  while read -r unit; do
    [ -n "$unit" ] || continue
    if unit_ctl restart "$unit" >/dev/null 2>&1; then
      restarted=$((restarted+1))
      log "restarted $unit"
    else
      log "WARN: restart of $unit failed"; failed=$((failed+1))
    fi
  done < <(active_units "$pat")
done

log "deploy complete: restarted=$restarted deferred(mid-job)=$deferred failed=$failed (now at $up_sha)"
