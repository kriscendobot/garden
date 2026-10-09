#!/bin/bash
# deploy-strand-recover.sh — finish a deploy-garden.sh that died mid-deploy. NO LLM.
#
# Usage: deploy-strand-recover.sh   (idempotent; silent when nothing is stranded)
#
# deploy-garden.sh engages the drain, freezes every garden timer, swaps the tree,
# then reconciles units, thaws the timers and lifts the drain. If the process dies
# between the freeze and the thaw without running its EXIT trap, the host is left
# drained with every timer stopped. Nothing on the host then runs: the gardeners
# exited on the drain and every timer-driven daemon (sysop, reaper, self-deploy
# itself) is stopped. On 2026-10-02 oros-studio sat like that for 6.5 days
# (bash died with "error reading input file" after the swap replaced the running
# script; fixed in deploy-garden.sh, this is the backstop).
#
# A deploy is STRANDED when:
#   * the in-progress record ($GARDEN_DEPLOY_IN_PROGRESS_RECORD) names a pid that is
#     no longer a running deploy-garden.sh, or
#   * (legacy, no record) the draining marker carries deploy-garden's reason, has
#     been there longer than GARDEN_DEPLOY_STRAND_LEGACY_GRACE, and no deploy-garden.sh
#     process is running.
#
# Recovery, in deploy-garden.sh's own order:
#   1. If the tree swap landed (root HEAD == the record's target), reconcile units
#      (install-units.sh install + enable-services) and re-record the deployed sha.
#   2. Thaw the timers listed in the persisted frozen set
#      ($GARDEN_DEPLOY_FROZEN_TIMERS_FILE); with no list (legacy), enable-services
#      restarts the intended timers.
#   3. Lift the drain, but only when the deploy engaged it and the marker still
#      carries deploy-garden's reason (an operator who drained since keeps their drain).
#   4. If the swap landed, restart the idle long-running fleet onto the new code and
#      publish fleet health.
#   5. Alert the maintainer, and clear the record.
#
# Callers: self-deploy.sh (every tick, and right after it runs a deploy) and
# rolling-deploy.sh (right after the leader's own deploy).
#
# Test seams:
#   GARDEN_DEPLOY_STRAND_PGREP  command that prints pids of running deploy-garden.sh
#                               processes (default: pgrep -f)

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
# shellcheck source=deploy-restart.sh
source "$HERE/deploy-restart.sh"
# shellcheck source=deploy-release-boundary.sh
source "$HERE/deploy-release-boundary.sh"
export GARDEN_TAG="deploy-strand-recover"

: "${GARDEN_DEPLOY_STRAND_LEGACY_GRACE:=3600}"

REC="$GARDEN_DEPLOY_IN_PROGRESS_RECORD"
field() { [ -f "$REC" ] && sed -n "s/^$1:[[:space:]]*//p" "$REC" 2>/dev/null | head -1 || true; }

running_deploy_pids() {
  if [ -n "${GARDEN_DEPLOY_STRAND_PGREP:-}" ]; then
    "$GARDEN_DEPLOY_STRAND_PGREP" 2>/dev/null || true
  else
    pgrep -f 'deploy-garden\.sh( |$)' 2>/dev/null || true
  fi
}

pid_is_live_deploy() {  # <pid>
  local p
  [[ "$1" =~ ^[0-9]+$ ]] || return 1
  for p in $(running_deploy_pids); do [ "$p" = "$1" ] && return 0; done
  return 1
}

drain_reason() {
  [ -e "$GARDEN_DRAINING_MARKER" ] || return 0
  sed -n 's/^reason:[[:space:]]*//p' "$GARDEN_DRAINING_MARKER" 2>/dev/null | head -1 || true
}

mkdir -p "$GARDEN_DEPLOY_STATE" 2>/dev/null || true
exec 9>"$GARDEN_DEPLOY_STATE/strand-recover.lock"
flock -n 9 || exit 0

mode=""
if [ -f "$REC" ]; then
  pid_is_live_deploy "$(field pid)" && exit 0
  mode="record"
elif [ "$(drain_reason)" = "$GARDEN_DEPLOY_DRAIN_REASON" ]; then
  [ -z "$(running_deploy_pids)" ] || exit 0
  age=$(( $(date +%s) - $(stat -c %Y "$GARDEN_DRAINING_MARKER" 2>/dev/null || date +%s) ))
  [ "$age" -ge "$GARDEN_DEPLOY_STRAND_LEGACY_GRACE" ] || exit 0
  mode="legacy"
else
  exit 0
fi

old_sha="$(field old_sha)"; target="$(field target)"
we_drained="$(field we_drained)"; [ "$mode" = legacy ] && we_drained=1
log "STRANDED deploy detected ($mode: pid '$(field pid)' gone, target '${target:0:12}'); finishing the thaw and drain lift"

head_sha="$(git -C "$GARDEN_ROOT" rev-parse --verify --quiet HEAD 2>/dev/null || true)"
swapped=0
if [ -n "$target" ] && [ "$head_sha" = "$target" ] && [ -n "$old_sha" ] && [ "$old_sha" != "$target" ]; then
  swapped=1
  record_deployed_sha "$target"
  "$HERE/install-units.sh" install >/dev/null 2>&1 \
    || log "WARN: unit render during strand recovery failed (continuing)"
  "$HERE/install-units.sh" enable-services >/dev/null 2>&1 \
    || log "WARN: enable-services during strand recovery failed (continuing)"
fi

thawed="none recorded"
if load_persisted_frozen_timers; then
  thawed="${#FROZEN_TIMERS[@]} timer(s)"
  thaw_timers || log "WARN: not every frozen timer thawed cleanly; a later reconcile tick retries the stragglers"
elif [ "$mode" = legacy ]; then
  thawed="intended timers via enable-services (no frozen-timer record)"
  "$HERE/install-units.sh" enable-services >/dev/null 2>&1 \
    || log "WARN: enable-services (legacy thaw) failed; start the garden timers by hand"
fi

lifted="no"
if [ "$we_drained" = "1" ] && [ "$(drain_reason)" = "$GARDEN_DEPLOY_DRAIN_REASON" ]; then
  if "$HERE/drain-fleet.sh" off >/dev/null 2>&1; then lifted="yes"
  else log "WARN: could not lift the stranded deploy's drain"; fi
elif fleet_draining; then
  lifted="no (drain is not the deploy's own; left in place)"
fi

if [ "$swapped" -eq 1 ]; then
  restart_long_running_fleet "$old_sha" "$target" 1
  if [ "${GARDEN_DEPLOY_NO_HEALTH_PUBLISH:-0}" != "1" ]; then
    publish_fleet_health "$target" deployed >/dev/null 2>&1 \
      || log "WARN: could not publish fleet health after strand recovery"
  fi
fi

rm -f "$REC" 2>/dev/null || true
msg="deploy-garden.sh on $GARDEN died mid-deploy (target ${target:-unknown}, swap landed: $([ "$swapped" -eq 1 ] && echo yes || echo no)). deploy-strand-recover.sh thawed ${thawed} and lifted the drain: ${lifted}. Check the deploy log for the cause."
log "$msg"
alert_maintainer "deploy-strand-$GARDEN" "$msg"
exit 0
