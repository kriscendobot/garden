#!/bin/bash
# wall-bypass-handler-stub.sh — a gardener job handler whose tree DEFEATS the
# `timeout` wrapper, reproducing the 2026-09-30T05:36:39Z overrun (rc=124 after
# 3702s against a 2400s budget). It spawns a descendant that IGNORES SIGTERM and
# SIGSTOPs the handler's supervising `timeout` (this handler's parent), so no
# `timeout` alarm or --kill-after escalation can fire. Only gardener.sh's
# independent process-group watchdog (common.sh handler_wall_watchdog) can end it.
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
while :; do sleep 1; done
