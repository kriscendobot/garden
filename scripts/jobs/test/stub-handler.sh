#!/bin/bash
# stub-handler.sh — a fast, deterministic gardener job handler for tests.
# Sleeps a short random interval (to make worker processing windows overlap so
# concurrency is observable) and writes a report recording which gardener/host
# did the work and the start/end timestamps. Models a GENUINE completion: it
# emits the completion sentinel gardener.sh gates doin→tada on.
set -euo pipefail
base="${1:?base}"; jobfile="${2:?jobfile}"; report="${3:?report}"
start="$(date +%s.%N)"
sleep "0.$(( (RANDOM % 6) + 2 ))"   # 0.2–0.7s
end="$(date +%s.%N)"
{
  echo "# report: $base"
  echo "gardener: ${GARDEN_GARDENER_ID:-?}"
  echo "host: ${GARDEN:-?}"
  echo "start_epoch: $start"
  echo "end_epoch: $end"
  echo "job_first_line: $(head -1 "$jobfile" 2>/dev/null)"
} > "$report"
# Simulate a GENUINE completion: emit the deterministic completion signal
# gardener.sh gates doin→tada on (common.sh § job completion signal). A stub that
# OMITS this models an exit-0-unsatisfying run and would be requeued instead.
[ -n "${GARDEN_COMPLETION_SENTINEL:-}" ] && : > "$GARDEN_COMPLETION_SENTINEL"
