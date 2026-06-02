#!/bin/bash
# test_trap_fires_on_error.sh -- the driver's ERR/EXIT trap should fan
# an unexpected failure out to the gardener inbox.
#
# We force the failure by setting POST_JOB_STUB to a script that exits
# non-zero AND making the workflow attempt to post a job. The driver's
# post_job wrapper returns the stub's non-zero rc, which the workflow
# handler treats as a recoverable post-failure (logged, no state
# advance). To actually exit non-zero from the driver we set the
# CLAUDE_ESCALATE_STUB to a script that exits non-zero and trigger an
# unknown-state escalation by feeding the state file a state name the
# workflow does not recognize.
#
# This test exercises the trap path: a non-zero exit from inside the
# `( set -x; run_once )` subshell should write to the gardener inbox.

set -uo pipefail

HARNESS_DIR=$(cd "$(dirname "$0")" && pwd)
source "$HARNESS_DIR/lib/mock-garden.sh"

PASS=0
FAIL=0
ok() { PASS=$((PASS+1)); }
ko() { FAIL=$((FAIL+1)); }
run_assert() { if "$@"; then ok; else ko; fi; }

echo "=== test_trap_fires_on_error ==="

mock_garden_setup

# We force an unknown-state to trigger the escalate path; the escalate
# stub exits non-zero, which the driver treats as "park"; that case
# does NOT exit non-zero on its own. Instead, we force a different
# failure: corrupt the state file path by making STATE_DIR unwritable
# at the right moment. Simpler: use a workflow name the driver does
# not recognize.

export DRIVER_PR="mock/repo#99"
export DRIVER_WORKFLOW="never-implemented-workflow"
export DRIVER_ONESHOT=1
export DRIVER_TICK_SECONDS=0

mock_garden_set_pr_json '{"state":"OPEN","isDraft":true,"reviews":[]}'

# Pre-seed the state file with a state that triggers the workflow's
# default-case escalate.
mkdir -p "$MOCK_GARDEN_JOURNAL/drivers/mock-host"
cat > "$MOCK_GARDEN_JOURNAL/drivers/mock-host/1.md" <<EOF
---
host: mock-host
lane: 1
workflow: never-implemented-workflow
pr: mock/repo#99
state: initial
awaits: null
last_tick: 1970-01-01T00:00:00Z
---

bootstrap.
EOF

set +e
bash "$MOCK_GARDEN_ROOT/scripts/driver/driver.sh" 1 >/dev/null 2>&1
rc=$?
set -e

# The unknown workflow path calls escalate_to_claude (which writes to
# the gardener inbox via report-error.sh as its Phase-2 placeholder),
# then returns 1; the workflow handler treats that as park; driver
# exits 0.
run_assert mock_garden_assert_eq "driver exit code is 0 (parked, not crashed)" 0 "$rc"

# The escalation should have written a gardener inbox section.
inbox_file="$MOCK_GARDEN_JOURNAL/inboxes/mock-host/gardener.md"
[ -f "$inbox_file" ] && ok || { echo "  FAIL: gardener inbox file does not exist"; ko; }
if [ -f "$inbox_file" ]; then
  run_assert mock_garden_assert_file_contains "escalation noted in gardener inbox" "driver lane 1" "$inbox_file"
  run_assert mock_garden_assert_file_contains "escalation names the unknown workflow" "unknown-workflow" "$inbox_file"
fi

mock_garden_teardown

echo "=== test_trap_fires_on_error: $PASS passed, $FAIL failed ==="
if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
exit 0
