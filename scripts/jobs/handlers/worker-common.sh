#!/bin/bash
# worker-common.sh — the SHARED half of every worker job handler.
#
# The worker spine (gardener.sh) is backend-pluggable via GARDEN_JOB_HANDLER; the
# two production handlers, handlers/gardener-claude.sh (claude) and
# handlers/cleric-codex.sh (codex), differ ONLY in the CLI they drive. Everything
# that must NOT drift between them — the per-job worktree lifecycle, the
# injection-hygiene prompt text, the worktree note, and the completion contract —
# lives here, in one place both source (design §2.2, cleric-worker-bid-auction-
# reputation.md). A third backend reuses these verbatim and supplies only its own
# CLI invocation + session-resume mechanics.
#
# Sourced (not exec'd) by a handler that has already sourced common.sh, so the
# completion helpers (report_has_completion_marker, strip_completion_marker,
# GARDEN_COMPLETION_MARKER) and the worktree janitors (kill_stale_worktree_handlers,
# scratch_cleanup) are in scope.

# worker_worktree_path <base> — the per-job worktree path, STABLE per base (never a
# per-attempt random suffix): a reaper requeue re-runs the SAME base, so the same
# path lets a resumed run re-enter the same worktree and find its uncommitted work.
# The historical `gardener-wt-` prefix is kept (it is the spine's name and is
# referenced by the scratch janitor and tests) and is shared by every kind — only
# one worker ever holds a given base at a time, so the two kinds never collide here.
worker_worktree_path() {
  local base="${1:?worker_worktree_path: base required}"
  printf '%s\n' "$GARDEN_SCRATCH/gardener-wt-$base"
}

# worker_ensure_worktree <worktree> <main-branch> <resuming> — make $worktree a
# detached checkout of origin/<main-branch>. On a resume (resuming=true and the dir
# exists) we keep whatever is there (the interrupted attempt's uncommitted work);
# otherwise we (re)create it fresh at the current dev-branch tip. We base off the
# LOCAL tracking ref origin/<main-branch> — kept fresh by the watchman's fetch —
# rather than fetching here, so the launch path adds no per-job network cost; the
# CAS push loop the job itself runs reconciles any staleness. Falls back to the bare
# branch then HEAD if the tracking ref is absent (a freshly cloned root).
worker_ensure_worktree() {
  local worktree="${1:?worker_ensure_worktree: worktree required}"
  local main_branch="${2:?worker_ensure_worktree: main-branch required}"
  local resuming="${3:-false}" ref
  if [ "$resuming" = true ] && [ -d "$worktree" ]; then
    return 0                          # resume: reuse the in-flight worktree as-is
  fi
  # Fresh claim. A leftover dir (stale completion that never cleaned up, or a
  # requeue whose transcript was pruned) is removed and recreated so the job starts
  # from a clean current-tip checkout, never a stale base.
  [ -e "$worktree" ] && scratch_cleanup "$worktree"
  for ref in "origin/$main_branch" "$main_branch" HEAD; do
    if git -C "$GARDEN_ROOT" rev-parse --verify --quiet "$ref" >/dev/null 2>&1; then
      mkdir -p "$GARDEN_SCRATCH"
      git -C "$GARDEN_ROOT" worktree add --detach "$worktree" "$ref" >/dev/null 2>&1 && return 0
    fi
  done
  die "could not create per-job worktree $worktree off any of origin/$main_branch, $main_branch, HEAD"
}

