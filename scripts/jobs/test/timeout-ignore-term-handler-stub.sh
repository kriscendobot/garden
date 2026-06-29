#!/bin/bash
# timeout-ignore-term-handler-stub.sh — a gardener job handler that IGNORES SIGTERM
# and then HANGS forever, emulating a hard deadlock or a child wedged in an
# uninterruptible state. gardener.sh wraps the handler in
# `timeout --signal=TERM --kill-after="$GARDEN_HANDLER_KILL_AFTER" "$GARDEN_HANDLER_TIMEOUT" ...`.
# Because this handler swallows the SIGTERM at expiry, the bare timeout would block
# forever (wedging the gardener worker); --kill-after escalates to an unconditional
# SIGKILL after the grace, so the handler is killed and `timeout` surfaces rc=137.
# Used by timeout-classifier-test.sh to prove the worker is GUARANTEED to return
# (no wedge) and that rc=137 is classified as an external-kill TRANSIENT.
set -uo pipefail
base="${1:?base}"; jobfile="${2:?jobfile}"; report="${3:?report}"
trap '' TERM   # swallow SIGTERM: only the --kill-after SIGKILL can stop us
echo "stub handler for $base: ignoring SIGTERM, hung past GARDEN_HANDLER_TIMEOUT"
printf '# partial report for %s\nwedged, ignoring SIGTERM\n' "$base" > "$report"
# Hang. The timeout wrapper sends SIGTERM at expiry (swallowed), then SIGKILL after
# GARDEN_HANDLER_KILL_AFTER; the KILL cannot be trapped, so timeout reports rc=137.
while :; do sleep 1; done
