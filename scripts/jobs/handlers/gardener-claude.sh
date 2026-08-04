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
# shellcheck source=worker-common.sh
source "$HERE/worker-common.sh"     # shared worktree lifecycle + prompt (anti-drift)

base="${1:?base}"; jobfile="${2:?jobfile}"; report="${3:?report-out}"

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
worktree="$(worker_worktree_path "$base")"

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

# The per-job worktree lifecycle (ensure/reuse/reset) is the shared spine helper
# worker_ensure_worktree (handlers/worker-common.sh), called below after the
# stale-handler reap — so the claude and codex handlers cannot drift on it.

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
worker_ensure_worktree "$worktree" "$main_branch" "$resuming"

# The prompt framing is built by the shared spine helper so the claude and codex
# handlers stay byte-identical on the completion contract, the worktree note, and
# injection hygiene (design §2.2). The framing MODE is chosen honestly from the
# actual starting state, so the worker is never told it is resuming a session it
# does not have (issue #62 follow-up: a cross-host requeue loses transcript AND
# worktree, yet the old code emitted the plain fresh framing that hid the requeue):
#   * resuming        -> resume   (transcript present on THIS host; --resume attaches)
#   * requeue, no xcpt -> fallback (reaped >=1 but no local transcript: state was
#                                   lost cross-host/pruned; worktree recreated fresh)
#   * first claim      -> fresh    (no prior attempt)
# reap_count reads the reaper's `<!-- garden-reaped: N -->` marker (common.sh); N>0
# means a prior attempt existed even though its session/worktree did not survive to
# here. The session id is pinned the same either way so the NEXT death stays
# resumable.
if $resuming; then
  prompt_mode=resume
elif [ "$(reap_count "$jobfile")" -gt 0 ]; then
  prompt_mode=fallback
else
  prompt_mode=fresh
fi
prompt="$(worker_job_prompt "$base" "$jobfile" "$worktree" "$main_branch" "$prompt_mode")"

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
# The prompt framing (fresh/resume/fallback) was already chosen above from the same
# $resuming signal; here we only pick the CLI's session flag to match.
session_args=()
if [ -n "$session_id" ]; then
  if $resuming; then
    session_args=(--resume "$session_id")
    log "resuming session $session_id for requeued job '$base' in worktree $worktree"
  else
    session_args=(--session-id "$session_id")
    [ "$prompt_mode" = fallback ] && \
      log "requeued job '$base' has no local transcript on $GARDEN; prior session and worktree were lost — starting FRESH session $session_id with lost-state framing"
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
#      policy that runs `designer`/`builder` on Opus and classified mechanical
#      roles on Haiku or Sonnet without the producer having to name a model.
#      Unclassified roles ride the fleet default.
#
# Robustness (job spec): neither field present -> no `--model`, behavior UNCHANGED
# (the fleet default model). A blank/unknown explicit `model:` falls back to the
# default (no `--model`) and logs — a typo must never crash the tick — and does
# NOT silently drop to the role default, since naming `model:` at all signals an
# intent to override the role policy. A concrete `claude-*` id passes through.
model_args=()
requested_tier="$(job_tier "$jobfile" 2>/dev/null || true)"
requested_role="$(plan_role "$jobfile")"
# MENTAT IS AN AUTHORIZATION BOUNDARY, NOT A PRICE POINT. Fable/Mythos runs only
# on an explicitly maintainer-dispatched job; no automatic producer may reach it
# (skills/model-selection/SKILL.md). Everything else is a routine capability tier
# this handler serves.
if [ "$requested_tier" = mentat ] && [ "$(plan_field "$jobfile" dispatch)" != manual ]; then
  die "Claude handler accepts tier: mentat only on an explicit manual dispatch"
fi
if [ -n "$requested_tier" ]; then
  # ANTHROPIC MENTOR DOWNSHIFT (maintainer directive 2026-08-01). The closed
  # inventory puts claude-opus-5 at mentor, but the standing cost ceiling for
  # automatic fleet work is claude-opus-4-8. Rather than restate the inventory
  # (which the auction, the claim predicate, and the rate card all read), the
  # handler serves an AUTOMATIC mentor job at the minion model and says so.
  # An explicit `dispatch: manual` mentor job is honoured at mentor: a human
  # asking for Opus 5 by hand is not the automatic path this ceiling governs.
  serve_tier="$requested_tier"
  if [ "$requested_tier" = mentor ] && [ "$(plan_field "$jobfile" dispatch)" != manual ]; then
    serve_tier=minion
    log "job '$base' tier mentor -> serving at minion (anthropic automatic-work cost ceiling)"
  fi
  resolved_model="$(tier_model_for_provider "$serve_tier" anthropic)"
  if [ -n "$resolved_model" ]; then
    model_args=(--model "$resolved_model"); log "job '$base' resolved tier '$requested_tier' -> claude --model $resolved_model"
  else
    log "job '$base' requested unavailable tier '$requested_tier'; falling back to the default model (no --model)"
  fi
