#!/bin/bash
# completion-signal-handler-stub.sh — a gardener job handler that lets a test
# drive the DETERMINISTIC completion signal (common.sh § job completion signal)
# independently of the exit code, to exercise gardener.sh's doin→tada gate.
#
# Knobs (env):
#   GARDEN_STUB_RC          exit code (default 0)
#   GARDEN_STUB_SIGNAL      1 → write the completion sentinel (a genuine
#                           completion); anything else → do NOT (an exit-0-
#                           unsatisfying / killed / errored run).
#   GARDEN_STUB_CAPTURE     text emitted to stdout+stderr (folded into $capture by
#                           gardener.sh) so the non-zero classifier can see an API/
#                           rate-limit/quota transient signature.
#
# Used by completion-signal-test.sh.
set -uo pipefail
base="${1:?base}"; jobfile="${2:?jobfile}"; report="${3:?report}"

printf '# report for %s\nstub handler ran\n' "$base" > "$report"
[ -n "${GARDEN_STUB_CAPTURE:-}" ] && { echo "$GARDEN_STUB_CAPTURE"; echo "$GARDEN_STUB_CAPTURE" >&2; }

# Emit the completion sentinel ONLY when told to model a genuine completion.
if [ "${GARDEN_STUB_SIGNAL:-0}" = "1" ] && [ -n "${GARDEN_COMPLETION_SENTINEL:-}" ]; then
  : > "$GARDEN_COMPLETION_SENTINEL"
fi

exit "${GARDEN_STUB_RC:-0}"
