#!/bin/bash
# panel-run-record-decide-stub.sh — a deterministic GARDEN_PANEL_DECIDE hook for
# panel-run-record-test.sh. Called as <aggregate-file> <pr>. It reads the round's
# aggregate and returns `must-fix` when any seat requested changes, else `pass` —
# the real disposition rubric, driven off the stubbed seat verdicts with no live
# `claude -p`. This lets a marker-driven fix loop converge deterministically.
set -uo pipefail
agg="${1:?aggregate}"
if grep -qi 'request-changes' "$agg" 2>/dev/null; then
  printf 'must-fix\n'
else
  printf 'pass\n'
fi
