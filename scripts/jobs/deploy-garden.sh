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
#   1. DRAIN.   Engage the draining marker so gardeners finish their in-flight
#               claim and take no new ones, then wait for the host to QUIESCE — no
#               gardener busy marker remains ($GARDEN_STATE/gardeners/*/busy, the
#               same host-local mid-job signal deploy-sync used). Bounded by
#               GARDEN_DEPLOY_DRAIN_TIMEOUT; on timeout the deploy aborts and (if
#               it engaged the drain) lifts it, so a stuck job never strands the
#               fleet drained.
#   2. MERGE.   Advance the root tree by a strict fast-forward to
#               origin/$GARDEN_MAIN_BRANCH. Because development no longer happens
#               in the root tree, the tree is clean and the ff never wedges. A
#               dirty or diverged tree means the no-shared-tree invariant was
#               violated; the deploy ABORTS without clobbering rather than force
#               anything.
#   3. RECORD + LIFT + RESTART. Record the new HEAD as the deployed sha, lift the
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
GARDEN_TAG="deploy-garden"

: "${GARDEN_DEPLOY_DRAIN_TIMEOUT:=600}"   # seconds to wait for the fleet to quiesce
: "${GARDEN_DEPLOY_POLL:=5}"              # seconds between quiesce polls
: "${GARDEN_DEPLOY_NO_BROADCAST:=0}"      # set 1 to skip the post-deploy reread broadcast (tests)

# Did THIS run engage the drain? Used to decide whether an abort should lift it.
# (If an operator pre-drained for maintenance, an aborted deploy must not resume
# their fleet.) A SUCCESSFUL deploy always ends with the fleet running, so it
# lifts the drain regardless — running on the new code is the point of a deploy.
we_drained=0

lift_drain_if_we_engaged() {
  [ "$we_drained" = "1" ] || return 0
  "$HERE/drain-fleet.sh" off >/dev/null 2>&1 || true
  log "drain lifted (deploy aborted; restored pre-deploy run state)"
}

# Count this host's mid-job gardeners by their busy markers. Zero = quiesced.
busy_count() {
  local n=0 m
  for m in "$GARDEN_STATE"/gardeners/*/busy; do [ -e "$m" ] && n=$((n+1)); done
  printf '%s\n' "$n"
}

# --- 1. DRAIN ----------------------------------------------------------------

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
  if [ "$(date +%s)" -ge "$deadline" ]; then
    log "WARN: quiesce timed out after ${GARDEN_DEPLOY_DRAIN_TIMEOUT}s with $n mid-job gardener(s); aborting deploy"
    lift_drain_if_we_engaged
    exit 1
  fi
  log "waiting for $n mid-job gardener(s) to finish..."
  sleep "$GARDEN_DEPLOY_POLL"
done

# --- 2. MERGE ----------------------------------------------------------------

git -C "$GARDEN_ROOT" fetch -q origin "$GARDEN_MAIN_BRANCH" 2>/dev/null \
  || { log "WARN: fetch of origin/$GARDEN_MAIN_BRANCH failed (offline?); aborting deploy"; lift_drain_if_we_engaged; exit 1; }

old_sha="$(git -C "$GARDEN_ROOT" rev-parse --verify --quiet HEAD || true)"
[ -n "$old_sha" ] || { log "FATAL: cannot resolve HEAD in $GARDEN_ROOT"; lift_drain_if_we_engaged; exit 1; }
up_sha="$(git -C "$GARDEN_ROOT" rev-parse --verify --quiet "origin/$GARDEN_MAIN_BRANCH" || echo "$old_sha")"

if [ "$up_sha" = "$old_sha" ]; then
  log "root already at origin/$GARDEN_MAIN_BRANCH ($old_sha); nothing to deploy"
  record_deployed_sha "$old_sha"
  # A no-op deploy still lifts the drain it engaged (the fleet should resume).
  [ "$we_drained" = "1" ] && { "$HERE/drain-fleet.sh" off >/dev/null 2>&1 || true; log "drain lifted (no-op deploy)"; }
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

if ! git -C "$GARDEN_ROOT" merge --ff-only "origin/$GARDEN_MAIN_BRANCH" >/dev/null 2>&1; then
  log "WARN: ff-merge to origin/$GARDEN_MAIN_BRANCH refused (an untracked file collides with an incoming path?); aborting deploy."
  lift_drain_if_we_engaged
  exit 1
fi
new_sha="$(git -C "$GARDEN_ROOT" rev-parse --verify HEAD)"
log "merged origin/$GARDEN_MAIN_BRANCH into the root: $old_sha -> $new_sha"

# --- 3. RECORD + LIFT + RESTART ----------------------------------------------

record_deployed_sha "$new_sha"
log "recorded deployed sha: $new_sha"

# Lift the drain BEFORE restarting so the restarted units come up live (the
# drained gardeners have already exited; nothing runs on the old code).
"$HERE/drain-fleet.sh" off >/dev/null 2>&1 || log "WARN: could not lift the draining marker"
log "drain lifted; fleet may resume"

# Restart the long-running fleet onto the new code (busy-gate off: we quiesced).
restart_long_running_fleet "$old_sha" "$new_sha" 0

# Best-effort post-deploy reread broadcast (the watchman also broadcasts on the
# tree change; this makes the deploy itself announce). Guardable for tests.
if [ "$GARDEN_DEPLOY_NO_BROADCAST" != "1" ]; then
  printf '%s deployed to %s — reread your role and skills as needed.\n' "$GARDEN_MAIN_BRANCH" "$new_sha" \
    | GARDEN_SENDER=deploy-garden "$HERE/send-msg.sh" broadcast >/dev/null 2>&1 \
    || log "post-deploy broadcast skipped (no journal?)"
fi

log "deploy complete: root now at $new_sha"
