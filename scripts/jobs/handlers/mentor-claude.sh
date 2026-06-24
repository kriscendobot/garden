#!/bin/bash
# mentor-claude.sh — default self-improvement handler: find opportunities via
# `claude -p` wearing the mentor role, and post them as jobs for gardeners.
#
# Invoked by mentor.sh as: mentor-claude.sh <digest-file>
# The digest is the unseen journal entries (progress + errors). The inner agent
# looks for: recurring failures worth hardening a script against, and
# responsibilities currently done by an agent that a script could do more
# reliably. It emits job blocks (JOB <base> … ENDJOB); this handler posts each.
#
# Test harness overrides GARDEN_MENTOR_HANDLER with a deterministic stub.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"
GARDEN_TAG="mentor-claude"

digest="${1:?usage: mentor-claude.sh <digest-file>}"
role_brief="$GARDEN_ROOT/roles/mentor/AGENT.md"

prompt="$(cat <<EOF
You are the garden mentor (role brief: $role_brief). Below are recent journal
entries (progress and errors). Identify concrete opportunities to (a) harden a
scripted automation against a recurring failure, or (b) move a responsibility off
an agent into a script where it can run more reliably. For each, emit a job block
EXACTLY:

JOB improve-<short-deterministic-slug>
<what to change and why, with the script/file involved>
ENDJOB

Emit nothing if there is no clear opportunity.

----- RECENT ENTRIES -----
$(cat "$digest")
----- END ENTRIES -----
EOF
)"

command -v claude >/dev/null 2>&1 || die "claude not on PATH; cannot run mentor"
# --dangerously-skip-permissions: autonomous headless context, no human
# approver; the default permission gate would deny every tool call. Bypass is
# the intended fleet posture (operator pre-consents via
# skipDangerousModePermissionPrompt in ~/.claude). Requires running as non-root.
out="$(claude -p --dangerously-skip-permissions "$prompt")"

base=""; body=""
while IFS= read -r line; do
  if [[ "$line" =~ ^JOB[[:space:]]+(.+)$ ]]; then base="${BASH_REMATCH[1]}"; body=""
  elif [ "$line" = "ENDJOB" ] && [ -n "$base" ]; then
    printf '%s' "$body" | "$HERE/../post-job.sh" "$base"; base=""; body=""
  elif [ -n "$base" ]; then body+="$line"$'\n'; fi
done <<< "$out"
