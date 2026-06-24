#!/bin/bash
# install-units.sh — render and install the garden systemd --user units.
#
# Usage:
#   install-units.sh install            render+install all unit files, daemon-reload
#   install-units.sh scale <N>          run N gardeners (enable @1..@N, disable the rest)
#   install-units.sh enable-services    enable+start repo-watcher, reaper, watchman timers
#   install-units.sh status             show the garden units and timers
#
# Units are rendered from scripts/systemd/*.{service,timer} with @GARDEN_ROOT@
# substituted, into ~/.config/systemd/user/. Requires a working `systemctl
# --user` (see the design doc for the XDG_RUNTIME_DIR / lingering bootstrap).

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="install"
systemd_user_env

SRC="$GARDEN_ROOT/scripts/systemd"
DEST="${XDG_CONFIG_HOME:-$HOME/.config}/systemd/user"

render() {
  mkdir -p "$DEST"
  for f in "$SRC"/garden-*.service "$SRC"/garden-*.timer; do
    [ -e "$f" ] || continue
    sed "s#@GARDEN_ROOT@#$GARDEN_ROOT#g" "$f" > "$DEST/$(basename "$f")"
  done
  unit_ctl daemon-reload
  log "installed units into $DEST and reloaded"
}

scale() {
  local n="${1:?usage: install-units.sh scale <N>}"
  for i in $(seq 1 "$n"); do unit_ctl enable --now "garden-gardener@$i.service"; done
  # disable any higher-numbered instances still running
  while read -r unit _; do
    case "$unit" in
      garden-gardener@*.service)
        idx="${unit#garden-gardener@}"; idx="${idx%.service}"
        [[ "$idx" =~ ^[0-9]+$ ]] && [ "$idx" -gt "$n" ] && unit_ctl disable --now "$unit";;
    esac
  done < <(unit_ctl list-units --all 'garden-gardener@*.service' --no-legend 2>/dev/null || true)
  log "scaled gardener pool to $n"
}

enable_services() {
  unit_ctl enable --now garden-repo-watcher.timer
  unit_ctl enable --now garden-reaper.timer
  unit_ctl enable --now garden-watchman.timer
  unit_ctl enable --now garden-gardener-scaler.timer
  unit_ctl enable --now garden-scheduler.timer
  unit_ctl enable --now garden-bulletin.timer
  unit_ctl enable --now garden-improver.timer
  log "enabled repo-watcher, reaper, watchman, gardener-scaler, scheduler, bulletin, improver timers"
}

status() {
  unit_ctl list-units 'garden-*' --all --no-pager || true
  unit_ctl list-timers 'garden-*' --all --no-pager || true
}

case "${1:-install}" in
  install)         render;;
  scale)           shift; scale "$@";;
  enable-services) enable_services;;
  status)          status;;
  *) die "usage: install-units.sh {install|scale <N>|enable-services|status}";;
esac
