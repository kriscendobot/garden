#!/bin/bash
# handler-ran-marker-stub.sh — a gardener job handler that only records that it
# ran (touches GARDEN_STUB_RAN) and completes. claim-stop-race-test.sh asserts it
# is never invoked.
set -uo pipefail
: > "${GARDEN_STUB_RAN:?}"
printf '# report for %s\n' "${1:?base}" > "${3:?report}"
[ -n "${GARDEN_COMPLETION_SENTINEL:-}" ] && : > "$GARDEN_COMPLETION_SENTINEL"
exit 0