elif [ -n "$requested_role" ]; then
  resolved_model="$(role_default_model "$requested_role")"
  if [ -n "$resolved_model" ]; then
    model_args=(--model "$resolved_model")
    log "job '$base' role '$requested_role' -> default model claude --model $resolved_model"
  fi
fi

# Publish the resolved model to the environment the agent (and every gh call it
# makes) inherits, so the fleet's gh wrapper can stamp it into the GitHub-comment
# provenance footer (scripts/jobs/comment-provenance.sh). Empty when no --model is
# passed (the fleet default) — the footer then omits the model field (fail-open).
export GARDEN_JOB_MODEL="${resolved_model:-}"
export GARDEN_JOB_ROLE="$requested_role"
# Publish the job base too, so per-job helpers (scholar-staging-clone.sh) can key
# their isolated state by THIS job's unique base deterministically — a shared
# staging tree destroyed a peer's edits when the default was one fixed path
# (2026-07-29). The gardener still may pass --base explicitly; this is the
# handler-side default so isolation holds even when it does not.
export GARDEN_JOB_BASE="$base"

# --dangerously-skip-permissions: this is an autonomous, headless gardener with
# no human approver, so the default permission gate would deny every Bash/tool
# call (gh, git push, even `command -v gh`) and the gardener could do no real
# work. Bypass is the intended posture for the sandboxed fleet; the operator
# pre-consents via `skipDangerousModePermissionPrompt: true` in ~/.claude.
#
# The job runs with cwd = $worktree (a subshell `cd`), so every relative path the
# gardener touches lands in its own worktree. The report path is absolute (gardener.sh
# mktemp), so the redirect is unaffected by the cd.
#
# Resolve the CLI rather than trusting the inherited PATH, and treat a momentary
# absence as environmental, not as a defect in this job: a `systemd --user` unit
# carries no declared PATH, and an in-place `npm install -g` unlinks the global bin
# for seconds (common.sh § agent-CLI resolution — claude_bin retries, probes the
# known install locations, and die_environmental exits EX_TEMPFAIL so gardener.sh
# requeues the job instead of escalating it). The substitution must stay OUTSIDE
# die_environmental so its `exit` leaves the handler, not a subshell.
claude_cli="$(claude_bin)" \
  || die_environmental "claude CLI not found on PATH nor in any known install location after ${GARDEN_AGENT_BIN_ATTEMPTS} probes; cannot run default gardener handler for '$base'"

# The terminal JSON envelope is Claude's own cumulative accounting for exactly this
# invocation. Keep it outside the report: the report remains the agent's .result,
# while the code-only handoff gives gardener.sh the immutable measurement. Do not
# pass the handoff path into Claude's environment: an agent may run arbitrary shell
# commands, and must not be able to author or erase its own cost record.
envelope="$(mktemp "${TMPDIR:-/tmp}/garden-claude-envelope-$base.XXXXXX")"
rusage="$(mktemp "${TMPDIR:-/tmp}/garden-claude-rusage-$base.XXXXXX")"
set +e
if [ -x /usr/bin/time ]; then
  ( cd "$worktree" && /usr/bin/time -o "$rusage" -f '%U\t%S\t%M' env -u GARDEN_USAGE_FILE -u GARDEN_ENGAGEMENT_USAGE "$claude_cli" -p --output-format json --dangerously-skip-permissions "${session_args[@]}" "${model_args[@]}" "$prompt" ) > "$envelope"
else
  ( cd "$worktree" && env -u GARDEN_USAGE_FILE -u GARDEN_ENGAGEMENT_USAGE "$claude_cli" -p --output-format json --dangerously-skip-permissions "${session_args[@]}" "${model_args[@]}" "$prompt" ) > "$envelope"
fi
rc=$?
set -e
# A malformed/truncated envelope is an accounting miss, never a handler failure.
# Preserve a useful report on provider errors, and otherwise extract .result
# byte-for-byte enough for the existing completion-marker contract.
if command -v jq >/dev/null 2>&1 && jq -er '.result' "$envelope" > "$report" 2>/dev/null; then
  resolved_for_usage="${resolved_model:-}"
  usage_capture_result "${GARDEN_USAGE_FILE:-/dev/null}" "$resolved_for_usage" "$(cat "$envelope")" || true
  usage_capture_rusage "${GARDEN_USAGE_FILE:-/dev/null}" "$rusage" || true
else
  cp "$envelope" "$report" 2>/dev/null || : > "$report"
fi

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
rm -f "$envelope" "$rusage" 2>/dev/null || true
exit "$rc"
