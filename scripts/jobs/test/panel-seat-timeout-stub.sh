#!/bin/bash
# Deterministic seat hook for panel-seat-timeout-test.sh. Every invocation records
# its attempt and stderr before either hanging or returning a healthy verdict.
set -uo pipefail
n=$(cat "$SEAT_COUNTER" 2>/dev/null || echo 0)
n=$((n + 1))
echo "$n" > "$SEAT_COUNTER"
echo "seat stderr attempt $n" >&2
if [ "$n" -lt "${SEAT_SUCCEED_AT:-999999}" ]; then
  sleep "${SEAT_HANG_SECONDS:-30}"
fi
printf '### seat verdict\nVerdict: approve\nFindings: none\n'
