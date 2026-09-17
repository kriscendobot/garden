#!/bin/bash
# Regression coverage for skills/panel-hints/probes/C-curator-sibling-surface.sh,
# the sensing half of the `existing-cli-surface-equivalence` review-miss cluster
# (process; grounding endojs/endo-but-for-bots #658, #897, #1085). Each fire
# assertion feeds the probe the real historical added line where the miss occurred
# and checks it fires the curator; the abstain assertions check that an unrelated
# export, a plain (non-variant) interface method, and a non-path split do not force
# a fault.
#
# The fired lines are quoted from the actual PR diffs:
#   #658  packages/cli/src/pet-name.js added `mountPathSegments` (splitting on '/')
#         beside the pre-existing `parsePetNamePath` in the SAME module; endo.js
#         added `write <mountName> <path...>` verbs whose slash-path traversal
#         `cat`/`ls` already reached. (verified: the probe also fires on the full
#         real diff piped through --scan-stdin, hit `parsePetNamePath`.)
#   #897  packages/daemon/src/mount.js added `segmentsFromEntryPathArgument` and a
#         "Path segment must not contain '/'" guard — path-discipline translation
#         the CLI adapter's `parsePetNamePath` already owns. (full-diff hit: the
#         guard string.)
#   #1085 packages/daemon/src/interfaces.js added `streamGlob`/`streamGrep` exo
#         methods — streaming twins of the eager `grep`/`glob`. (full-diff hit:
#         `streamGlob(`.)

set -uo pipefail

ROOT=$(cd "$(dirname "$0")/../../.." && pwd)
PROBE="$ROOT/skills/panel-hints/probes/C-curator-sibling-surface.sh"

passes=0
failures=0
ok() { echo "ok - $1"; passes=$((passes + 1)); }
bad() { echo "not ok - $1"; failures=$((failures + 1)); }

fires() { # <name> <line>
  local name="$1" line="$2" out
  out=$(printf '%s\n' "$line" | "$PROBE" --scan-stdin 2>&1)
  case "$out" in
    "fire curator"*) ok "$name — $out" ;;
    *) bad "$name did not fire: $out" ;;
  esac
}

abstains() { # <name> <line...>
  local name="$1"; shift
  local out
  out=$(printf '%s\n' "$@" | "$PROBE" --scan-stdin 2>&1)
  case "$out" in
    "skip curator") ok "$name abstains" ;;
    *) bad "$name should abstain: $out" ;;
  esac
}

# --- Member re-litigation: the real historical added lines where each miss occurred ---

# #658 — a new exported path-segment parser beside the pre-existing parsePetNamePath.
fires 'pr658 mountPathSegments export (pet-name.js)' \
  'export const mountPathSegments = (pathArgs = []) =>'
fires 'pr658 slash-split on a name (pet-name.js)' \
  "  pathArgs.flatMap(arg => arg.split('/')).filter(segment => segment !== '');"
fires 'pr658 write CLI verb with path positional (endo.js)' \
  "    .command('write <mountName> <path...>')"
fires 'pr658 cat CLI verb with path positional (endo.js)' \
  "    .command('cat <name> [path...]')"

# #897 — daemon-side pet-name path-segment translation the CLI adapter already owns.
fires 'pr897 segmentsFromEntryPathArgument def (mount.js)' \
  '  const segmentsFromEntryPathArgument = pathArgument => {'
fires 'pr897 path-segment guard string (mount.js)' \
  "      \`Path segment must not contain '/', backslash, or NUL (a string is one segment):\`,"

# #1085 — streaming twins of the eager grep/glob.
fires 'pr1085 streamGlob interface method (interfaces.js)' \
  '  streamGlob: M.call(M.string())'
fires 'pr1085 streamGrep interface method (interfaces.js)' \
  '  streamGrep: M.call('

# --- Controls ---

# An unrelated export sharing no stem or route with a sibling.
abstains 'unrelated clamp export' \
  'export const clampMaxResults = (requested, ceiling) => {'

# The plain eager sibling itself is not a variant twin and carries no path split.
abstains 'plain grep interface method' \
  "  grep: M.call(M.string(), M.remotable('glob')),"

# A split on a non-path delimiter is not a path-discipline surface.
abstains 'comma split, not a path' \
  "  const parts = csv.split(',');"

echo "1..$((passes + failures))"
echo "# passes=$passes failures=$failures"
[ "$failures" -eq 0 ]
