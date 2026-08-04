#!/bin/bash
# orphan-tree-selfexit-handler-stub.sh — a gardener job handler that SPAWNS A
# DESCENDANT TREE and then EXITS ON ITS OWN with a non-zero, non-timeout code
# (emulating a `claude -p` that crashed / hit a quota cut mid-run and returned,
# leaving its endor/endor-xst/node tree running). This is the DOOM / requeue-
# exhaustion path of the 2026-07-20/21 leak: NO `timeout` kill fires (the handler
# returned before the wall), so the OLD gardener never touched the spawned tree and
# it survived headless. gardener.sh's post-return process-group sweep now reaps it.
#
# It records every descendant PID to GARDEN_ORPHAN_PIDFILE so the test can assert
# ZERO survivors after the gardener returns.
set -uo pipefail
base="${1:?base}"; jobfile="${2:?jobfile}"; report="${3:?report}"
pidfile="${GARDEN_ORPHAN_PIDFILE:?GARDEN_ORPHAN_PIDFILE required}"

echo "orphan-tree self-exit stub for $base: spawning a descendant tree, then self-exiting rc=7"
printf '# partial report for %s\nspawned a child tree, then self-exited\n' "$base" > "$report"

bash -c '
  echo "$$" >> "'"$pidfile"'"
  sleep 3600 &
  echo "$!" >> "'"$pidfile"'"
  sleep 3600
' &
echo "$!" >> "$pidfile"

sleep 3600 &
echo "$!" >> "$pidfile"

# Give the tree a moment to record its pids, then die on our own — no timeout kill.
sleep 1
exit 7
