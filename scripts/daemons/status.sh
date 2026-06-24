#!/bin/bash
# status.sh -- report systemd unit state for the configured set of
# driver lanes and per-feed watchers.
#
# Reads host-local config from scripts/daemons/config.sh.
#
# Usage:
#   scripts/daemons/status.sh [--verbose]
#
# Default: one line per unit (name + Active state). --verbose passes
# through to `systemctl --user status` for full systemd output
# including the recent log tail.

set -uo pipefail

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
CONFIG_FILE="$SCRIPT_DIR/config.sh"

GARDEN_DRIVER_LANES=()
GARDEN_WATCHER_FEEDS=()

if [ -f "$CONFIG_FILE" ]; then
  # shellcheck source=/dev/null
  source "$CONFIG_FILE"
else
  echo "status: $CONFIG_FILE not found." >&2
  echo "status: copy scripts/daemons/config.sh.example to scripts/daemons/config.sh and edit." >&2
  exit 0
fi

VERBOSE=0
case "${1:-}" in
  --verbose) VERBOSE=1 ;;
  '') ;;
  *) echo "status: unknown flag: $1" >&2; exit 64 ;;
esac

if ! command -v systemctl >/dev/null 2>&1; then
  echo "status: systemctl not available; nothing to report" >&2
  exit 1
fi

units=()
for lane in "${GARDEN_DRIVER_LANES[@]}"; do
  units+=("garden-driver@${lane}.service")
done
for feed in "${GARDEN_WATCHER_FEEDS[@]}"; do
  units+=("garden-watcher@${feed}.service")
done

if [ "${#units[@]}" -eq 0 ]; then
  echo "status: config has no lanes or feeds; nothing to report"
  exit 0
fi

if [ "$VERBOSE" -eq 1 ]; then
  for u in "${units[@]}"; do
    systemctl --user status "$u" --no-pager || true
    echo
  done
else
  for u in "${units[@]}"; do
    state=$(systemctl --user is-active "$u" 2>/dev/null || echo "unknown")
    printf '%-50s %s\n' "$u" "$state"
  done
fi
