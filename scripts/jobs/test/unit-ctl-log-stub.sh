#!/bin/bash
# unit-ctl-log-stub.sh — a GARDEN_UNIT_CTL mock that records every call to
# $GARDEN_UNIT_CTL_LOG (one line per invocation, the args verbatim) so a test can
# assert on exactly what unit_ctl was asked to do. Optional failure injection:
# GARDEN_UNIT_CTL_FAIL=1 makes every call exit non-zero (to prove foreman_kick's
# best-effort `|| true` never propagates a failure to its caller).
set -euo pipefail
echo "$*" >> "${GARDEN_UNIT_CTL_LOG:?set GARDEN_UNIT_CTL_LOG}"
[ "${GARDEN_UNIT_CTL_FAIL:-0}" = "1" ] && exit 1
exit 0
