#!/bin/bash
# install-units.sh — render and install the garden systemd --user units.
#
# Usage:
#   install-units.sh install                  render+install all unit files, daemon-reload
#   install-units.sh scale <N>                run N gardeners (enable @1..@N, disable the rest)
#   install-units.sh enable-services          enable+start every intended garden timer/service
#   install-units.sh enable-services --verify report any intended unit not currently enabled (drift check)
#   install-units.sh status                   show the garden units and timers
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

# --- enable-set policy -------------------------------------------------------
#
# enable_services derives the units to enable FROM THE UNITS ACTUALLY PRESENT in
# $SRC, not from a hand-maintained list. A hand-maintained list drifts: every
# garden-*.timer added after the list was written (foreman, deadmail, follow-up,
# proxy, mirror-closer, …) was silently NEVER enabled, so the services never ran
# until found dormant by hand (2026-06-26). Deriving from the present units means
# a newly-added timer/service is covered automatically.
#
# Two classes of unit are deliberately EXCLUDED from the auto-enable, by policy:
#
#   1. Template units (garden-*@.{service,timer}) — enabled PER-INSTANCE, never
#      globally: garden-gardener@ (by `scale`), garden-comment-watcher@ /
#      garden-triager@ (per watched repo, by the repo-watcher from the journal's
#      repos/ set), garden-driver@ / garden-watcher@ (per lane/feed). These are
#      excluded structurally by the `@` filter in intended_units, not by name.
#
#   2. Monitoring-gated units that the monitoring-safety constraint (see CLAUDE.md
#      § Monitoring safety constraint) says require EXPLICIT MAINTAINER
#      AUTHORIZATION to arm. garden-mention-watcher watches all of GitHub; arming
#      it must be a deliberate maintainer act, never a side effect of a routine
#      install. It is left for the maintainer to enable by hand. Named below.
EXCLUDED_UNITS=(
  garden-mention-watcher.timer
  garden-mention-watcher.service
)

# Retired units a previously-installed host may still have enabled. The install
# step disables them so they don't linger. The bulletin migrated from an
# oneshot+timer to a long-running Restart= service; its old timer is retired.
RETIRED_UNITS=(
  garden-bulletin.timer
)

is_excluded() {
  local u="$1" e
  for e in "${EXCLUDED_UNITS[@]}"; do [ "$u" = "$e" ] && return 0; done
  return 1
}

# Derive the set of units this host should enable from the units present in $SRC.
# One unit name per line. Rules:
#   * Skip template units (basename contains '@') — enabled per-instance.
#   * Skip explicitly-excluded units (monitoring-gated).
#   * A non-template *.timer carrying `WantedBy=timers.target` → enable the TIMER
#     (its [Timer] drives the paired oneshot service).
#   * A non-template *.service is enabled DIRECTLY only when it has NO sibling
#     *.timer (a timer-paired service is started BY its timer, so we enable the
#     timer, not the service) AND it declares an [Install] WantedBy= — i.e. it is
#     a standalone long-running service (the bulletin, the design-poller).
intended_units() {
  local f b base
  for f in "$SRC"/garden-*.timer "$SRC"/garden-*.service; do
    [ -e "$f" ] || continue
    b="$(basename "$f")"
    case "$b" in *@*) continue;; esac          # template → enabled per-instance
    is_excluded "$b" && continue
    case "$b" in
      *.timer)
        grep -q '^WantedBy=timers\.target' "$f" && printf '%s\n' "$b"
        ;;
      *.service)
        base="${b%.service}"
        [ -e "$SRC/$base.timer" ] && continue   # timer-driven oneshot → its timer is enabled instead
        grep -q '^WantedBy=' "$f" && printf '%s\n' "$b"
        ;;
    esac
  done
}

render() {
  mkdir -p "$DEST"
  # Globs every garden-*.{service,timer}, including the instance templates
  # (garden-gardener@, garden-triager@, garden-comment-watcher@, garden-driver@,
  # garden-watcher@), which are instance-armed elsewhere (see the enable-set
  # policy above) and so are excluded from enable_services.
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
  local u
  # Retire units a prior install may have left enabled (bulletin's old timer).
  for u in "${RETIRED_UNITS[@]}"; do unit_ctl disable --now "$u" 2>/dev/null || true; done
  # Enable every intended (derived) unit. --now starts it immediately too.
  local enabled=()
  while read -r u; do
    [ -n "$u" ] || continue
    unit_ctl enable --now "$u"
    enabled+=("$u")
  done < <(intended_units)
  log "enabled (${#enabled[@]}): ${enabled[*]}"
  log "excluded by policy: templates (garden-*@), ${EXCLUDED_UNITS[*]}"
}

# Drift check: report any intended unit that is NOT currently enabled (e.g. a unit
# added since the last enable-services run, or one manually disabled). Echoes the
# deliberately-excluded set for visibility. Exits non-zero when drift is found so a
# watchman/bulletin check can surface it. Idempotent and read-only.
enable_services_verify() {
  local u state drift=0
  while read -r u; do
    [ -n "$u" ] || continue
    state="$(unit_ctl is-enabled "$u" 2>/dev/null || true)"
    if [ "$state" = "enabled" ]; then
      log "ok: $u enabled"
    else
      log "DRIFT: $u is '${state:-unknown}' (expected enabled — run enable-services)"
      drift=1
    fi
  done < <(intended_units)
  log "excluded by policy (NOT expected enabled): templates (garden-*@), ${EXCLUDED_UNITS[*]}"
  if [ "$drift" -ne 0 ]; then
    log "enable-services drift detected"
    return 1
  fi
  log "no drift: every intended garden unit is enabled"
}

status() {
  unit_ctl list-units 'garden-*' --all --no-pager || true
  unit_ctl list-timers 'garden-*' --all --no-pager || true
}

case "${1:-install}" in
  install)         render;;
  scale)           shift; scale "$@";;
  enable-services)
    shift || true
    case "${1:-}" in
      ""|--now)        enable_services;;
      --verify|verify) enable_services_verify;;
      *) die "usage: install-units.sh enable-services [--verify]";;
    esac;;
  status)          status;;
  *) die "usage: install-units.sh {install|scale <N>|enable-services [--verify]|status}";;
esac
