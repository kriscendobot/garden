#!/bin/bash
# test_loop_capture_and_self_improve.sh -- verify the driver's per-tick
# capture + agent self-improvement loop.
#
# The driver's main loop wraps `( set -x; run_once )` per tick and
# captures stdout+stderr into a tempfile. After the tick completes, the
# driver:
#
#   1. Hashes the capture via `git -C <journal> hash-object -w --stdin`
#      so the tick's transcript lands as a blob in the journal's object
#      database.
#   2. Invokes an agent (the PATH-stubbed `claude` in tests) with a
#      prompt that names the capture SHA so the agent can read the
#      transcript on demand via `git cat-file blob`.
#   3. Appends the agent's analysis to a per-lane improvements file at
#      `journal/drivers/<host>/<lane>.improvements.md`.
#
# This test exercises a single oneshot tick (the design-only workflow's
# initial -> build transition with DRIVER_PR pre-set) and asserts each
# of the three observable artifacts above.
#
# SELF_IMPROVE_SYNC=1 makes the per-tick analyzer run synchronously so
# the test can assert the improvements file is written before the driver
# returns.

set -uo pipefail

HARNESS_DIR=$(cd "$(dirname "$0")" && pwd)
source "$HARNESS_DIR/lib/mock-garden.sh"

PASS=0
FAIL=0
ok() { PASS=$((PASS+1)); }
ko() { FAIL=$((FAIL+1)); }
run_assert() { if "$@"; then ok; else ko; fi; }

echo "=== test_loop_capture_and_self_improve ==="

mock_garden_setup

# Pin the design-only workflow with a PR id so the initial->build
# transition is direct (no post_job needed). One tick is enough to
# observe the capture + self-improve behavior.
export DRIVER_PR="mock/repo#101"
export DRIVER_WORKFLOW="design-only-pr"
export DRIVER_ONESHOT=1
export DRIVER_TICK_SECONDS=0

# Run the per-tick self-improvement step synchronously so the test
# can observe the improvements file before the driver returns.
export SELF_IMPROVE_SYNC=1

mock_garden_set_pr_json '{"state":"OPEN","isDraft":true,"reviews":[]}'

# Provide a deterministic agent stub so the analyzer does not depend on
# the PATH-stubbed `claude` happening to behave a certain way. The stub
# echoes a recognizable analysis with the capture SHA embedded so we can
# round-trip it through the improvements file.
stub_self_improve="$MOCK_TMP/self-improve-stub.sh"
cat > "$stub_self_improve" <<'EOF'
#!/bin/bash
echo "test-stub agent analysis for sha=$1"
echo "(stub) no improvements suggested"
EOF
chmod +x "$stub_self_improve"
export SELF_IMPROVE_CLAUDE_STUB="$stub_self_improve"

# --- run the driver -------------------------------------------------------
set +e
bash "$MOCK_GARDEN_ROOT/scripts/driver/driver.sh" 1 >/dev/null 2>&1
rc=$?
set -e

run_assert mock_garden_assert_eq "driver oneshot rc=0" 0 "$rc"

# --- assertion 1: improvements file exists with a tick section ----------
improvements_file="$MOCK_GARDEN_JOURNAL/drivers/mock-host/1.improvements.md"
[ -f "$improvements_file" ] && ok || { echo "  FAIL: improvements file missing: $improvements_file"; ko; }

if [ -f "$improvements_file" ]; then
  run_assert mock_garden_assert_file_contains \
    "improvements file frontmatter names lane 1" \
    "lane: 1" "$improvements_file"
  run_assert mock_garden_assert_file_contains \
    "improvements file frontmatter names host" \
    "host: mock-host" "$improvements_file"
  run_assert mock_garden_assert_file_contains \
    "improvements file has a tick section header" \
    "## tick at" "$improvements_file"
  run_assert mock_garden_assert_file_contains \
    "improvements file names the workflow" \
    "Workflow: design-only-pr" "$improvements_file"
  run_assert mock_garden_assert_file_contains \
    "improvements file embeds the agent response" \
    "test-stub agent analysis for sha=" "$improvements_file"
fi

# --- assertion 2: capture SHA is a real blob in the journal object DB ---
# Pull the SHA out of the improvements section (the stub embeds it).
capture_sha=$(sed -n 's/^test-stub agent analysis for sha=\(.*\)$/\1/p' \
                "$improvements_file" 2>/dev/null | head -1)