# worker_worktree_note <base> <worktree> <main-branch> — the worktree-discipline
# paragraph appended to every job prompt (both fresh and resume). Byte-identical
# across backends: the "no development in the root tree" and "isolated project
# checkout keyed by THIS base" rules must read the same to a claude and to a codex.
worker_worktree_note() {
  local base="${1:?}" worktree="${2:?}" main_branch="${3:?}"
  local jobs_dir="$GARDEN_ROOT/scripts/jobs"
  cat <<EOF
Your working directory is a dedicated git worktree for THIS job, checked out off
origin/$main_branch at $worktree. Do ALL development for this job here, in your
cwd: never edit the deployed garden root checkout. Commit explicit pathspecs and
push with a rebase CAS loop to $main_branch (git push origin HEAD:$main_branch).
The worktree is torn down when you finish and is garbage-collected if your run
dies, so nothing you need to keep should live outside a commit.

That cwd worktree is for GARDEN development (roles, skills, scripts on $main_branch).
If this job instead mutates a PROJECT repo (a fork like endojs/endo-but-for-bots
— editing its source, pushing to a PR head branch), do NOT hand-name a project
checkout keyed by the repo or PR number: a peer worker working the SAME PR would
collide into your working tree and your concurrent edits would corrupt each other
(the endo-but-for-bots #58 corruption). Get an ISOLATED project checkout, keyed by
THIS job's unique base, with:
    $jobs_dir/ensure-project-worktree.sh $base <owner/repo> <branch>
It prints the absolute path (a detached checkout under $GARDEN_SCRATCH, stable
across a requeue so you resume in-flight work); cd there and do the project work.
Concurrent same-branch pushes still race at the git-push CAS — that is fine; the
working trees must never be shared.

If this job OPENS a pull request, open it ONLY through
$jobs_dir/gardening/ensure-pr.sh <base> <owner/repo> <head-branch> <base-branch>
--title T --body-file F — never a bare 'gh pr create'. A prior claimant of THIS
job (a cross-host reaper requeue starts you clean, with no session to resume) may
have ALREADY opened the PR; ensure-pr.sh finds it by the durable
'<!-- garden-job: $base -->' marker and adopts it instead of opening a duplicate
(the endo-but-for-bots #999/#1000 defect). Before creating anything, run it (or its
--find-only form) to rediscover a prior PR rather than assuming none exists.

NEVER run git in the deployed garden root ($GARDEN_ROOT). That checkout and the
journal worktree SHARE ONE repo, so a stray 'git remote set-url' / 'fetch' /
'checkout' / 'commit' there — or ANY git command run in a dir under the root that
you did not 'git init' yourself — corrupts journal sync for the WHOLE host (incident
2026-07-17/07-21). Run git ONLY inside your per-job worktree (your cwd) or a project
checkout from ensure-project-worktree.sh above. If a tool needs a scratch git repo,
create it OUTSIDE the root (e.g. under \$TMPDIR) and 'git init' it before use.
EOF
}

# worker_job_prompt <base> <jobfile> <worktree> <main-branch> <mode> — the full
# prompt a handler feeds its CLI. mode=fresh|resume|fallback selects the framing;
# all three carry the SAME completion-signal contract, worktree note, messaging
# discipline, and verbatim job spec, so the two backends can never drift on
# injection hygiene or the completion contract. External text (the job body) is
# data on every path. The role brief is the gardener brief for every kind — a
# cleric is a codex-backed gardener.
#
# The three modes answer three genuinely different starting states, and MUST NOT be
# conflated — a resumed worker that is lied to about its state wastes the run:
#   * fresh    — a first claim: no prior attempt, nothing to carry, nothing lost.
#   * resume   — a requeue re-claimed on the SAME host WITH its session transcript
#                present: `--resume` attached, so the prior reasoning AND the
#                uncommitted work in this same worktree really were carried forward.
#   * fallback — a requeue re-claimed on a DIFFERENT host (or after the transcript
#                was pruned): `--resume` could NOT attach and ensure_worktree
#                recreated a FRESH worktree, so the prior session's memory and its
#                uncommitted working tree are BOTH gone. Only committed/pushed work
#                and the journal survive. Asserting a "carried forward intact"
#                resume here would be false and would push the worker to trust a
#                memory and hunt for uncommitted edits that do not exist (the gap
#                measured in issue #62 follow-up: cross-host requeue loses both).
worker_job_prompt() {
  local base="${1:?}" jobfile="${2:?}" worktree="${3:?}" main_branch="${4:?}" mode="${5:-fresh}"
  local role_brief="$GARDEN_ROOT/roles/gardener/AGENT.md"
  local jobs_dir="$GARDEN_ROOT/scripts/jobs"
  local note; note="$(worker_worktree_note "$base" "$worktree" "$main_branch")"
  local handoff_note
  handoff_note="$(cat <<EOF
HONEST HANDOFF SIGNAL: If the core deliverable is unfinished but you have durably
posted a named successor job or orchestration that owns all remaining work, you
may complete this attempt as a declared handoff. Report evidence, then emit
    <<<GARDEN-JOB-HANDED-OFF: successor-base>>>
immediately BEFORE the completion signal. The machinery verifies the successor
exists and stamps \`handed-off: successor-base\` plus
\`deliverable-complete: false\`. Never use this for an unposted follow-up or as a
clean-completion claim.
EOF
)"
  if [ "$mode" = resume ]; then
    cat <<EOF
You are RESUMING garden job '$base' after a reaper requeue: your earlier session
was interrupted before it finished and has been carried forward to you intact.
Your cwd is the same dedicated worktree you were working in. Review what you had
already done — including any uncommitted work still in this worktree — and
CONTINUE from where you left off, driving the job to completion. Re-read the job
spec below in case anything changed, then finish and write ONLY the concise
completion report (what you did, what changed, any follow-ups) to stdout.

COMPLETION SIGNAL (required): ONLY when you have GENUINELY finished the job, emit
the exact line
    $GARDEN_COMPLETION_MARKER
as the very LAST line of your report, on its own line, as your final act. If you
still did NOT finish, do NOT emit that line — the job will be requeued and
resumed again rather than falsely recorded as done.

ORCHESTRATED FAILURE SIGNAL: If you genuinely finished but did NOT achieve a
gated outcome required by an orchestration, emit the exact line
    $GARDEN_ORCHESTRATION_FAILURE_MARKER
immediately BEFORE the completion signal. Do not type an
\`orchestration-failed:\` field into prose. The completion machinery stamps that
field into report frontmatter from this exact signal.

$handoff_note

$note

----- JOB $base -----
$(cat "$jobfile")
----- END JOB -----
EOF
  elif [ "$mode" = fallback ]; then
    cat <<EOF
You are RE-RUNNING garden job '$base' after a reaper requeue, but the prior
attempt's session could NOT be carried forward to you: it was re-claimed on a
different host (or its transcript was pruned), so the earlier session's memory and
its working tree were BOTH LOST. Do NOT trust any recollection of prior work and do
NOT expect uncommitted edits — your cwd is a FRESH worktree checked out off
origin/$main_branch and holds none of the previous attempt's in-progress changes.

Only work a prior attempt COMMITTED and pushed (to $main_branch, or to a project PR
branch) and whatever it recorded in the journal survives. Treat this as a clean
start that must RE-DERIVE where the job stands: inspect committed history, any PR,
and the journal to see what is already done before redoing it, then drive the job
to completion. Re-read the job spec below and write ONLY the concise completion
report (what you did, what changed, any follow-ups) to stdout.

COMPLETION SIGNAL (required): ONLY when you have GENUINELY finished the job, emit
the exact line
    $GARDEN_COMPLETION_MARKER
as the very LAST line of your report, on its own line, as your final act. If you
still did NOT finish, do NOT emit that line — the job will be requeued and
resumed again rather than falsely recorded as done.

ORCHESTRATED FAILURE SIGNAL: If you genuinely finished but did NOT achieve a
gated outcome required by an orchestration, emit the exact line
    $GARDEN_ORCHESTRATION_FAILURE_MARKER
immediately BEFORE the completion signal. Do not type an
\`orchestration-failed:\` field into prose. The completion machinery stamps that
field into report frontmatter from this exact signal.

$handoff_note

$note

----- JOB $base -----
$(cat "$jobfile")
----- END JOB -----
EOF
  else
    cat <<EOF
You are a garden gardener (role brief: $role_brief). You have claimed job
'$base'. Its specification follows between the markers. Do the work it asks for,
then write a concise completion report (what you did, what changed, any
follow-ups) to stdout. Output ONLY the report.

COMPLETION SIGNAL (required): ONLY when you have GENUINELY finished the job, emit
the exact line
    $GARDEN_COMPLETION_MARKER
as the very LAST line of your report, on its own line, as your final act. This is
the deterministic signal that the job completed. If you did NOT finish — you ran
out of turns, hit a wall, or are unsure the work is done — do NOT emit that line;
the job will be requeued and resumed rather than falsely recorded as done.

ORCHESTRATED FAILURE SIGNAL: If you genuinely finished but did NOT achieve a
gated outcome required by an orchestration, emit the exact line
    $GARDEN_ORCHESTRATION_FAILURE_MARKER
immediately BEFORE the completion signal. Do not type an
\`orchestration-failed:\` field into prose. The completion machinery stamps that
field into report frontmatter from this exact signal.

$handoff_note

$note

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
  fi
}
