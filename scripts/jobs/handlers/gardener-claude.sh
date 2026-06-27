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

# --- session continuity across a reaper requeue ------------------------------
#
# A gardener that dies mid-job (crash, OOM, host reboot) leaves its claim in
# `doin/`; the reaper requeues the SAME base back to `todo/` after the claim
# TTL, and a fresh gardener re-claims it. Without continuity that fresh gardener
# runs `claude -p` from a blank slate — every step the dead session reasoned
# through and every uncommitted edit is lost, and the job restarts from zero.
#
# Instead we pin a DETERMINISTIC Claude session id derived from the job base, so
# the resumed run carries the prior session's transcript — what Claude
# "remembers" of the interrupted attempt — forward to completion:
#   * fresh claim  -> `--session-id <sid>` starts the session under that id;
#   * requeued job -> the base is identical, so the derived id is identical, and
#                     if that session's transcript is present on this host we
#                     `--resume <sid>` and nudge it to finish.
# Determinism is what lets the reaper stay a dumb requeue: no session id has to
# be plumbed through the board because the base alone reproduces it.
#
# Resume is best-effort and same-host: a transcript lives under
# ~/.claude/projects/<encoded-cwd>/<sid>.jsonl on the host that wrote it. If the
# requeue is claimed on another host (or the transcript was pruned) we fall back
# to a fresh session pinned to the same id, so the NEXT death stays resumable.
session_id="$(python3 -c 'import sys,uuid; print(uuid.uuid5(uuid.NAMESPACE_URL, "garden-job:"+sys.argv[1]))' "$base" 2>/dev/null || true)"

session_args=()
if [ -n "$session_id" ]; then
  # Claude Code names each project's session dir by the launch cwd with every
  # '/' rewritten to '-' (e.g. /home/kris -> -home-kris). Gardeners launch from
  # a stable cwd, so this reproduces the dir the prior attempt wrote into.
  proj_dir="$HOME/.claude/projects/$(printf '%s' "$PWD" | sed 's#/#-#g')"
  if [ -f "$proj_dir/$session_id.jsonl" ]; then
    session_args=(--resume "$session_id")
    log "resuming session $session_id for requeued job '$base'"
    prompt="$(cat <<EOF
You are RESUMING garden job '$base' after a reaper requeue: your earlier session
was interrupted before it finished and has been carried forward to you intact.
Review what you had already done — including any uncommitted work still in your
worktree — and CONTINUE from where you left off, driving the job to completion.
Re-read the job spec below in case anything changed, then finish and write ONLY
the concise completion report (what you did, what changed, any follow-ups) to
stdout.

----- JOB $base -----
$(cat "$jobfile")
----- END JOB -----
EOF
)"
  else
    session_args=(--session-id "$session_id")
  fi
fi

# --dangerously-skip-permissions: this is an autonomous, headless gardener with
# no human approver, so the default permission gate would deny every Bash/tool
# call (gh, git push, even `command -v gh`) and the gardener could do no real
# work. Bypass is the intended posture for the sandboxed fleet; the operator
# pre-consents via `skipDangerousModePermissionPrompt: true` in ~/.claude.
if command -v claude >/dev/null 2>&1; then
  claude -p --dangerously-skip-permissions "${session_args[@]}" "$prompt" > "$report"
else
  die "claude not on PATH; cannot run default gardener handler for '$base'"
fi
