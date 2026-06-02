#!/bin/bash
# test_design_only_happy_path.sh -- end-to-end happy path for the
# design-only PR workflow.
#
# The driver is invoked once per state transition (DRIVER_ONESHOT=1
# repeatedly) with the gh stub set up to return the appropriate JSON at
# each step. The test verifies the state file advances through:
#
#   initial -> build -> panel -> verdict -> un-draft -> await-maintainer
#           -> approved+green -> merged
#
# Per-tick stubs:
#   - tick 1: initial -> build       (DRIVER_PR set, so transition is direct)
#   - tick 2: build -> panel          (PR JSON says state=OPEN, isDraft=true)
#   - tick 3: panel -> verdict        (PR JSON includes a kriscendobot review)
#   - tick 4: verdict -> un-draft     (review body contains "verdict: approve")
#   - tick 5: un-draft -> await-maintainer  (deterministic; gh pr ready stub no-ops)
#   - tick 6: await-maintainer -> approved+green  (PR JSON includes APPROVED review)
#   - tick 7: approved+green -> merged  (PR JSON state=MERGED)

set -uo pipefail

HARNESS_DIR=$(cd "$(dirname "$0")" && pwd)
source "$HARNESS_DIR/lib/mock-garden.sh"

PASS=0
FAIL=0
ok() { PASS=$((PASS+1)); }
ko() { FAIL=$((FAIL+1)); }
run_assert() { if "$@"; then ok; else ko; fi; }

echo "=== test_design_only_happy_path ==="

mock_garden_setup

# Common env for every tick.
export DRIVER_PR="mock/repo#42"
export DRIVER_WORKFLOW="design-only-pr"
export DRIVER_ONESHOT=1
export DRIVER_TICK_SECONDS=0

# Stub post_job so the driver does not try to git push into our mock
# journal (which has no `origin`).
stub_post_job_file="$MOCK_TMP/post-job-stub.sh"
cat > "$stub_post_job_file" <<'EOF'
#!/bin/bash
echo "jobs/open/stubbed--$1--$2.md"
exit 0
EOF
chmod +x "$stub_post_job_file"
export POST_JOB_STUB="$stub_post_job_file"

# Stub the un-draft action so it does not call real gh.
stub_un_draft_file="$MOCK_TMP/un-draft-stub.sh"
cat > "$stub_un_draft_file" <<'EOF'
#!/bin/bash
echo "un-draft stub called for: $1" >> "${MOCK_LOGS:-/tmp}/un-draft.log"
exit 0
EOF
chmod +x "$stub_un_draft_file"
export UN_DRAFT_STUB="$stub_un_draft_file"

run_driver() {
  bash "$MOCK_GARDEN_ROOT/scripts/driver/driver.sh" 1
}

read_state_field() {
  local field=$1
  local state_file="$MOCK_GARDEN_JOURNAL/drivers/mock-host/1.md"
  # Use sed so we don't split on internal colons (e.g. "solicitor:design-panel").
  sed -n "s/^$field: //p" "$state_file" 2>/dev/null | head -1
}

# --- tick 1: initial -> build ----------------------------------
mock_garden_set_pr_json '{"state":"OPEN","isDraft":true,"reviews":[]}'
set +e; run_driver >/dev/null 2>&1; rc=$?; set -e
run_assert mock_garden_assert_eq "tick 1 rc=0" 0 "$rc"
run_assert mock_garden_assert_eq "tick 1 -> state=build" "build" "$(read_state_field state)"

# --- tick 2: build -> panel ------------------------------------
mock_garden_set_pr_json '{"state":"OPEN","isDraft":true,"reviews":[]}'
set +e; run_driver >/dev/null 2>&1; rc=$?; set -e
run_assert mock_garden_assert_eq "tick 2 rc=0" 0 "$rc"
run_assert mock_garden_assert_eq "tick 2 -> state=panel" "panel" "$(read_state_field state)"
run_assert mock_garden_assert_eq "tick 2 -> awaits=solicitor:design-panel" "solicitor:design-panel" "$(read_state_field awaits)"

# --- tick 3: panel -> verdict ----------------------------------
# Need a PR JSON whose grep for "kriscendobot" matches (the predicate
# uses a substring grep on the raw JSON for Phase 2 simplicity).
mock_garden_set_pr_json '{"state":"OPEN","isDraft":true,"reviews":[{"author":{"login":"kriscendobot"},"body":"verdict: pending classification"}]}'
set +e; run_driver >/dev/null 2>&1; rc=$?; set -e
run_assert mock_garden_assert_eq "tick 3 rc=0" 0 "$rc"
run_assert mock_garden_assert_eq "tick 3 -> state=verdict" "verdict" "$(read_state_field state)"

# --- tick 4: verdict -> un-draft -------------------------------
# Review body contains the deterministic "verdict: approve" marker.
mock_garden_set_pr_json '{"state":"OPEN","isDraft":true,"reviews":[{"author":{"login":"kriscendobot"},"body":"verdict: approve"}]}'
set +e; run_driver >/dev/null 2>&1; rc=$?; set -e
run_assert mock_garden_assert_eq "tick 4 rc=0" 0 "$rc"
run_assert mock_garden_assert_eq "tick 4 -> state=un-draft" "un-draft" "$(read_state_field state)"

# --- tick 5: un-draft -> await-maintainer ----------------------
mock_garden_set_pr_json '{"state":"OPEN","isDraft":false,"reviews":[]}'
set +e; run_driver >/dev/null 2>&1; rc=$?; set -e
run_assert mock_garden_assert_eq "tick 5 rc=0" 0 "$rc"
run_assert mock_garden_assert_eq "tick 5 -> state=await-maintainer" "await-maintainer" "$(read_state_field state)"

# Verify un-draft stub was called.
run_assert mock_garden_assert_file_contains "un-draft stub called for PR id" "mock/repo#42" "$MOCK_LOGS/un-draft.log"

# --- tick 6: await-maintainer -> approved+green ----------------
mock_garden_set_pr_json '{"state":"OPEN","isDraft":false,"reviews":[{"author":{"login":"kriskowal"},"state":"APPROVED","body":"lgtm"}]}'
set +e; run_driver >/dev/null 2>&1; rc=$?; set -e
run_assert mock_garden_assert_eq "tick 6 rc=0" 0 "$rc"
run_assert mock_garden_assert_eq "tick 6 -> state=approved+green" "approved+green" "$(read_state_field state)"

# --- tick 7: approved+green -> merged --------------------------
mock_garden_set_pr_json '{"state":"MERGED","isDraft":false,"reviews":[]}'
set +e; run_driver >/dev/null 2>&1; rc=$?; set -e
run_assert mock_garden_assert_eq "tick 7 rc=0 (terminal exit)" 0 "$rc"
run_assert mock_garden_assert_eq "tick 7 -> state=merged" "merged" "$(read_state_field state)"

# Verify no gardener-inbox failure section was written. The whole
# happy path should be silent on the gardener inbox.
inbox_file="$MOCK_GARDEN_JOURNAL/inboxes/mock-host/gardener.md"
if [ -f "$inbox_file" ]; then
  if grep -q "driver lane 1" "$inbox_file"; then
    echo "  FAIL: gardener inbox has a section for lane 1 (happy path should be silent)"
    ko
  else
    ok
  fi
else
  # File never created: also OK for a clean happy path.
  ok
fi

mock_garden_teardown

echo "=== test_design_only_happy_path: $PASS passed, $FAIL failed ==="
if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
exit 0
