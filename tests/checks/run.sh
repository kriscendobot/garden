#!/bin/bash
# run.sh -- run all pre-dispatch grep-gate tests and report aggregates.
#
# Each test_*.sh prints its own per-suite summary and exits 0 (pass)
# or non-zero (fail); this runner aggregates the results.

set -u

HARNESS_DIR=$(cd "$(dirname "$0")" && pwd)

# Test-context sentinel, exported from this ONE place so every suite below inherits
# it (mirrors scripts/jobs/test/run-test.sh). common.sh's
# guard_no_production_push_in_test then refuses any push whose remote resolves to the
# real garden journal, and fail-closed sinks (identity-drift-guard.sh's emit_sink)
# refuse to reach the real bus — even if a suite forgets to isolate its remote or to
# capture a sink. Backstop for the 2026-07-11 and 2026-07-28 journal-leak incidents.
export GARDEN_TEST=1

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
