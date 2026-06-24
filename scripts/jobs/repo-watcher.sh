#!/bin/bash
# repo-watcher.sh — reconcile the per-repo watcher units to the watch sets.
#
# Usage: repo-watcher.sh
#
# Two journal-backed watch sets, reconciled to systemd timer units each tick:
#   repos/         → garden-triager@<slug>         (commit watch; laxer bar)
#   comment-repos/ → garden-comment-watcher@<slug> (PR/issue COMMENT watch)
# A commit that adds a file is a watch, one that removes it an unwatch. This
# service's primary input is therefore the JOURNAL, not the repos themselves.
# Each tick it syncs the journal and reconciles the running timer units to
# exactly match the set. Idempotent.
#
# The two sets are SEPARATE on purpose: the comment watcher feeds untrusted
# external comment text into `claude -p`, so it carries the stricter
# monitoring-safety bar (CLAUDE.md § Monitoring safety constraint). A repo may be
# commit-triaged without being comment-watched; comment-repos/ is only widened
# after maintainer authorization is recorded in a journal `message` (see
# comment-watcher.sh header). Keeping comment-repos/ distinct from repos/ means
# the stricter bar cannot be widened by editing the laxer set.
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

# reconcile_set <journal-subdir> <unit-prefix>
# Arm a "<unit-prefix>@<slug>.timer" for every file under <journal-subdir>/, and
# disarm any armed instance whose file is gone. Idempotent. Echoes a summary.
reconcile_set() {
  local subdir="$1" prefix="$2" slug path inst
  declare -A want=() have=()
  shopt -s nullglob
  for path in "$DIR/$subdir"/*; do
    slug="${path##*/}"
    [ "$slug" = .gitkeep ] && continue
    want["$slug"]=1
  done
  shopt -u nullglob
  while read -r unit _; do
    case "$unit" in
      "$prefix"@*.timer)
        inst="${unit#"$prefix"@}"; inst="${inst%.timer}"
        [ -n "$inst" ] && have["$inst"]=1;;  # skip the bare template
    esac
  done < <(unit_ctl list-unit-files "$prefix@*.timer" --no-legend 2>/dev/null || true)

  for slug in "${!want[@]}"; do
    if [ -z "${have[$slug]:-}" ]; then
      log "watch: arming $prefix@$slug.timer"
      unit_ctl enable --now "$prefix@$slug.timer" || log "WARN: could not arm $prefix@$slug"
    fi
  done
  for slug in "${!have[@]}"; do
    if [ -z "${want[$slug]:-}" ]; then
      log "unwatch: disarming $prefix@$slug.timer"
      unit_ctl disable --now "$prefix@$slug.timer" || log "WARN: could not disarm $prefix@$slug"
    fi
  done
  log "reconciled $subdir: ${#want[@]} watched, ${#have[@]} previously armed"
}

# Reload the user manager before arming so the latest @.timer / @.service template
# bodies are loaded. Arming a template instance (`enable --now @<slug>.timer`)
# against a not-yet-loaded service template leaves the timer active but unable to
# resolve its trigger target — it never fires, and a `.timer` restart alone does
# NOT fix it (only a daemon-reload loads the service template). Reloading here,
# before every reconcile, closes that arming race durably. Cheap and idempotent;
# the test's mock-systemctl treats daemon-reload as a no-op.
unit_ctl daemon-reload 2>/dev/null || log "WARN: daemon-reload failed (continuing to reconcile)"

# repos/ → commit triager (laxer bar); comment-repos/ → comment watcher (stricter
# monitoring-safety bar, widened only after journal-recorded maintainer auth).
reconcile_set repos         garden-triager
reconcile_set comment-repos garden-comment-watcher
