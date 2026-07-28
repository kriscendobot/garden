#!/bin/bash
# portability-coupling-claude.sh — the CONDITIONAL fixer for developer-workstation
# coupling. It is invoked ONLY after the deterministic detector
# (gardening/detect-home-coupling.sh) has already fired on a change, so it is never
# run on a clean tree: the gate makes it cheap when there is nothing to fix.
#
# It hands a `claude -p` agent the offending ADDED lines — the ones that hardcode
# the current user's home directory — and asks it to rewrite each into a PORTABLE
# form ($HOME, $GARDEN_ROOT, a relative path, or an existing config var) and to
# re-stage the result, so the change no longer carries a path that is true on one
# contributor's workstation and wrong on the next.
#
# Invoked by the gardening flow (gardening/garden-pr.sh) as:
#   portability-coupling-claude.sh <worktree> [base]
#
# Best-effort by contract: a missing `claude`, or an agent that declines, must not
# abort the surrounding state machine — the transplanter juror seat is the
# semantic backstop that catches any coupling this pass leaves behind. Silent on a
# clean run (the detector says there is nothing to do).

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"
GARDEN_TAG="portability-coupling-claude"

wt="${1:?usage: portability-coupling-claude.sh <worktree> [base]}"
base="${2:-HEAD~1}"

DETECT="${GARDEN_HOME_COUPLING_DETECT:-$HERE/../gardening/detect-home-coupling.sh}"

# The offending added lines, dynamically computed — never inlined as a literal so
# this handler stays clean under its own detector.
offending="$("$DETECT" lines "$wt" "$base" 2>/dev/null || true)"
[ -n "$offending" ] || exit 0   # detector found nothing actionable; stay quiet

prompt="$(cat <<EOF
You are a garden gardener fixing developer-WORKSTATION COUPLING in a proposed
change before it is reviewed. A deterministic detector found the current user's
home directory hardcoded in lines this change ADDS. A hardcoded home path is true
on one contributor's machine and wrong on the next; rewrite each into a PORTABLE
form, then re-stage.

Worktree: $wt

Offending added lines (\`<path>: <added text>\`):
$offending

For EACH offending line, edit the file in the worktree to replace the hardcoded
home directory with the most appropriate portable form, in this order of
preference:
  1. an existing configuration variable the surrounding code already uses
     (e.g. \$GARDEN_ROOT, \$GARDEN_STATE, \$JOURNAL_REMOTE);
  2. \$HOME (for a path genuinely under the user's home);
  3. a path RELATIVE to the script/worktree (e.g. via \$(dirname "\${BASH_SOURCE[0]}"));
Never substitute a different hardcoded absolute path — that just moves the
coupling. Preserve behavior: the rewritten path must resolve to the same location
at run time on the original author's machine.

After editing, re-stage exactly the files you changed with
\`git -C $wt add -- <file>\` so the fix is part of the change. Do not commit, push,
or touch anything unrelated. Be terse; when done, print a one-line summary of what
you rewrote.
EOF
)"

# Resolve the CLI through the shared resolver (PATH, then the known install
# locations — common.sh § agent-CLI resolution). Single probe, no retry: this
# pre-pass is best-effort and its absence is a soft skip, not a failure.
if ! claude_cli="$(claude_bin_now)"; then
  log "claude not found on PATH nor in any known install location; left home-coupling for the transplanter juror ($wt)"
  exit 0
fi

# --dangerously-skip-permissions: autonomous headless context, no human approver;
# matches the rest of the fleet's *-claude.sh handlers. Best-effort.
out="$("$claude_cli" -p --dangerously-skip-permissions "$prompt" 2>/dev/null || true)"
if [ -n "$out" ]; then
  log "rewrote workstation coupling in $wt: $(printf '%s' "$out" | tail -n 1 | head -c 200)"
else
  log "fixer produced no output for $wt (transplanter juror remains the backstop)"
fi
exit 0
