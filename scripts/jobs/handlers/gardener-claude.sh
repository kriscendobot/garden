#!/bin/bash
# gardener-claude.sh — default gardener job handler: do the work via `claude -p`.
#
# Invoked by gardener.sh as: gardener-claude.sh <base> <job-file> <report-out>
# Wears the gardener role, performs the job described in <job-file>, and writes
# a completion report to <report-out>. The gardener role brief lives at
# roles/gardener/AGENT.md in the garden's main2 worktree.
#
# This is the production path. The test harness overrides GARDEN_JOB_HANDLER
# with a fast deterministic stub, so this file is not exercised by the tests.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"

base="${1:?base}"; jobfile="${2:?jobfile}"; report="${3:?report-out}"
role_brief="$GARDEN_ROOT/roles/gardener/AGENT.md"

jobs_dir="$GARDEN_ROOT/scripts/jobs"
prompt="$(cat <<EOF
You are a garden gardener (role brief: $role_brief). You have claimed job
'$base'. Its specification follows between the markers. Do the work it asks for,
then write a concise completion report (what you did, what changed, any
follow-ups) to stdout. Output ONLY the report.

Messaging discipline (you are a living agent on the message bus):
- Your inbox key is your job base, '$base'. A maintainer reply or a peer message
  can arrive while you work — drain it at natural checkpoints with
  '$jobs_dir/inbox-read.sh $base'.
- Reach the maintainer (via the liaison) with '$jobs_dir/message-user.sh $base';
  the reply routes back into your own inbox.
- Reach a peer living agent with '$jobs_dir/inbox-send.sh <their-base>'. Discover
  who is alive right now with '$jobs_dir/inbox-list.sh'. A message to a peer that
  has already completed is dead-lettered and promoted to a fresh job, so its
  intent is never lost.

----- JOB $base -----
$(cat "$jobfile")
----- END JOB -----
EOF
)"

# --dangerously-skip-permissions: this is an autonomous, headless gardener with
# no human approver, so the default permission gate would deny every Bash/tool
# call (gh, git push, even `command -v gh`) and the gardener could do no real
# work. Bypass is the intended posture for the sandboxed fleet; the operator
# pre-consents via `skipDangerousModePermissionPrompt: true` in ~/.claude.
if command -v claude >/dev/null 2>&1; then
  claude -p --dangerously-skip-permissions "$prompt" > "$report"
else
  die "claude not on PATH; cannot run default gardener handler for '$base'"
fi
