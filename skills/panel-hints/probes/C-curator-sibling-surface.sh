#!/bin/bash
# C-curator-sibling-surface — fires the curator seat when a diff adds or renames a
# PUBLIC SURFACE (an exported symbol, an interface method, a CLI verb, or a
# path/route branch) that looks like a variant OR sibling of a surface the code
# already exposes — a streaming/eager twin, a second path-discipline parser, a new
# reader branch beside an existing route. The curator
# (roles/jurors/curator/AGENT.md § Trace the pre-existing sibling surface) then
# traces the pre-existing sibling and judges BOTH redundancy AND compositional
# coherence: is the new surface duplicating a route/layer the sibling already owns,
# or fusing concerns the sibling deliberately keeps orthogonal?
#
# Senses the review-miss cluster `existing-cli-surface-equivalence` (process;
# grounding endojs/endo-but-for-bots #658, #897, #1085): a code panel approved a new
# public surface without tracing the pre-existing equivalent, so redundant or
# incoherently-fused public surface reached maintainer review.
#   #658  packages/cli/src/pet-name.js added an exported `mountPathSegments`
#         (splitting on '/') beside the pre-existing `parsePetNamePath` in the SAME
#         module, plus `write <mountName> <path...>` CLI verbs whose slash-path
#         traversal `cat`/`ls` already reached — a duplicated VFS route.
#   #897  packages/daemon/src/mount.js added daemon-side pet-name path-segment
#         translation (`segmentsFromEntryPathArgument`, a "Path segment must not
#         contain '/'" guard), duplicating a path discipline the CLI adapter's
#         `parsePetNamePath` already owns — a misplaced layer.
#   #1085 packages/daemon/src/interfaces.js added `streamGlob`/`streamGrep` exo
#         methods — streaming twins of the eager `grep`/`glob` — whose first cut
#         fused glob+grep instead of mirroring the eager `grep(pattern, glob(g))`
#         composition seam.
#
# Two signal groups, fire on EITHER (err toward firing — a loose probe is
# acceptable, a missed fire is not; the seat, not the probe, decides whether a real
# sibling exists and whether the new surface is redundant or incoherent):
#   TWIN   — an added definition/interface-method whose name carries a variant affix
#            (stream/eager/lazy/buffered/sync/async/incremental/chunked ...), i.e. a
#            streaming/eager/sync twin of a plainer sibling.
#   ROUTE  — an added path-discipline surface (a *Path/*Segments/*NamePath/
#            *PathArgument definition, a `parsePetNamePath` reference, a `.split('/')`
#            on a name, a "path segment must not" guard, or a new CLI verb taking a
#            path positional), i.e. a second parser/route/layer for a path the code
#            already traverses somewhere.
set -uo pipefail
BASE=${BASE:-origin/master}

# TWIN: a variant-affixed identifier introduced as a definition or interface method
# (prefix affix + Uppercase followed by a :/(/= binder, or an exported def whose
# name ends in a variant suffix).
TWIN='\b(stream|eager|lazy|buffered|unbuffered|incremental|chunked|batched)[A-Z][[:alnum:]_$]*[[:space:]]*[:=(]|\b(export[[:space:]]+)?(async[[:space:]]+)?(function|const|let|class)[[:space:]]+[A-Za-z_$][[:alnum:]_$]*(Sync|Async|Stream|Streaming|Eager|Lazy|Buffered)[[:space:]]*[:=(]?'

# ROUTE: a path-discipline surface — a parser/segmenter definition, a slash split on
# a name, the segment guard, a pet-name-path adapter reference, or a new CLI verb
# whose spec carries a path positional.
ROUTE='[A-Za-z_$]*([Pp]etNamePath|[Pp]athSegments?|[Nn]amePath|[Mm]ountPath|[Pp]athArgument|[Pp]athSegment)[[:space:]]*[:=(]|\bparse(Optional)?PetNamePath\b|\.split[[:space:]]*\([[:space:]]*['"'"'"]/['"'"'"]|[Pp]ath segment must not|\.command[[:space:]]*\([[:space:]]*['"'"'"][^'"'"'"]*(<[a-z]*path|\[[a-z]*path|path\.\.\.)'

if [ "${1:-}" = "--scan-stdin" ]; then
  lines=$(cat)
else
  lines=$(git diff "$BASE...HEAD" -U0 2>/dev/null | grep -E '^\+[^+]' | sed 's/^\+//')
fi

# Fire on the first added line matching either signal group.
while IFS= read -r line; do
  [ -n "$line" ] || continue
  if printf '%s' "$line" | grep -qE "$TWIN"; then
    hit=$(printf '%s' "$line" | grep -oE "$TWIN" | head -1)
    echo "fire curator variant-affixed surface ($hit) — a streaming/eager/sync twin; trace the plainer sibling and judge redundancy AND compositional coherence (is it fusing concerns the sibling keeps orthogonal?)"
    exit 0
  fi
  if printf '%s' "$line" | grep -qE "$ROUTE"; then
    hit=$(printf '%s' "$line" | grep -oE "$ROUTE" | head -1)
    echo "fire curator path/route surface ($hit) — trace the pre-existing route/adapter that already owns this path discipline and judge redundancy (a duplicated route/layer?)"
    exit 0
  fi
done <<< "$lines"

echo "skip curator"
