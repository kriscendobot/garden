#!/bin/bash
# follow-up-outage-stub.sh — a follow-up handler that fails the way an OUTAGE
# fails, not the way a wedged digest fails. Drives follow-up.sh's
# not-attributable classification (common.sh § the transient handler exit):
#   STUB_FOLLOWUP_OUT   text to emit on stdout (e.g. a transient claude signature)
#   STUB_FOLLOWUP_RC    exit code (default 75 = EX_TEMPFAIL, the explicit signal)
set -uo pipefail
[ -n "${STUB_FOLLOWUP_OUT:-}" ] && printf '%s\n' "$STUB_FOLLOWUP_OUT"
exit "${STUB_FOLLOWUP_RC:-75}"
