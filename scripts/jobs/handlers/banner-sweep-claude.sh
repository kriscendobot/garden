#!/bin/bash
# banner-sweep-claude.sh — the CONDITIONAL fixer for comment BANNER RULES. It is
# invoked ONLY after the deterministic detector (gardening/detect-banners.sh) has
# already fired on a change, so it is never run on a clean tree: the gate makes it
# cheap when there is nothing to fix.
#
# It hands a `claude -p` agent the offending ADDED lines — the ones that draw a
# decorative rule out of repeated dash/equals/etc. in a code comment — and asks it
# to DELETE each rule line (keeping any bracketed section title as a plain one-line
# comment) and re-stage the result, so the change no longer carries a banner that a
# human maintainer would never redraw consistently.
#
# Invoked by the gardening flow (gardening/garden-pr.sh) as:
#   banner-sweep-claude.sh <worktree> [base]
#
# Best-effort by contract: a missing `claude`, or an agent that declines, must not
# abort the surrounding state machine — the archivist juror seat is the semantic
# backstop that catches any banner this pass leaves behind. Silent on a clean run
# (the detector says there is nothing to do).

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"
GARDEN_TAG="banner-sweep-claude"

wt="${1:?usage: banner-sweep-claude.sh <worktree> [base]}"
base="${2:-HEAD~1}"

DETECT="${GARDEN_BANNER_DETECT:-$HERE/../gardening/detect-banners.sh}"

# The offending added lines, dynamically computed — never inlined as a literal so
# this handler stays clean under its own detector.
offending="$("$DETECT" lines "$wt" "$base" 2>/dev/null || true)"
[ -n "$offending" ] || exit 0   # detector found nothing actionable; stay quiet

prompt="$(cat <<EOF
You are a garden gardener removing COMMENT BANNER RULES from a proposed change
before it is reviewed. A deterministic detector found decorative rule comments —
code comment lines whose body is nothing but a run of repeated dash/equals/star/
tilde/underscore characters — in lines this change ADDS. A human maintainer never
redraws such a ruler consistently, so it reads as machine-generated noise; delete
each one, then re-stage.

Worktree: $wt

Offending added lines (\`<path>: <added text>\`):
$offending

For EACH offending line, edit the file in the worktree to DELETE the rule line.
If the rule bracketed a section title (a rule line above and/or below a comment
naming the section), KEEP the title as a plain one-line comment and adjust its
punctuation so it reads as a sentence; delete only the rule lines around it. Do
not touch code, prose comments, markdown thematic breaks, fenced-code/data
dashes, or a directional-arrow comment (\`// foo -> bar\`) — only the pure
decorative rule lines the detector reported.

After editing, re-stage exactly the files you changed with
\`git -C $wt add -- <file>\` so the fix is part of the change. Do not commit, push,
or touch anything unrelated. Be terse; when done, print a one-line summary of what
you removed.
EOF
)"

if ! command -v claude >/dev/null 2>&1; then
  log "claude not on PATH; left banner rules for the archivist juror ($wt)"
  exit 0
fi

# --dangerously-skip-permissions: autonomous headless context, no human approver;
# matches the rest of the fleet's *-claude.sh handlers. Best-effort.
out="$(claude -p --dangerously-skip-permissions "$prompt" 2>/dev/null || true)"
if [ -n "$out" ]; then
  log "swept banner rules in $wt: $(printf '%s' "$out" | tail -n 1 | head -c 200)"
else
  log "fixer produced no output for $wt (archivist juror remains the backstop)"
fi
exit 0
