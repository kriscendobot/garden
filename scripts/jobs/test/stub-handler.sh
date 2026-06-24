#!/bin/bash
# stub-handler.sh — a fast, deterministic gardener job handler for tests.
# Sleeps a short random interval (to make worker processing windows overlap so
# concurrency is observable) and writes a report recording which gardener/host
# did the work and the start/end timestamps.
set -euo pipefail
base="${1:?base}"; jobfile="${2:?jobfile}"; report="${3:?report}"
start="$(date +%s.%N)"
sleep "0.$(( (RANDOM % 6) + 2 ))"   # 0.2–0.7s
end="$(date +%s.%N)"
{
  echo "# report: $base"
  echo "gardener: ${GARDEN_GARDENER_ID:-?}"
  echo "host: ${GARDEN_HOST:-?}"
  echo "start_epoch: $start"
  echo "end_epoch: $end"
  echo "job_first_line: $(head -1 "$jobfile" 2>/dev/null)"
} > "$report"
