#!/usr/bin/env bash
# test-cleaner.sh — quick self-test for the cleaner skeleton worker.
#
# Builds a tiny mock journal in a tempdir, posts a flat-board cleaner job
# and a per-role-board cleaner job, runs cleaner.sh on each, and asserts
# the resulting done/ files exist with the expected completion stamp.
#
# Regression evidence: removing the `mv` line in cleaner.sh causes the
# done-file assertion to fail; that breakage was used during authoring
# to confirm the test is load-bearing.
#
# Usage:
#   skills/cleaner/test-cleaner.sh
#
# Exit code 0 iff both board shapes complete cleanly.

set -uo pipefail

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
CLEANER_SH=$SCRIPT_DIR/cleaner.sh

MOCK=$(mktemp -d -t cleaner-test-XXXXXX)
trap 'rm -rf "$MOCK"' EXIT

mkdir -p "$MOCK/jobs/open" "$MOCK/jobs/claimed" "$MOCK/jobs/done" "$MOCK/jobs/abandoned"
mkdir -p "$MOCK/jobs/cleaner/open" "$MOCK/jobs/cleaner/claimed" \
         "$MOCK/jobs/cleaner/done" "$MOCK/jobs/cleaner/abandoned"

post_job() {
  local rel=$1
  cat > "$MOCK/$rel" <<EOF
---
job: abc123
posted_by_role: driver
verb: clean
eligible_roles:
  - cleaner
---

A demo cleaner job.
EOF
}

run_case() {
  local label=$1
  local source_rel=$2
  post_job "$source_rel"
  if ! out=$(GARDEN_ROLE=cleaner CLEANER_JOURNAL_DIR="$MOCK" "$CLEANER_SH" "$source_rel"); then
    echo "FAIL $label: cleaner.sh exited non-zero" >&2
    return 1
  fi
  if [ ! -f "$MOCK/$out" ]; then
    echo "FAIL $label: done-file missing at $out" >&2
    return 1
  fi
  if [ -f "$MOCK/$source_rel" ]; then
    echo "FAIL $label: source still present at $source_rel" >&2
    return 1
  fi
  if ! grep -q "outcome: done" "$MOCK/$out"; then
    echo "FAIL $label: completion stamp missing 'outcome: done'" >&2
    return 1
  fi
  if ! grep -q "worker: cleaner.sh" "$MOCK/$out"; then
    echo "FAIL $label: completion stamp missing worker line" >&2
    return 1
  fi
  return 0
}

# Flat-board (jobs/open/) shape.
SHORT_FLAT=abc123
FLAT_REL="jobs/open/20260601T120000Z--${SHORT_FLAT}--demo.md"
run_case "flat-board" "$FLAT_REL" || exit 1

# Per-role-board (jobs/cleaner/open/) shape.
ROLE_REL="jobs/cleaner/open/20260601T120000Z--abc124--demo.md"
run_case "per-role-board" "$ROLE_REL" || exit 1

echo "pass  cleaner skeleton handles both board shapes"
