#!/bin/bash
# repo-watcher.sh — reconcile the per-repo triager units to the watch set.
#
# Usage: repo-watcher.sh
#
# The journal's repos/ directory IS the watch set: a commit that adds a file is
# a watch, a commit that removes one is an unwatch. This service's primary
# input is therefore the JOURNAL, not the repos themselves. Each tick it syncs
# the journal and reconciles the running `garden-triager@<slug>` timer units to
# exactly match repos/: enable+start a timer for every watched repo, stop+
# disable any triager timer whose repo is no longer in the set. Idempotent.
#
# Unit control is indirected through unit_ctl() (common.sh) so the test harness
# can mock systemctl.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="repo-watcher"

DIR="${GARDEN_WATCHER_CLONE:-$GARDEN_STATE/repo-watcher/journal}"
ensure_clone "$DIR"
sync_clone "$DIR"

# desired set = files under repos/
declare -A want=()
for slug in $(ls -1 "$DIR/repos" 2>/dev/null | grep -v -x '.gitkeep'); do
  want["$slug"]=1
done

# currently-armed set = enabled garden-triager@<slug>.timer instances
declare -A have=()
while read -r unit _; do
  case "$unit" in
    garden-triager@*.timer)
      inst="${unit#garden-triager@}"; inst="${inst%.timer}"
      [ -n "$inst" ] && have["$inst"]=1;;  # skip the bare template (garden-triager@.timer)
  esac
done < <(unit_ctl list-unit-files 'garden-triager@*.timer' --no-legend 2>/dev/null || true)

# enable+start anything wanted but not armed
for slug in "${!want[@]}"; do
  if [ -z "${have[$slug]:-}" ]; then
    log "watch: arming garden-triager@$slug.timer"
    unit_ctl enable --now "garden-triager@$slug.timer" || log "WARN: could not arm $slug"
  fi
done
# stop+disable anything armed but no longer wanted
for slug in "${!have[@]}"; do
  if [ -z "${want[$slug]:-}" ]; then
    log "unwatch: disarming garden-triager@$slug.timer"
    unit_ctl disable --now "garden-triager@$slug.timer" || log "WARN: could not disarm $slug"
  fi
done

log "reconciled: ${#want[@]} watched, ${#have[@]} previously armed"
