#!/bin/bash
# stop.sh -- stop the configured set of driver lanes and per-feed
# watchers cleanly via systemd's user manager.
#
# Reads host-local config from scripts/daemons/config.sh. Driver
# lanes drain their currently-claimed job first (systemd sends
# SIGTERM and waits for the unit's TimeoutStopSec). Watchers stop on
# the next polling cycle boundary.
#
# Usage:
#   scripts/daemons/stop.sh [--disable-too]
#
# Default behavior: stop the units but leave them enabled (so the
# next host boot brings them back up). `--disable-too` also disables
# the units.

set -uo pipefail

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
CONFIG_FILE="$SCRIPT_DIR/config.sh"

GARDEN_DRIVER_LANES=()
GARDEN_WATCHER_FEEDS=()

if [ -f "$CONFIG_FILE" ]; then
  # shellcheck source=/dev/null
  source "$CONFIG_FILE"
else
  echo "stop: $CONFIG_FILE not found; nothing to stop" >&2
  exit 0
fi

DISABLE=0
case "${1:-}" in
  --disable-too) DISABLE=1 ;;
  '') ;;
  *) echo "stop: unknown flag: $1" >&2; exit 64 ;;
esac

if ! command -v systemctl >/dev/null 2>&1; then
  echo "stop: systemctl not available; nothing to do" >&2
  exit 1
fi

driver_units=()
for lane in "${GARDEN_DRIVER_LANES[@]}"; do
  driver_units+=("garden-driver@${lane}.service")
done

watcher_units=()
for feed in "${GARDEN_WATCHER_FEEDS[@]}"; do
  watcher_units+=("garden-watcher@${feed}.service")
done

all_units=("${driver_units[@]}" "${watcher_units[@]}")
if [ "${#all_units[@]}" -eq 0 ]; then
  echo "stop: config has no lanes or feeds; nothing to stop" >&2
  exit 0
fi

echo "stop: stopping ${#all_units[@]} unit(s)"
systemctl --user stop "${all_units[@]}" || true

if [ "$DISABLE" -eq 1 ]; then
  echo "stop: disabling ${#all_units[@]} unit(s)"
  systemctl --user disable "${all_units[@]}" || true
fi

echo "stop: done"
