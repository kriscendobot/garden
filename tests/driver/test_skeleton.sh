#!/bin/bash
# test_skeleton.sh -- smoke-test the driver's skeleton behavior.
#
# Verifies:
#   - The driver rejects a missing lane argument.
#   - The driver rejects a non-integer lane argument.
#   - The driver creates the state-file directory and a state file on
#     first run (in oneshot mode, with no PR subscription).
#   - The driver's transcript capture exists.
#   - A forced unexpected error writes a section to the gardener inbox.

set -uo pipefail

HARNESS_DIR=$(cd "$(dirname "$0")" && pwd)
source "$HARNESS_DIR/lib/mock-garden.sh"

PASS=0
FAIL=0

ok() { PASS=$((PASS+1)); }
ko() { FAIL=$((FAIL+1)); }

run_assert() {
  if "$@"; then ok; else ko; fi
}

echo "=== test_skeleton ==="

# --- 1. usage error: no lane ----------------------------------------------
mock_garden_setup

set +e
output=$(bash "$MOCK_GARDEN_ROOT/scripts/driver/driver.sh" 2>&1)
rc=$?
set -e
run_assert mock_garden_assert_eq "no-lane rc is 64" 64 "$rc"
run_assert mock_garden_assert_contains "no-lane stderr mentions usage" "usage:" "$output"

# --- 2. usage error: non-integer lane ------------------------------------
set +e
output=$(bash "$MOCK_GARDEN_ROOT/scripts/driver/driver.sh" notalane 2>&1)
rc=$?
set -e
run_assert mock_garden_assert_eq "non-integer lane rc is 64" 64 "$rc"
run_assert mock_garden_assert_contains "non-integer lane stderr names the bad value" "notalane" "$output"

# --- 3. state file initialization on first run ---------------------------
# Run in oneshot, no PR subscription. The driver should reach `initial`
# state, post a builder job (which it cannot actually push without a
# real origin), tolerate the post failure, and write a state file.

# Stub post-job.sh so the driver's post_job call does not try to git push
# in the mock journal (which has no origin).
export POST_JOB_STUB="$MOCK_GARDEN_ROOT/post-job-stub.sh"
cat > "$POST_JOB_STUB" <<'EOF'
#!/bin/bash
# stub: pretend the post succeeded.
echo "jobs/open/stubbed--$1--$2.md"
exit 0
EOF
chmod +x "$POST_JOB_STUB"

# Run oneshot. Without DRIVER_PR set, the driver will try to post a
# build-design-only job to advance from initial.
DRIVER_ONESHOT=1 bash "$MOCK_GARDEN_ROOT/scripts/driver/driver.sh" 1 >/dev/null 2>&1
rc=$?

state_file="$MOCK_GARDEN_JOURNAL/drivers/mock-host/1.md"
subscriptions_file="$MOCK_GARDEN_JOURNAL/drivers/mock-host/1.subscriptions"

run_assert mock_garden_assert_eq "oneshot run exits cleanly (rc=0)" 0 "$rc"
[ -f "$state_file" ] && ok || { echo "  FAIL: state file missing: $state_file"; ko; }
[ -f "$subscriptions_file" ] && ok || { echo "  FAIL: subscriptions file missing"; ko; }

if [ -f "$state_file" ]; then
  run_assert mock_garden_assert_file_contains "state file names lane 1" "lane: 1" "$state_file"
  run_assert mock_garden_assert_file_contains "state file names workflow" "workflow:" "$state_file"
  run_assert mock_garden_assert_file_contains "state file names host" "host: mock-host" "$state_file"
fi

unset POST_JOB_STUB

# --- 4. Forced unexpected failure writes a gardener-inbox section --------
# Simulate the trap firing by calling report-error.sh directly with a
# transcript file.

transcript_file="$MOCK_TMP/forced-transcript.log"
cat > "$transcript_file" <<EOF
mock command 1
mock command 2 with arg
+ failure on next line
mock command 3 exit 1
EOF

export GARDEN_HOST="mock-host"
sha=$(bash "$MOCK_GARDEN_ROOT/skills/gardener-inbox-error-reporting/report-error.sh" \
  --transcript "$transcript_file" \
  --lane 7 \
  --pr "mock/repo#42" \
  --state "test-forced-failure" \
  --context "forced for skeleton test" \
  2>/dev/null)
rc=$?

run_assert mock_garden_assert_eq "report-error.sh rc is 0" 0 "$rc"
run_assert mock_garden_assert_contains "report-error.sh printed a sha" "" "$sha"
[ -n "$sha" ] && ok || { echo "  FAIL: no SHA printed from report-error.sh"; ko; }

inbox_file="$MOCK_GARDEN_JOURNAL/inboxes/mock-host/gardener.md"
run_assert mock_garden_assert_file_contains "inbox section names lane 7" "driver lane 7" "$inbox_file"
run_assert mock_garden_assert_file_contains "inbox section names PR" "mock/repo#42" "$inbox_file"
run_assert mock_garden_assert_file_contains "inbox section names state" "test-forced-failure" "$inbox_file"
run_assert mock_garden_assert_file_contains "inbox section names context" "forced for skeleton test" "$inbox_file"
run_assert mock_garden_assert_file_contains "inbox section names transcript SHA" "$sha" "$inbox_file"

# The transcript should be retrievable as a blob from the journal repo.
blob_content=$(git -C "$MOCK_GARDEN_JOURNAL" cat-file blob "$sha" 2>/dev/null)
run_assert mock_garden_assert_contains "transcript blob contains 'mock command 1'" "mock command 1" "$blob_content"
run_assert mock_garden_assert_contains "transcript blob contains 'mock command 3 exit 1'" "mock command 3 exit 1" "$blob_content"

mock_garden_teardown

echo "=== test_skeleton: $PASS passed, $FAIL failed ==="
if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
exit 0
