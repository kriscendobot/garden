#!/bin/bash
# check.sh -- the claude-md-inventory-drift gate.
#
# Fires when a role or skill present on disk is absent from CLAUDE.md's
# "Current inventory" section. The garden's top-level CLAUDE.md carries a
# hand-maintained roster of every role (`roles/<r>/AGENT.md`) and skill
# (`skills/<s>/SKILL.md`) in its "## Current inventory" section. Indexing
# that roster is a meta-doc edit reserved for the liaison; a gardener or
# scholar that authors a new skill or role cannot perform it, so the
# roster drifts behind the real `skills/`- and `roles/`-dir set on every
# authoring job (e.g. `skills/oauth-use-case-patterns/SKILL.md` landed on
# main2 by the 2026-06-30 scholar cycle with zero CLAUDE.md mentions).
#
# This gate moves "detect the missing inventory row" off the authoring
# agent's good intentions and into the scripted check harness, so the
# drift cannot land silently; on a fire prompt.md routes a focused
# liaison dispatch to add the row(s).
#
# Honors:
#   GATE_REPO_ROOT  the directory to scan (default: $PWD).
#
# Output: prints each present-on-disk-but-unindexed role/skill to
# stderr. Exits 0 if the roster is complete, 1 if anything is missing.
#
# Scope notes:
#   - Roles are enumerated as roles/*/AGENT.md (one level deep), which
#     excludes the jury seats under roles/jurors/<seat>/AGENT.md. The
#     inventory's Roles paragraph names orchestrator-dispatchable roles,
#     not individual juror seats, so juror seats are out of scope.
#   - A name counts as "indexed" if it appears in the Current inventory
#     section as a whole hyphen-delimited token (so `builder` is NOT
#     considered present merely because `web-builder` is listed, and a
#     bare prose mention such as "the triager" DOES count). Names are
#     drawn from directory basenames, which are [a-z0-9-] only.

set -uo pipefail

REPO_ROOT=${GATE_REPO_ROOT:-$PWD}
test -d "$REPO_ROOT" || { echo "claude-md-inventory-drift: REPO_ROOT not a directory: $REPO_ROOT" >&2; exit 2; }
cd "$REPO_ROOT" || { echo "claude-md-inventory-drift: cd failed: $REPO_ROOT" >&2; exit 2; }

# Nothing to police without the meta-doc and at least one library layer
# (e.g. a fixture repo): pass silently.
if [ ! -f CLAUDE.md ]; then
  exit 0
fi
if [ ! -d roles ] && [ ! -d skills ]; then
  exit 0
fi

# Extract the "## Current inventory" section: from its heading line up to
# (but not including) the next level-2 heading.
SECTION=$(awk '
  /^## Current inventory[[:space:]]*$/ { capture=1; next }
  capture && /^## / { exit }
  capture { print }
' CLAUDE.md)

if [ -z "$SECTION" ]; then
  echo "claude-md-inventory-drift: no '## Current inventory' section found in CLAUDE.md" >&2
  exit 1
fi

# indexed <name> -> exit 0 if the name appears in the section as a whole
# hyphen-delimited token. The boundaries reject A being a substring of a
# longer hyphenated token B (the char on either side may not be a word
# char or a hyphen).
indexed() {
  printf '%s\n' "$SECTION" | grep -Eq "(^|[^A-Za-z0-9-])$1([^A-Za-z0-9-]|\$)"
}

MISSING_ROLES=()
MISSING_SKILLS=()

if [ -d roles ]; then
  for agent_md in roles/*/AGENT.md; do
    [ -f "$agent_md" ] || continue
    name=$(basename "$(dirname "$agent_md")")
    indexed "$name" || MISSING_ROLES+=("$name")
  done
fi

if [ -d skills ]; then
  for skill_md in skills/*/SKILL.md; do
    [ -f "$skill_md" ] || continue
    name=$(basename "$(dirname "$skill_md")")
    indexed "$name" || MISSING_SKILLS+=("$name")
  done
fi

if [ "${#MISSING_ROLES[@]}" -eq 0 ] && [ "${#MISSING_SKILLS[@]}" -eq 0 ]; then
  exit 0
fi

echo "claude-md-inventory-drift gate fired: on-disk role(s)/skill(s) absent from CLAUDE.md '## Current inventory':" >&2
for r in "${MISSING_ROLES[@]}"; do
  echo "  - role:  roles/$r/AGENT.md  (not indexed in the Roles paragraph)" >&2
done
for s in "${MISSING_SKILLS[@]}"; do
  echo "  - skill: skills/$s/SKILL.md  (not indexed in the Skills paragraph)" >&2
done
exit 1
