#!/bin/bash
# wall-tree-handler-stub.sh — a gardener job handler whose WHOLE process tree
# resists termination, for handler-wall-bound-regression-test.sh. Every member
# ignores or outlasts SIGTERM, and part of the tree escapes the handler's process
# group:
#   handler  — this script; ignores TERM (timeout --foreground signals only it).
#   same     — a same-group child that ignores TERM.
#   slow     — a same-group child whose TERM trap blocks for 300s before exiting.
#   escaped  — a setsid child (own session + group, unreachable by any group
#              signal to the handler's pgid) that ignores TERM.
#   deep     — a grandchild inside the escaped session that ignores TERM.
# Only the gardener's tree reap (watchdog TERM -> KILL by pid snapshot) can end
# the escaped members before the wall. With GARDEN_WALL_TREE_STOP_TIMEOUT=1 the
# handler also SIGSTOPs its supervising `timeout`, so no `timeout` signal fires at
# all and the bound rests on the independent watchdog alone.
#
# Every member is this script re-run in member mode with GARDEN_WALL_TREE_TOKEN
# in its argv, so the test can find (and clean up) any survivor by /proc cmdline
# without a broad pattern. Records "start <epoch>" then
# "<role> <pid> <pgid> <sid>" lines to GARDEN_WALL_PIDFILE.
set -uo pipefail
self="${BASH_SOURCE[0]}"

record() { # <role> <pidfile>
  printf '%s %s %s %s\n' "$1" "$$" \
    "$(ps -o pgid= -p "$$" | tr -dc '0-9')" "$(ps -o sid= -p "$$" | tr -dc '0-9')" >> "$2"
}

if [ "${1:-}" = "--member" ]; then
  role="$2"; pidfile="$3"; token="$4"
  : "$token"
  case "$role" in
    slow) trap 'sleep 300' TERM ;;
    *) trap '' TERM ;;
  esac
  record "$role" "$pidfile"
  [ "$role" = "escaped" ] && bash "$self" --member deep "$pidfile" "$token" &
  while :; do sleep 1; done
fi

base="${1:?base}"; jobfile="${2:?jobfile}"; report="${3:?report}"
pidfile="${GARDEN_WALL_PIDFILE:?GARDEN_WALL_PIDFILE required}"
token="${GARDEN_WALL_TREE_TOKEN:?GARDEN_WALL_TREE_TOKEN required}"
: "$jobfile"
trap '' TERM
printf 'start %s\n' "$(date +%s)" >> "$pidfile"
printf '# partial report for %s\nwedged past the wall\n' "$base" > "$report"
record handler "$pidfile"

bash "$self" --member same "$pidfile" "$token" &
bash "$self" --member slow "$pidfile" "$token" &
setsid bash "$self" --member escaped "$pidfile" "$token" &

if [ "${GARDEN_WALL_TREE_STOP_TIMEOUT:-0}" = "1" ]; then
  # Test-only: defeat `timeout` entirely (its TERM and --kill-after alarm), the
  # 2026-09-30 overrun shape. Production handlers never set this variable.
  sleep 0.3
  kill -STOP "$PPID"
  printf 'stopped-timeout %s\n' "$PPID" >> "$pidfile"
fi
while :; do sleep 1; done
