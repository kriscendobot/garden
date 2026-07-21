#!/bin/bash
# orphan-tree-handler-stub.sh — a gardener job handler that SPAWNS A DESCENDANT
# PROCESS TREE (emulating the `claude -p` → node → endor/endor-xst tree of the
# 2026-07-20/21 leak) and then HANGS forever, so gardener.sh's `timeout` wrapper
# fires at a tiny GARDEN_HANDLER_TIMEOUT (rc=124). It records every descendant's
# PID to GARDEN_ORPHAN_PIDFILE so handler-orphan-reap-test.sh can assert, after the
# gardener returns, that the whole tree was swept (ZERO orphans) by the process-group
# reaper (common.sh reap_process_group), not left running headless.
#
# The tree is deliberately MULTI-LEVEL and does NOT setsid — the ordinary
# non-detaching descendant tree the group sweep is the structural backstop for.
set -uo pipefail
base="${1:?base}"; jobfile="${2:?jobfile}"; report="${3:?report}"
pidfile="${GARDEN_ORPHAN_PIDFILE:?GARDEN_ORPHAN_PIDFILE required}"

echo "orphan-tree stub for $base: spawning a descendant tree, then hanging past the wall"
printf '# partial report for %s\nspawned a child tree, then hung\n' "$base" > "$report"

# A direct child that itself spawns a grandchild — a small tree, all sharing the
# handler's process group (no setsid), all reparented to init if left unreaped.
bash -c '
  echo "$$" >> "'"$pidfile"'"        # the grandchild-parent
  sleep 3600 &                        # a grandchild
  echo "$!" >> "'"$pidfile"'"
  sleep 3600                          # this level blocks
' &
echo "$!" >> "$pidfile"               # the direct child

sleep 3600 &                          # a second direct child
echo "$!" >> "$pidfile"

# The handler itself hangs; timeout SIGTERMs it at the wall (rc=124). Under
# --foreground, timeout signals ONLY this direct handler, so the tree above would
# survive were it not for gardener.sh's post-return group sweep.
while :; do sleep 1; done
