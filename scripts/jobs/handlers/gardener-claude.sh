#!/bin/bash
# gardener-claude.sh — default gardener job handler: do the work via `claude -p`.
#
# Invoked by gardener.sh as: gardener-claude.sh <base> <job-file> <report-out>
# Wears the gardener role, performs the job described in <job-file>, and writes
# a completion report to <report-out>. The gardener role brief lives at
# roles/gardener/AGENT.md in the garden's main2 worktree.
#
# This is the production path. The test harness overrides GARDEN_JOB_HANDLER
# with a fast deterministic stub, so this file is not exercised by the gardener
# tests; its own behavior is covered by test/gardener-worktree-test.sh, which
# drives it directly with a fake `claude` on PATH.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"

base="${1:?base}"; jobfile="${2:?jobfile}"; report="${3:?report-out}"
role_brief="$GARDEN_ROOT/roles/gardener/AGENT.md"

# --- per-job worktree (the HARD RULE: no development in the root tree) --------
#
# Every developing subagent works in its own git worktree off the dev branch,
# never the deployed root checkout (designs/deliberate-deploy.md § All
# development in per-subagent worktrees, roles/COMMON.md § Scratch discipline).
# The norm is documented for the `claude -p` gardener to read each tick, but a
# prompt can forget; this is the MECHANICAL half. We launch `claude -p` with its
# cwd already set to a fresh per-job worktree off `origin/$GARDEN_MAIN_BRANCH`, so
# a job physically cannot edit the root tree even if its prompt does not say so.
#
# The worktree path is STABLE per job base (derived from the base, exactly like
# the session id below), NOT a per-attempt random suffix: a reaper requeue
# re-runs the SAME base, so the same path lets the resumed run re-enter the same
# worktree and find both its uncommitted work and its session transcript (whose
# project dir is keyed by this cwd). A random suffix would break resume.
#
# Lifecycle (constraints from the job spec):
#   * created off origin/$GARDEN_MAIN_BRANCH before launch;
#   * REUSED as-is on a resume (the in-flight work must survive the requeue);
#   * reset to a fresh base on a first claim that finds a stale leftover dir;
#   * torn down on successful completion (below), and GC-safe on death because it
#     lives under $GARDEN_SCRATCH, which the reaper's scratch janitor reclaims
#     after GARDEN_SCRATCH_GC_AGE hours of quiescence (common.sh, reaper.sh).
# It is a top-level child of $GARDEN_SCRATCH so the janitor GCs and deregisters
# it as one unit. The base is a job basename (no '/', '#', ':'), safe as a single
# path component.
main_branch="${GARDEN_MAIN_BRANCH:-main2}"
worktree="$GARDEN_SCRATCH/gardener-wt-$base"

# Resume detection keys on the session transcript, which Claude Code writes under
# ~/.claude/projects/<encoded-cwd>/<sid>.jsonl with every '/' in the launch cwd
# rewritten to '-'. Because the cwd is now the per-base worktree (not the gardener's
# stable launch dir), the encoded dir is derived from $worktree. The transcript's
# presence is also exactly the signal that distinguishes a RESUME (in-flight work
# to keep) from a FRESH claim that merely found a stale worktree dir to reset.
session_id="$(python3 -c 'import sys,uuid; print(uuid.uuid5(uuid.NAMESPACE_URL, "garden-job:"+sys.argv[1]))' "$base" 2>/dev/null || true)"
# Two candidate encodings are probed: slash-only (what this handler always
# used) and slash+dot (Claude Code encodes dots in some versions). Probing both
# keeps resume detection working whichever rule the installed CLI applies to a
# worktree path carrying a dot, instead of silently never matching (which sent
# every requeue down the --session-id branch to die in seconds on the existing
# session).
proj_dir="$HOME/.claude/projects/$(printf '%s' "$worktree" | sed 's#/#-#g')"
proj_dir_alt="$HOME/.claude/projects/$(printf '%s' "$worktree" | sed 's#[/.]#-#g')"
resuming=false
if [ -n "$session_id" ] && { [ -f "$proj_dir/$session_id.jsonl" ] || [ -f "$proj_dir_alt/$session_id.jsonl" ]; }; then
  resuming=true
fi

