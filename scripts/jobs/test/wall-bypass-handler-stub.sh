#!/bin/bash
# wall-bypass-handler-stub.sh — a gardener job handler whose tree DEFEATS the
# `timeout` wrapper, reproducing the 2026-09-30T05:36:39Z overrun (rc=124 after
# 3702s against a 2400s budget). It spawns a descendant that IGNORES SIGTERM and
# SIGSTOPs the handler's supervising `timeout` (this handler's parent), so no
# `timeout` alarm or --kill-after escalation can fire. Only gardener.sh's
# independent process-tree watchdog (common.sh handler_wall_watchdog) can end it.
# Records "<start-epoch>" then the descendant pid to GARDEN_WALL_PIDFILE.
set -uo pipefail
base="${1:?base}"; jobfile="${2:?jobfile}"; report="${3:?report}"
pidfile="${GARDEN_WALL_PIDFILE:?GARDEN_WALL_PIDFILE required}"
trap '' TERM
date +%s >> "$pidfile"
printf '# partial report for %s\nwedged past the wall\n' "$base" > "$report"
supervisor=$PPID
bash -c 'trap "" TERM; sleep 0.5; kill -STOP '"$supervisor"'; while :; do sleep 1; done' &
echo "$!" >> "$pidfile"
# Test-only sabotage of the independent watchdog. The timeout wrapper and the
# watchdog are the gardener's two children; from inside the handler, $PPID is the
# former and its sibling is the latter. STOP exercises a late watchdog, while
# KILL exercises disappearance. Production handlers never set this variable.
if [ -n "${GARDEN_WALL_SABOTAGE_WATCHDOG:-}" ]; then
  gardener="$(ps -o ppid= -p "$supervisor" | tr -dc '0-9')"
  watchdog=""
  for _ in $(seq 1 20); do
    watchdog="$(ps -o pid= --ppid "$gardener" 2>/dev/null | awk -v supervisor="$supervisor" '$1 != supervisor { print $1; exit }')"
    [ -n "$watchdog" ] && break
    sleep 0.05
  done
  [ -n "$watchdog" ] && kill -"$GARDEN_WALL_SABOTAGE_WATCHDOG" "$watchdog"
  printf 'watchdog:%s:%s\n' "$watchdog" "$GARDEN_WALL_SABOTAGE_WATCHDOG" >> "$pidfile"
fi
while :; do sleep 1; done
