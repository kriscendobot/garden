#!/bin/bash
# run.sh -- run all pre-dispatch grep-gate tests and report aggregates.
#
# Mirrors the shape of tests/driver/run.sh; each test_*.sh prints its
# own per-suite summary and exits 0 (pass) or non-zero (fail).

set -u

HARNESS_DIR=$(cd "$(dirname "$0")" && pwd)

OVERALL_PASS=0
OVERALL_FAIL=0
FAILING_TESTS=()

for test in "$HARNESS_DIR"/test_*.sh; do
  [ -f "$test" ] || continue
  echo
  echo ">>> Running $(basename "$test")"
  if bash "$test"; then
    OVERALL_PASS=$((OVERALL_PASS+1))
  else
    OVERALL_FAIL=$((OVERALL_FAIL+1))
    FAILING_TESTS+=("$(basename "$test")")
  fi
done

echo
echo "================================================================"
echo "Checks tests: $OVERALL_PASS suite(s) passed, $OVERALL_FAIL failed"
if [ "$OVERALL_FAIL" -gt 0 ]; then
  echo "Failing suites:"
  for t in "${FAILING_TESTS[@]}"; do
    echo "  - $t"
  done
  exit 1
fi
exit 0