# ensure_worktree — make $worktree a detached checkout of origin/$main_branch.
# On a resume we keep whatever is there (the interrupted attempt's uncommitted
# work); otherwise we (re)create it fresh at the current dev-branch tip. We base
# off the LOCAL tracking ref origin/$main_branch — kept fresh by the watchman's
# fetch — rather than fetching here, so the launch path adds no per-job network
# cost; the CAS push loop the job itself runs reconciles any staleness. Falls
# back to the bare branch then HEAD if the tracking ref is absent (a freshly
# cloned root that has never fetched).
ensure_worktree() {
  if $resuming && [ -d "$worktree" ]; then
    return 0                          # resume: reuse the in-flight worktree as-is
  fi
  # Fresh claim. A leftover dir (stale completion that never cleaned up, or a
  # requeue whose transcript was pruned) is removed and recreated so the job
  # starts from a clean current-tip checkout, never a stale base.
  [ -e "$worktree" ] && scratch_cleanup "$worktree"
  local ref
  for ref in "origin/$main_branch" "$main_branch" HEAD; do
    if git -C "$GARDEN_ROOT" rev-parse --verify --quiet "$ref" >/dev/null 2>&1; then
      mkdir -p "$GARDEN_SCRATCH"
      git -C "$GARDEN_ROOT" worktree add --detach "$worktree" "$ref" >/dev/null 2>&1 && return 0
    fi
  done
  die "could not create per-job worktree $worktree off any of origin/$main_branch, $main_branch, HEAD"
}

# --- close the two-writer window BEFORE we touch the worktree -----------------
#
# A reaper requeue re-runs the SAME base; the worktree path above is deterministic
# from the base, so a re-claim on THIS host re-enters the identical $worktree. If a
# prior incarnation's `claude -p` (or a child that outlived it) is STILL RUNNING
# there — the requeue fired on a reap-now hint or the claim TTL while the handler
# was alive, or the wrapper's `timeout` orphaned a subprocess — then either path
# below is unsafe: a FRESH claim's ensure_worktree would `rm -rf` the tree out from
# under a live writer, and a RESUME would launch a second claude that interleaves
# edits with it (the endo-but-for-bots #58 corruption class). So reap any live
# predecessor rooted in this worktree first. This is same-host by construction (the
# only case a worktree is shared); a cross-host re-claim got a fresh worktree above
# and cannot collide. See common.sh § kill_stale_worktree_handlers.
kill_stale_worktree_handlers "$worktree"
ensure_worktree

jobs_dir="$GARDEN_ROOT/scripts/jobs"
worktree_note="$(cat <<EOF
Your working directory is a dedicated git worktree for THIS job, checked out off
origin/$main_branch at $worktree. Do ALL development for this job here, in your
cwd: never edit the deployed garden root checkout. Commit explicit pathspecs and
push with a rebase CAS loop to $main_branch (git push origin HEAD:$main_branch).
The worktree is torn down when you finish and is garbage-collected if your run
dies, so nothing you need to keep should live outside a commit.

That cwd worktree is for GARDEN development (roles, skills, scripts on $main_branch).
If this job instead mutates a PROJECT repo (a fork like endojs/endo-but-for-bots
— editing its source, pushing to a PR head branch), do NOT hand-name a project
checkout keyed by the repo or PR number: a peer gardener working the SAME PR would
collide into your working tree and your concurrent edits would corrupt each other
(the endo-but-for-bots #58 corruption). Get an ISOLATED project checkout, keyed by
THIS job's unique base, with:
    $jobs_dir/ensure-project-worktree.sh $base <owner/repo> <branch>
It prints the absolute path (a detached checkout under $GARDEN_SCRATCH, stable
across a requeue so you resume in-flight work); cd there and do the project work.
Concurrent same-branch pushes still race at the git-push CAS — that is fine; the
working trees must never be shared.
EOF
)"

prompt="$(cat <<EOF
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

$worktree_note

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
#                     if that session's transcript is present on this host (its
#                     project dir is keyed by the per-base worktree cwd, which is
#                     also stable) we `--resume <sid>` and nudge it to finish.
# Determinism is what lets the reaper stay a dumb requeue: no session id has to
# be plumbed through the board because the base alone reproduces it AND the
# worktree it ran in.
#
# Resume is best-effort and same-host: a transcript lives under
# ~/.claude/projects/<encoded-cwd>/<sid>.jsonl on the host that wrote it. If the
# requeue is claimed on another host (or the transcript was pruned) $resuming is
# false above, ensure_worktree recreated a fresh worktree, and we fall back to a
# fresh session pinned to the same id so the NEXT death stays resumable.
session_args=()
if [ -n "$session_id" ]; then
  if $resuming; then
    session_args=(--resume "$session_id")
    log "resuming session $session_id for requeued job '$base' in worktree $worktree"
    prompt="$(cat <<EOF
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

$worktree_note

----- JOB $base -----
$(cat "$jobfile")
----- END JOB -----
EOF
)"
  else
    session_args=(--session-id "$session_id")
  fi
fi

