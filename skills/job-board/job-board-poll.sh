#!/bin/bash
# job-board-poll.sh — long-lived poll daemon for the journal's job board.
#
# Usage:
#   job-board-poll.sh [<cadence-seconds>]
#
# Polls `git fetch origin journal` and `ls journal/jobs/open/` on the named
# cadence (default 30). Writes one line per state change to stdout:
#
#   [HH:MM:SS] NEW jobs/open/<filename>     # appeared since the prior tick
#   [HH:MM:SS] GONE jobs/open/<filename>    # disappeared (claimed by someone)
#
# The Monitor watching the log only needs the `NEW` lines to know when to
# wake the consumer. `GONE` is informational; the consumer may use it to
# avoid stale claim attempts.
#
# State (per-host):
#   /tmp/garden-jobs-<host>.state           # the prior tick's `ls` output
#
# PID + log conventions (consistent with the standing monitors):
#   /tmp/garden-jobs.pid
#   /tmp/garden-jobs.log
#   /tmp/garden-jobs.err

set -uo pipefail

CADENCE=${1:-30}

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
GARDEN_ROOT=$(cd "$SCRIPT_DIR/../.." && pwd)
JRN="$GARDEN_ROOT/journal"

HOST=$(hostname -s)
STATE="/tmp/garden-jobs-${HOST}.state"

trap 'echo "[$(date -u +%H:%M:%S)] job-board-poll stopping pid=$$"; exit 0' INT TERM

echo "[$(date -u +%H:%M:%S)] job-board-poll starting garden=$GARDEN_ROOT cadence=${CADENCE}s pid=$$"

touch "$STATE"

while true; do
  git -C "$JRN" fetch --quiet origin journal 2>/dev/null || true
  # The fetch above only updates origin/journal; reset the worktree so
  # `ls jobs/open/` reflects the latest published state.
  git -C "$JRN" reset --hard origin/journal >/dev/null 2>&1 || true

  CUR=$(ls "$JRN/jobs/open/" 2>/dev/null | sort)
  PREV=$(cat "$STATE" 2>/dev/null || true)
  if [ "$CUR" != "$PREV" ]; then
    # NEW = in CUR but not in PREV.
    comm -23 <(echo "$CUR") <(echo "$PREV") | while IFS= read -r f; do
      [ -n "$f" ] && echo "[$(date -u +%H:%M:%S)] NEW jobs/open/$f"
    done
    # GONE = in PREV but not in CUR.
    comm -13 <(echo "$CUR") <(echo "$PREV") | while IFS= read -r f; do
      [ -n "$f" ] && echo "[$(date -u +%H:%M:%S)] GONE jobs/open/$f"
    done
    echo "$CUR" > "$STATE"
  fi
  sleep "$CADENCE"
done