[ -n "$capture_sha" ] && ok || { echo "  FAIL: could not extract capture SHA from improvements file"; ko; }

if [ -n "$capture_sha" ]; then
  if git -C "$MOCK_GARDEN_JOURNAL" cat-file -e "$capture_sha" 2>/dev/null; then
    ok
  else
    echo "  FAIL: capture SHA $capture_sha not found in journal object DB"
    ko
  fi

  # The blob should contain the -x trace of the tick: at minimum the
  # run_once invocation.
  blob=$(git -C "$MOCK_GARDEN_JOURNAL" cat-file blob "$capture_sha" 2>/dev/null)
  run_assert mock_garden_assert_contains \
    "captured blob contains the -x trace of run_once" \
    "+ run_once" "$blob"
fi

# --- assertion 3: a second tick appends, does not overwrite -------------
# Run the driver a second time. The improvements file should grow.
size_before=$(wc -c < "$improvements_file" 2>/dev/null || echo 0)
section_count_before=$(grep -c '^## tick at' "$improvements_file" 2>/dev/null || echo 0)

mock_garden_set_pr_json '{"state":"OPEN","isDraft":true,"reviews":[]}'
set +e
bash "$MOCK_GARDEN_ROOT/scripts/driver/driver.sh" 1 >/dev/null 2>&1
rc2=$?
set -e

run_assert mock_garden_assert_eq "second driver oneshot rc=0" 0 "$rc2"

size_after=$(wc -c < "$improvements_file" 2>/dev/null || echo 0)
section_count_after=$(grep -c '^## tick at' "$improvements_file" 2>/dev/null || echo 0)

if [ "$size_after" -gt "$size_before" ]; then
  ok
else
  echo "  FAIL: improvements file did not grow on second tick ($size_before -> $size_after)"
  ko
fi

if [ "$section_count_after" -gt "$section_count_before" ]; then
  ok
else
  echo "  FAIL: improvements section count did not grow ($section_count_before -> $section_count_after)"
  ko
fi

# --- assertion 4: stubless agent path still records via PATH-stubbed claude
# Drop the SELF_IMPROVE_CLAUDE_STUB so the driver falls back to invoking
# `claude` from PATH; mock-garden's PATH stub for claude records its
# invocations to MOCK_LOGS/claude.log. Reset state and run one more tick.
unset SELF_IMPROVE_CLAUDE_STUB
rm -f "$MOCK_GARDEN_JOURNAL/drivers/mock-host/1.improvements.md"
rm -f "$MOCK_GARDEN_JOURNAL/drivers/mock-host/1.md"

# Reset the state file so the driver starts at initial and advances to
# build, exactly as in tick 1 of the happy path.
mock_garden_set_pr_json '{"state":"OPEN","isDraft":true,"reviews":[]}'
: > "$MOCK_LOGS/claude.log"

set +e
bash "$MOCK_GARDEN_ROOT/scripts/driver/driver.sh" 1 >/dev/null 2>&1
rc3=$?
set -e

run_assert mock_garden_assert_eq "third driver oneshot rc=0" 0 "$rc3"
# The PATH-stubbed claude should have been called at least once.
if [ -s "$MOCK_LOGS/claude.log" ]; then
  ok
else
  echo "  FAIL: PATH-stubbed claude was not invoked when SELF_IMPROVE_CLAUDE_STUB was unset"
  ko
fi
run_assert mock_garden_assert_file_contains \
  "PATH-stubbed claude was invoked with -p" \
  "claude invoked with -p" "$MOCK_LOGS/claude.log"

# The improvements file should still be created with the PATH-stubbed
# claude's response.
improvements_file="$MOCK_GARDEN_JOURNAL/drivers/mock-host/1.improvements.md"
[ -f "$improvements_file" ] && ok || { echo "  FAIL: improvements file missing after stubless run"; ko; }
if [ -f "$improvements_file" ]; then
  run_assert mock_garden_assert_file_contains \
    "improvements file has a tick section after stubless run" \
    "## tick at" "$improvements_file"
fi

mock_garden_teardown

echo "=== test_loop_capture_and_self_improve: $PASS passed, $FAIL failed ==="
if [ "$FAIL" -gt 0 ]; then
  exit 1
fi
exit 0