# --- model selection: explicit per-job override, then role default -----------
#
# The model for THIS job is resolved from its leading YAML frontmatter in two
# steps, with the explicit override winning:
#
#   1. An explicit `model:` field requests a specific Claude model for this job
#      (e.g. the maintainer wants the README tutorial job on Fable). The short
#      tier names bind to concrete ids in resolve_model_tier (common.sh) — the
#      SAME map the Agent-dispatch path follows via skills/model-selection.
#   2. Absent an explicit (valid) `model:`, the job's `role:` field selects a
#      per-role DEFAULT model via role_default_model (common.sh): the canonical
#      policy that runs a `designer` job on Fable and a `builder` job on Opus
#      without the producer having to name a model. Every other role is unpinned
#      and rides the fleet default.
#
# Robustness (job spec): neither field present -> no `--model`, behavior UNCHANGED
# (the fleet default model). A blank/unknown explicit `model:` falls back to the
# default (no `--model`) and logs — a typo must never crash the tick — and does
# NOT silently drop to the role default, since naming `model:` at all signals an
# intent to override the role policy. A concrete `claude-*` id passes through.
model_args=()
requested_model="$(plan_field "$jobfile" model)"
requested_role="$(plan_role "$jobfile")"
if [ -n "$requested_model" ]; then
  resolved_model="$(resolve_model_tier "$requested_model")"
  if [ -n "$resolved_model" ]; then
    model_args=(--model "$resolved_model")
    log "job '$base' requested model '$requested_model' -> claude --model $resolved_model"
  else
    log "job '$base' requested unknown model '$requested_model'; falling back to the default model (no --model)"
  fi
elif [ -n "$requested_role" ]; then
  resolved_model="$(role_default_model "$requested_role")"
  if [ -n "$resolved_model" ]; then
    model_args=(--model "$resolved_model")
    log "job '$base' role '$requested_role' -> default model claude --model $resolved_model"
  fi
fi

# --dangerously-skip-permissions: this is an autonomous, headless gardener with
# no human approver, so the default permission gate would deny every Bash/tool
# call (gh, git push, even `command -v gh`) and the gardener could do no real
# work. Bypass is the intended posture for the sandboxed fleet; the operator
# pre-consents via `skipDangerousModePermissionPrompt: true` in ~/.claude.
#
# The job runs with cwd = $worktree (a subshell `cd`), so every relative path the
# gardener touches lands in its own worktree. The report path is absolute (gardener.sh
# mktemp), so the redirect is unaffected by the cd.
command -v claude >/dev/null 2>&1 \
  || die "claude not on PATH; cannot run default gardener handler for '$base'"

set +e
( cd "$worktree" && claude -p --dangerously-skip-permissions "${session_args[@]}" "${model_args[@]}" "$prompt" ) > "$report"
rc=$?
set -e

# --- deterministic completion signal -----------------------------------------
#
# gardener.sh gates doin→tada on the PRESENCE of the sentinel at
# GARDEN_COMPLETION_SENTINEL, NOT on this handler's exit code (common.sh § job
# completion signal). Write that sentinel ONLY when the worker GENUINELY finished:
# `claude` exited 0 AND its report's final line is GARDEN_COMPLETION_MARKER (the
# worker's instructed final act). A `claude` that exited 0 without finishing —
# quota/usage cut mid-response, a swallowed API error, or an unsatisfying run that
# never reached the final act — leaves the marker absent, so no sentinel is
# written and gardener.sh requeues the job instead of recording it done and losing
# it in tada. Strip the marker before it lands in the human-facing tada report.
if [ "$rc" -eq 0 ] && [ -n "${GARDEN_COMPLETION_SENTINEL:-}" ] && report_has_completion_marker "$report"; then
  strip_completion_marker "$report"
  : > "$GARDEN_COMPLETION_SENTINEL"
fi

# Teardown on genuine COMPLETION only — keyed on the same completion signal
# gardener.sh gates on, NOT the bare exit code. A clean-but-unfinished exit-0
# (no marker → no sentinel) is going to be REQUEUED, so its worktree must survive
# for the resumed run exactly like a non-zero failure's does. A truly dead job's
# worktree is reclaimed by the reaper's scratch janitor after
# GARDEN_SCRATCH_GC_AGE hours of quiescence.
if [ -n "${GARDEN_COMPLETION_SENTINEL:-}" ] && [ -e "$GARDEN_COMPLETION_SENTINEL" ]; then
  scratch_cleanup "$worktree"
  # Spool the finished transcript into the capture archive BEFORE the rm below
  # retires it (designs/transcript-journal-capture.md). transcript_spool is
  # offline-safe and never fails the handler; it gzip-copies whichever candidate
  # encoding exists into $GARDEN_TRANSCRIPTS_SPOOL and the hourly capture timer
  # drains it. Carrying $base records the job identity authoritatively.
  transcript_spool "$proj_dir/$session_id.jsonl" "$base"
  transcript_spool "$proj_dir_alt/$session_id.jsonl" "$base"
  # Retire the session transcript too. The session id is DETERMINISTIC from the
  # base, so a later re-post of a drained base would otherwise find this
  # finished session and --resume it: a model whose history ends "job finished,
  # marker emitted" under a prompt asserting its old worktree still exists is
  # primed to re-emit the report and completion marker WITHOUT doing the newly
  # requested work — a silent false completion. A re-posted base must start a
  # fresh session against its fresh worktree.
  rm -f "$proj_dir/$session_id.jsonl" "$proj_dir_alt/$session_id.jsonl" 2>/dev/null || true
fi
exit "$rc"
