#!/bin/bash
# start.sh -- enable and start the configured set of per-feed watchers
# via systemd's user manager.
#
# Reads host-local config from scripts/daemons/config.sh (gitignored;
# copy from config.sh.example). Falls back to an empty configuration
# if config.sh is missing; the script then no-ops with a helpful
# message rather than touching systemd.
#
# Usage:
#   scripts/daemons/start.sh [--enable-only|--start-only]
#
# Default behavior: `daemon-reload`, `enable`, then `start` each
# unit. `--enable-only` skips the start; `--start-only` skips the
# enable (used to relaunch units already enabled at boot).

set -uo pipefail

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
CONFIG_FILE="$SCRIPT_DIR/config.sh"
GARDEN_ROOT=$(cd "$SCRIPT_DIR/../.." && pwd)
# GARDEN_ROOT is exported for downstream wrappers that may consult it;
# the daemons scripts themselves only need SCRIPT_DIR.
export GARDEN_ROOT

GARDEN_WATCHER_FEEDS=()

if [ -f "$CONFIG_FILE" ]; then
  # shellcheck source=/dev/null
  source "$CONFIG_FILE"
else
  echo "start: $CONFIG_FILE not found." >&2
  echo "start: copy scripts/daemons/config.sh.example to scripts/daemons/config.sh and edit." >&2
  exit 0
fi

ENABLE=1
START=1
case "${1:-}" in
  --enable-only) START=0 ;;
  --start-only) ENABLE=0 ;;
  '') ;;
  *) echo "start: unknown flag: $1" >&2; exit 64 ;;
esac

if ! command -v systemctl >/dev/null 2>&1; then
  echo "start: systemctl not available; nothing to do" >&2
  exit 1
fi

# daemon-reload picks up any unit-file changes. Cheap and idempotent.
systemctl --user daemon-reload

watcher_units=()
for feed in "${GARDEN_WATCHER_FEEDS[@]}"; do
  watcher_units+=("garden-watcher@${feed}.service")
done

all_units=("${watcher_units[@]}")
if [ "${#all_units[@]}" -eq 0 ]; then
  echo "start: config has no feeds; nothing to do" >&2
  exit 0
fi

if [ "$ENABLE" -eq 1 ]; then
  echo "start: enabling ${#all_units[@]} unit(s)"
  systemctl --user enable "${all_units[@]}"
fi

if [ "$START" -eq 1 ]; then
  echo "start: starting ${#all_units[@]} unit(s)"
  systemctl --user start "${all_units[@]}"
fi

echo "start: done"
