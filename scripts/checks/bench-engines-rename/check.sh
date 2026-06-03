#!/bin/bash
# check.sh -- the bench-engines-rename gate.
#
# Fires if the working tree contains any reference to the (incorrect)
# .bench-engines path. The canonical path on endojs/endo is .engines;
# the steward misapplied a rename to .bench-engines twice on PR #387
# before the second attempt cost a force-push to reverse, per the
# endojs/endo#3294 discussion r3342643104.
#
# Honors:
#   GATE_REPO_ROOT  the directory to scan (default: $PWD).
#
# Output: prints matching lines to stderr. Exits 0 if clean, 1 if any
# match is found. Excludes the gate's own files (this directory) so
# the documentation that names the antipattern does not trigger.

set -uo pipefail

REPO_ROOT=${GATE_REPO_ROOT:-$PWD}
test -d "$REPO_ROOT" || { echo "bench-engines-rename: REPO_ROOT not a directory: $REPO_ROOT" >&2; exit 2; }

cd "$REPO_ROOT" || { echo "bench-engines-rename: cd failed: $REPO_ROOT" >&2; exit 2; }

# Use git grep when inside a repo (faster, respects .gitignore); fall
# back to a recursive grep when not. Both surface filename:line:text.
exclude_self=":!scripts/checks/bench-engines-rename/"

if git rev-parse --git-dir >/dev/null 2>&1; then
  hits=$(git grep -nF '.bench-engines' -- "$exclude_self" 2>/dev/null || true)
else
  hits=$(grep -RnF --exclude-dir=.git \
    --exclude-dir=node_modules \
    --exclude-dir=scripts/checks/bench-engines-rename \
    '.bench-engines' . 2>/dev/null || true)
fi

if [ -n "$hits" ]; then
  printf '%s\n' "$hits" >&2
  exit 1
fi

exit 0
