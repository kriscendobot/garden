#!/bin/bash
# check.sh -- the verified-claim-requires-evidence gate.
#
# Enforces the maintainer-surfaced discipline from
# `endojs/endo-but-for-bots` #58 (2026-07-01): a "verified" claim in a
# report or a PR comment must cite REAL-EXECUTION evidence, and a UI /
# browser acceptance criterion is satisfied only by an ACTUAL BROWSER
# RUN (rendered-DOM observation), never by code inspection or a passing
# unit test. The incident: the garden reported three UI acceptance
# criteria "verified" from code inspection; the maintainer opened Chrome
# and only one of the three actually rendered.
#
# This gate is a DOC-INVARIANT gate (the claude-md-inventory-drift
# shape), not a project-diff grep gate: it fires when the garden's own
# always-read reporting norm and the juror-seat checks that encode this
# discipline have drifted out of the library. The required set:
#
#   roles/COMMON.md               -- the fleet-wide § Reporting norm.
#   roles/gardener/AGENT.md       -- the worker whose completion report
#                                    is the surface that burned it.
#   roles/jurors/saboteur/AGENT.md-- the code-panel seat that rejects an
#                                    unbacked "verified" claim.
#   roles/jurors/skeptic/AGENT.md -- the design-panel analog.
#
# Each required file must carry BOTH anchor phrases (whitespace
# normalized, so a markdown line-wrap between the two words still
# matches):
#
#   "real-execution evidence"  -- the evidence rule.
#   "actual browser run"       -- the UI/browser criterion rule.
#
# Fires (exit 1) when any required file is absent, or is present but
# missing either anchor. The paired prompt.md tells the focused-fix
# subagent to re-encode the missing discipline.
#
# Honors:
#   GATE_REPO_ROOT  the directory to scan (default: $PWD).

set -uo pipefail

REPO_ROOT=${GATE_REPO_ROOT:-$PWD}
test -d "$REPO_ROOT" || { echo "verified-claim-requires-evidence: REPO_ROOT not a directory: $REPO_ROOT" >&2; exit 2; }
cd "$REPO_ROOT" || { echo "verified-claim-requires-evidence: cd failed: $REPO_ROOT" >&2; exit 2; }

# No roles/ layer to police (e.g. a fixture repo without the library):
# pass. The invariant is about the garden's own role/skill library.
if [ ! -d roles ]; then
  exit 0
fi

# The files that must carry the discipline, each paired with the anchors
# it must contain. Anchors are matched after whitespace normalization.
REQUIRED_FILES=(
  roles/COMMON.md
  roles/gardener/AGENT.md
  roles/jurors/saboteur/AGENT.md
  roles/jurors/skeptic/AGENT.md
)

ANCHORS=(
  "real-execution evidence"
  "actual browser run"
)

# normalized <file> -> the file's text with every whitespace run
# collapsed to a single space (so a markdown line-wrap inside an anchor
# phrase does not defeat the substring match).
normalized() {
  tr '\n\t' '  ' < "$1" | tr -s ' '
}

VIOLATIONS=()

for f in "${REQUIRED_FILES[@]}"; do
  if [ ! -f "$f" ]; then
    VIOLATIONS+=("MISSING file: $f must carry the verified-claim-requires-evidence discipline but is absent.")
    continue
  fi
  norm=$(normalized "$f")
  for anchor in "${ANCHORS[@]}"; do
    case "$norm" in
      *"$anchor"*) : ;;
      *) VIOLATIONS+=("MISSING anchor: $f does not carry the phrase \"$anchor\" (the verified-claim-requires-evidence discipline has drifted out of this file).") ;;
    esac
  done
done

if [ "${#VIOLATIONS[@]}" -gt 0 ]; then
  printf 'verified-claim-requires-evidence gate fired:\n' >&2
  for v in "${VIOLATIONS[@]}"; do
    printf '  - %s\n' "$v" >&2
  done
  exit 1
fi

exit 0
