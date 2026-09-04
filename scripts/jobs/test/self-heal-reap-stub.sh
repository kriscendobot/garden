#!/bin/bash
# self-heal-reap-stub.sh — a self-heal responder (handlers/self-heal-claude.sh
# signature) that SPAWNS A DESCENDANT PROCESS TREE (emulating the responder's
# `claude -p` → node subprocess tree) recording every pid to SELF_HEAL_REAP_PIDFILE,
# then HANGS forever. It does NOT setsid — it is the ordinary non-detaching tree
# self-heal-run.sh's process-group sweep is the backstop for.
#
# Used by run-test.sh SUBTEST 21 to prove self-heal-run.sh reaps the responder's
# WHOLE process group — so a `claude` grandchild can never outlive the wrapper in
# the unit cgroup — on BOTH the fired-responder-timeout path and a stop signal to
# the wrapper mid-diagnosis.
#
# Invoked as: self-heal-reap-stub.sh <sha> <clone-dir> <context> <rc> [work-id] [role]
set -uo pipefail
pidfile="${SELF_HEAL_REAP_PIDFILE:?SELF_HEAL_REAP_PIDFILE required}"

# A direct child that itself spawns a grandchild — a small multi-level tree, all
# sharing the responder's process group (no setsid).
bash -c '
  echo "$$" >> "'"$pidfile"'"        # the grandchild-parent
  sleep 3600 &                        # a grandchild
  echo "$!" >> "'"$pidfile"'"
  sleep 3600                          # this level blocks
' &
echo "$!" >> "$pidfile"               # the direct child

sleep 3600 &                          # a second direct child
echo "$!" >> "$pidfile"

# The responder itself hangs. Either a fired SELF_HEAL_RESPONDER_TIMEOUT (which
# --foreground SIGTERMs only this direct process) or a stop signal to the wrapper
# ends it; the spawned tree above survives EITHER only if the wrapper fails to
# sweep the group.
while :; do sleep 1; done
