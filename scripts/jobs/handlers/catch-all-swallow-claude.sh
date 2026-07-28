#!/bin/bash
# catch-all-swallow-claude.sh — the CONDITIONAL fixer for a CATCH-ALL ERROR
# SWALLOW. It is invoked ONLY after the deterministic detector
# (gardening/detect-catch-all-swallow.sh) has already fired on a change, so it is
# never run on a clean tree: the gate makes it cheap when there is nothing to fix.
#
# It hands a `claude -p` agent the offending catch openers — the try/catch blocks
# this change ADDS whose body neither narrows on an error class/code nor
# rethrows/logs — and asks it to NARROW or RETHROW each one so a swallowed error
# can no longer feed a fail-open confinement decision, then re-stage the result.
#
# Invoked by the gardening flow (gardening/garden-pr.sh) as:
#   catch-all-swallow-claude.sh <worktree> [base]
#
# Best-effort by contract: a missing `claude`, or an agent that declines, must
# not abort the surrounding state machine — the saboteur juror seat
# (skills/saboteur-adversarial-review, skills/adversarial-tests) is the semantic
# backstop that catches any swallow this pass leaves behind. Silent on a clean
# run (the detector says there is nothing to do).

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"
GARDEN_TAG="catch-all-swallow-claude"

wt="${1:?usage: catch-all-swallow-claude.sh <worktree> [base]}"
base="${2:-HEAD~1}"

DETECT="${GARDEN_CATCH_ALL_SWALLOW_DETECT:-$HERE/../gardening/detect-catch-all-swallow.sh}"

# The offending catch openers, dynamically computed — never inlined as a literal
# so this handler stays clean under its own detector.
offending="$("$DETECT" lines "$wt" "$base" 2>/dev/null || true)"
[ -n "$offending" ] || exit 0   # detector found nothing actionable; stay quiet

prompt="$(cat <<EOF
You are a garden gardener narrowing CATCH-ALL ERROR SWALLOWS in a proposed change
before it is reviewed. A deterministic detector found try/catch blocks — in code
this change ADDS — whose body neither narrows on an error class/code
(\`instanceof\`, \`.code\`, \`.name\`, ...) nor rethrows/logs. Such a catch quietly
discards EVERY error class; because a swallowed error often feeds a confinement
decision, it reads as a fail-open and must be tightened.

Worktree: $wt

Offending catch openers (\`<path>: <added text>\`):
$offending

For EACH offending catch block, edit the file in the worktree so the catch no
longer swallows every error class. Prefer the narrowest correct fix:
  * if only a specific, expected error is safe to absorb, narrow to it
    (\`if (!(err instanceof FooError)) throw err;\` or a \`.code\`/\`.name\` guard)
    and rethrow the rest;
  * otherwise rethrow (\`throw err;\`) or, at minimum, log the error before
    continuing so it is not silently lost.
Preserve the surrounding control flow and the intended happy path. Do not
broaden the change or touch anything the detector did not report.

After editing, re-stage exactly the files you changed with
\`git -C $wt add -- <file>\` so the fix is part of the change. Do not commit, push,
or touch anything unrelated. Be terse; when done, print a one-line summary of what
you narrowed.
EOF
)"

# Resolve the CLI through the shared resolver (PATH, then the known install
# locations — common.sh § agent-CLI resolution). Single probe, no retry: this
# pre-pass is best-effort and its absence is a soft skip, not a failure.
if ! claude_cli="$(claude_bin_now)"; then
  log "claude not found on PATH nor in any known install location; left catch-all swallow for the saboteur juror ($wt)"
  exit 0
fi

# --dangerously-skip-permissions: autonomous headless context, no human approver;
# matches the rest of the fleet's *-claude.sh handlers. Best-effort.
out="$("$claude_cli" -p --dangerously-skip-permissions "$prompt" 2>/dev/null || true)"
if [ -n "$out" ]; then
  log "narrowed catch-all swallow in $wt: $(printf '%s' "$out" | tail -n 1 | head -c 200)"
else
  log "fixer produced no output for $wt (saboteur juror remains the backstop)"
fi
exit 0
