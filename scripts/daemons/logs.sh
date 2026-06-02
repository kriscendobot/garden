#!/bin/bash
# logs.sh -- tail systemd journal output for the configured set of
# driver lanes and per-feed watchers.
#
# Wraps `journalctl --user-unit <pattern>` with sensible defaults.
# Two filters narrow to a single unit:
#   --lane <N>     only the driver lane N
#   --feed <slug>  only the watcher for feed <slug>
#
# Default: follow (--follow) the union of all driver and watcher
# units' logs since boot.
#
# Usage:
#   scripts/daemons/logs.sh [--lane <N>|--feed <slug>] [--no-follow] [-- <journalctl-extra-args>...]

set -uo pipefail

FILTER_UNIT=""
FOLLOW=1
EXTRA_ARGS=()

while [ "$#" -gt 0 ]; do
  case "$1" in
    --lane)
      shift
      if [ "$#" -lt 1 ]; then echo "logs: --lane needs a value" >&2; exit 64; fi
      FILTER_UNIT="garden-driver@${1}.service"
      shift
      ;;
    --feed)
      shift
      if [ "$#" -lt 1 ]; then echo "logs: --feed needs a value" >&2; exit 64; fi
      FILTER_UNIT="garden-watcher@${1}.service"
      shift
      ;;
    --no-follow)
      FOLLOW=0
      shift
      ;;
    --)
      shift
      while [ "$#" -gt 0 ]; do
        EXTRA_ARGS+=("$1")
        shift
      done
      ;;
    *)
      echo "logs: unknown flag: $1" >&2
      exit 64
      ;;
  esac
done

if ! command -v journalctl >/dev/null 2>&1; then
  echo "logs: journalctl not available; nothing to do" >&2
  exit 1
fi

args=(--user)
if [ -n "$FILTER_UNIT" ]; then
  args+=(--user-unit "$FILTER_UNIT")
else
  args+=(--user-unit 'garden-driver@*.service' --user-unit 'garden-watcher@*.service')
fi
if [ "$FOLLOW" -eq 1 ]; then
  args+=(--follow)
fi
args+=("${EXTRA_ARGS[@]}")

exec journalctl "${args[@]}"
