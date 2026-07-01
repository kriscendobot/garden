#!/bin/bash
# budget-sleep-complete-handler-stub.sh — a gardener job handler that sleeps
# GARDEN_STUB_SLEEP seconds, writes a report, then (when GARDEN_COMPLETION_SENTINEL
# is set by gardener.sh) writes the completion sentinel and exits 0. Used by
# handler-budget-test.sh to prove a declared `handler-timeout:` budget outlives the
# default: with the small default the sleep is SIGTERM-killed (rc=124, no
# completion); with the honored budget the sleep finishes and the job completes.
set -uo pipefail
base="${1:?base}"; jobfile="${2:?jobfile}"; report="${3:?report}"
sleep "${GARDEN_STUB_SLEEP:-0}"
printf '# report for %s\nstub handler ran\n' "$base" > "$report"
[ -n "${GARDEN_COMPLETION_SENTINEL:-}" ] && : > "$GARDEN_COMPLETION_SENTINEL"
exit 0
