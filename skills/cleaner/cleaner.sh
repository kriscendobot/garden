#!/usr/bin/env bash
# cleaner.sh — skeleton per-role worker for the cleaner role.
#
# This is the phase-1 demonstration of the worker-pool model from
# designs/driver.md. A real cleaner worker (phase 3) will perform the
# coverage-driven-testing pass, push tests, run CI, etc. This skeleton
# implements only the worker-pool handshake:
#
#   1. Read a job's path on argv ($1 = either the flat-board path
#      `jobs/{open,claimed}/<...>.md` with `eligible_roles: [- cleaner]`,
#      or the per-role-board path `jobs/cleaner/{open,claimed}/<...>.md`).
#   2. Read the body, do a no-op "work" pass (the phase-3 body lands here).
#   3. Move the job to a `done/` directory matching the source board
#      with a one-line completion stamp.
#
# Both board shapes are accepted so this skeleton fits the flat-board
# driver (designs/driver.md's PR-creation-flow workflow) and the
# per-role-board driver (the design's Role-specific job boards section).
# A real worker pool would have the workers race for `open/` via
# `skills/job-board/claim-job.sh` (or a future per-role variant) before
# invoking this script with the resulting `claimed/` path.
#
# Usage:
#   GARDEN_ROLE=cleaner cleaner.sh <job-path>
#
# Where <job-path> is relative to the journal worktree.
#
# Exit codes:
#   0:  work succeeded; job moved to a done/ directory
#   1:  work failed; job moved to an abandoned/ directory
#  64:  usage error

set -uo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: GARDEN_ROLE=cleaner $0 <job-path>" >&2
  exit 64
fi

SOURCE=$1

# Resolve the journal worktree. The skill ships under skills/cleaner/ in
# the garden tree; the journal is the sibling worktree at $GARDEN_ROOT/journal.
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
GARDEN_ROOT=${GARDEN_ROOT:-$(cd "$SCRIPT_DIR/../.." && pwd)}
JRN=${CLEANER_JOURNAL_DIR:-$GARDEN_ROOT/journal}

# Determine the board prefix (`jobs/` for the flat board, `jobs/cleaner/`
# for the per-role board). The completion stamp will land in the same
# board's done/ or abandoned/ directory.
case "$SOURCE" in
  jobs/open/*.md|jobs/claimed/*.md)
    BOARD_PREFIX="jobs"
    ;;
  jobs/cleaner/open/*.md|jobs/cleaner/claimed/*.md)
    BOARD_PREFIX="jobs/cleaner"
    ;;
  *)
    echo "cleaner: source must be under jobs/{open,claimed}/ or jobs/cleaner/{open,claimed}/ (got $SOURCE)" >&2
    exit 64
    ;;
esac

test -f "$JRN/$SOURCE" || { echo "cleaner: $SOURCE not found under $JRN" >&2; exit 1; }

# Parse the short-id from the filename. The flat-board open/ name is
# <UTC>--<short-id>--<slug>.md; the claimed/ name is
# <UTC>--<host>--<role>--<sid>--<short-id>--<slug>.md.
BASE=$(basename "$SOURCE" .md)
case "$SOURCE" in
  */open/*) SHORT=$(printf '%s' "$BASE" | awk -F-- '{print $2}') ;;
  */claimed/*) SHORT=$(printf '%s' "$BASE" | awk -F-- '{print $5}') ;;
  *) SHORT= ;;
esac
if [ -z "$SHORT" ]; then
  echo "cleaner: cannot parse short-id from $BASE" >&2
  exit 1
fi

# Phase-1 "work" is a no-op. Phase-3 lands the real coverage-driven-testing
# loop here. The hook env var CLEANER_WORK_HOOK lets the test harness
# inject a deterministic outcome.
OUTCOME="done"
if [ -n "${CLEANER_WORK_HOOK:-}" ]; then
  if ! "$CLEANER_WORK_HOOK" "$JRN/$SOURCE"; then
    OUTCOME="abandoned"
  fi
fi

# Move the job to done/ (or abandoned/). We do not commit-and-push from
# the skeleton; the supervisor or driver does that.
UTC=$(date -u +%Y%m%dT%H%M%SZ)
DEST_REL="$BOARD_PREFIX/$OUTCOME/${UTC}--${BASE#*--}.md"
mkdir -p "$JRN/$(dirname "$DEST_REL")"

mv "$JRN/$SOURCE" "$JRN/$DEST_REL"

# Append a completion stamp at the body's end (matching skills/job-board/complete-job.sh).
{
  cat "$JRN/$DEST_REL"
  printf '\n# Completion stamp\n'
  printf 'completed_at: %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  printf 'outcome: %s\n' "$OUTCOME"
  printf 'worker: cleaner.sh (skeleton)\n'
} > "$JRN/$DEST_REL.tmp" && mv "$JRN/$DEST_REL.tmp" "$JRN/$DEST_REL"

printf '%s\n' "$DEST_REL"

# Skeleton's exit code mirrors the work outcome.
test "$OUTCOME" = "done" || exit 1
