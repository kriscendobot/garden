#!/bin/bash
# timeout-handler-stub.sh — a gardener job handler that flushes NON-EMPTY output
# and then HANGS forever, emulating a wedged/runaway handler (network hang,
# infinite tool loop) with no upper runtime bound of its own. gardener.sh wraps
# the handler in `timeout --signal=TERM "$GARDEN_HANDLER_TIMEOUT" ...`, so a short
# GARDEN_HANDLER_TIMEOUT makes the wrapper fire and the handler exit rc=124 with a
# non-empty $capture. Used by timeout-classifier-test.sh to prove (a) the wrapper
# bounds a hung handler and (b) the classifier treats rc=124 as a REAL failure
# (escalated now), NOT a transient signal-kill (143/130/137).
set -uo pipefail
base="${1:?base}"; jobfile="${2:?jobfile}"; report="${3:?report}"
# Flush non-empty output (stdout → folded into $capture by gardener.sh; $report
# tail folded too) so the classifier sees a NON-EMPTY $capture when rc=124 lands.
echo "stub handler for $base: started working, then hung past GARDEN_HANDLER_TIMEOUT"
printf '# partial report for %s\nwork in progress when the timeout fired\n' "$base" > "$report"
# Hang. The timeout wrapper sends SIGTERM at expiry; sleep dies, timeout reports 124.
while :; do sleep 1; done
