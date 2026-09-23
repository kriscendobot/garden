#!/bin/bash
# monk-claude.sh — default handler for the Anthropic worker kind (monk): do the work
# via `claude -p`. This is the implementation the legacy handlers/gardener-claude.sh
# forwards to (a monk IS the renamed Anthropic gardener; design
# anthropic-worker-kind-monk.md § Shared spine and handlers). Both the monk registry
# row and the legacy gardener row resolve to this one file.
#
# Invoked by gardener.sh as: monk-claude.sh <base> <job-file> <report-out>
# Wears the job's task role, performs the job described in <job-file>, and writes
# a completion report to <report-out>. The generic worker role brief lives at
# roles/gardener/AGENT.md in the garden's main2 worktree (the SPINE role, which the
# rename deliberately leaves generic — every worker kind is a gardener).
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

# --- worker kind + provider (this handler serves BOTH claude-backed kinds) -----
#
# The SAME claude handler drives two worker kinds, distinguished by their registry
# `provider` field (common.sh worker-kind registry), exactly as cleric-codex.sh drives
# the paid-OpenAI cleric and the LOCAL hermit off one file: the canonical Anthropic
# `monk` (provider=anthropic, the real API) and the `friar` (provider=ollama-cloud),
# Claude Code pointed at Ollama Cloud's Anthropic-compatible endpoint. Everything below
# that differs between the two — the model-tier map it resolves against, the automatic
# cost-ceiling downshift (an anthropic-only policy), and the auth environment injected
# around the `claude -p` call — keys off $provider. The spine exports
# GARDEN_WORKER_KIND; default to monk for a standalone invocation. The legacy
# `gardener` spelling forwards here and resolves to provider=anthropic too.
KIND="${GARDEN_WORKER_KIND:-monk}"
provider="$(worker_kind_field "$KIND" provider 2>/dev/null || echo anthropic)"

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
#   * resuming, and the prior attempt STOPPED (ended its turn cleanly without the
#     completion signal, recorded by the unfinished marker below) -> continue: the
#     session was not interrupted, so it is told it stopped without completing and
#     asked to verify the deliverable and complete (never a bare resume of a
#     finished session; fix-finished-but-not-completed-requeue).
# The unfinished marker lives in the worktree's private git admin dir, so it exists
# only while this same-host worktree does and is never committed.
unfinished_marker="$(git -C "$worktree" rev-parse --absolute-git-dir 2>/dev/null || true)"
[ -n "$unfinished_marker" ] && unfinished_marker="$unfinished_marker/garden-unfinished-end-turn"
if $resuming && [ -n "$unfinished_marker" ] && [ -e "$unfinished_marker" ]; then
  prompt_mode="continue"
elif $resuming; then
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
  # ANTHROPIC AUTOMATIC CEILING = claude-opus-5-5 (design opus55-tier.md, Option B,
  # resolved 2026-09-23). Opus 5.5 is cheaper than the former ceiling (Opus 4.8) and
  # succeeds the mentor-tier Opus 5, so automatic mentor work now runs at the mentor
  # model itself — the first-match anthropic mentor row (claude-opus-5-5). There is
  # no longer an anthropic mentor->minion downshift: the tier a job requests is the
  # tier it is served at, for every provider. Automatic effort is `medium`, which is
  # Opus 5.5's own default, so no effort flag is plumbed here.
  serve_tier="$requested_tier"
  resolved_model="$(tier_model_for_provider "$serve_tier" "$provider")"
  if [ -n "$resolved_model" ]; then
    model_args=(--model "$resolved_model"); log "job '$base' resolved tier '$requested_tier' -> claude --model $resolved_model"
  else
    log "job '$base' requested unavailable tier '$requested_tier'; falling back to the default model (no --model)"
  fi
elif [ -n "$requested_role" ]; then
  resolved_model="$(role_default_model "$KIND" "$requested_role")"
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

# Hard CALL-level ceiling.  The tier supplies the maximum and the freshest true
# seven-day provider utilization in the journal scales it to remaining headroom.
# Claim admission already failed closed on an untrustworthy configured pool; this
# bound is the independent belt that limits one invocation after admission.
journal_dir="$(dirname "$(dirname "$(dirname "$jobfile")")")"
budget_tier="${serve_tier:-${requested_tier:-$(role_default_tier "$requested_role")}}"
max_budget_usd="$(claude_call_budget_usd "$budget_tier" "$journal_dir")"
export GARDEN_CLAUDE_CALL_BUDGET_USD="$max_budget_usd"
log "job '$base' call ceiling: tier=$budget_tier max-budget-usd=$max_budget_usd (scaled by fresh seven-day headroom when available)"

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

# --- provider auth injection (the ONE thing that differs at the claude call) ---
#
# provider=anthropic (monk/gardener) runs against the real Anthropic API with the
# ambient ANTHROPIC_API_KEY — the array stays EMPTY, so its invocation is byte-for-byte
# what it always was. provider=ollama-cloud (friar) points the SAME `claude -p` at
# Ollama Cloud's Anthropic-compatible endpoint instead: set ANTHROPIC_BASE_URL to
# https://ollama.com, pass the maintainer-supplied OLLAMA_CLOUD_API_KEY as
# ANTHROPIC_AUTH_TOKEN (Ollama Cloud wants `Authorization: Bearer`, NOT x-api-key), and
# clear ANTHROPIC_API_KEY so the CLI cannot fall back to a real Anthropic key. The vars
# are scoped to the child via `env NAME=VAL` on the invocation below — never exported
# into the handler — so no other line of the run sees them. A missing key here is an
# environmental defect (arm OLLAMA_CLOUD_API_KEY on the host and rebuild the image), so
# it requeues rather than escalating the job.
provider_auth_env=()
if [ "$provider" = ollama-cloud ]; then
  [ -n "${OLLAMA_CLOUD_API_KEY:-}" ] \
    || die_environmental "OLLAMA_CLOUD_API_KEY unset; the friar (provider=ollama-cloud) cannot authenticate to Ollama Cloud for '$base'"
  provider_auth_env=(
    "ANTHROPIC_BASE_URL=https://ollama.com"
    "ANTHROPIC_AUTH_TOKEN=$OLLAMA_CLOUD_API_KEY"
    "ANTHROPIC_API_KEY="
  )
fi

# The terminal JSON envelope is Claude's own cumulative accounting for exactly this
# invocation. Keep it outside the report: the report remains the agent's .result,
# while the code-only handoff gives gardener.sh the immutable measurement. Do not
# pass the handoff path into Claude's environment: an agent may run arbitrary shell
# commands, and must not be able to author or erase its own cost record.
envelope="$(mktemp "${TMPDIR:-/tmp}/garden-claude-envelope-$base.XXXXXX")"
rusage="$(mktemp "${TMPDIR:-/tmp}/garden-claude-rusage-$base.XXXXXX")"
# NESTED-`claude -p` metering (designs/panel-seat-metering-and-tiering.md): snapshot
# the job's session-log usage BEFORE the top-level call so the after-snapshot delta
# below captures every nested subprocess `claude -p` (panel juror seats, the panel
# decider/appellate) the top-level envelope structurally cannot see. Taken here, in
# the handler (outside the agent, which runs with GARDEN_USAGE_FILE unset), and BEFORE
# the completion teardown removes the top-level transcript.
usage_before_nested="$(meter_job_session_usage "$base" 2>/dev/null || true)"

# --- run `claude -p` in a MANAGED process group, and reap its whole tree on exit -
#
# THE HAZARD (garden-monk@N left-over `node`): `claude -p` spawns a node runtime
# tree (MCP servers, tool subprocesses) and some of those children detach into
# their OWN process group/session (setsid). If this handler exits — normally, on a
# crash, or when the gardener's timeout wall SIGTERMs it — before that tree is fully
# reaped, the orphaned `node` processes survive headless and only the NEXT worker
# start's cgroup sweep (reap_stale_worker_cgroup) notices them, which is exactly the
# "worker repeatedly starts with left-over node" symptom.
#
# We close it at the handler boundary. `set -m` launches the `claude -p` subshell as
# its own process-group leader (its pgid == the captured pid), so the runtime tree
# is addressable as one unit. A cleanup trap then runs reap_process_tree (common.sh
# § reap_process_tree): a /proc descendant walk plus a group SIGTERM->grace->SIGKILL
# that BLOCKS until the tree drains — so this handler cannot return before its Claude
# runtime tree is fully reaped. The trap is armed on EXIT (belt for the normal and
# self-exit paths) and on the wall signals (TERM/INT/HUP), where it runs while the
# runtime is STILL ALIVE so the descendant walk captures a setsid child by pid
# before it can reparent away. gardener.sh still reaps the handler's own group after
# we return (unconditional backstop), so this is defence in depth, not a replacement.
: "${GARDEN_MONK_CLAUDE_REAP_GRACE:=5}"
: "${GARDEN_MONK_CLAUDE_DRAIN_TIMEOUT:=15}"   # grace+drain (20s) stays well under GARDEN_HANDLER_KILL_AFTER (60s)
claude_pgid=""
claude_reap() {
  [ -n "$claude_pgid" ] || return 0
  reap_process_tree "$claude_pgid" "$GARDEN_MONK_CLAUDE_REAP_GRACE" "$GARDEN_MONK_CLAUDE_DRAIN_TIMEOUT" || true
}
# Arm cleanup before the first launch (a no-op until a group id is known). On a wall
# signal, reap the (still-live) tree, then exit with the conventional 128+signo so the
# outcome is unambiguous; the EXIT trap re-runs the reap as a fast no-op once the tree
# is already gone.
trap 'claude_reap' EXIT
trap 'claude_reap; exit 143' TERM
trap 'claude_reap; exit 130' INT
trap 'claude_reap; exit 129' HUP

# claude_call <max-budget-usd> <prompt> <session-arg>... — run ONE `claude -p`
# invocation into $envelope and reap its whole runtime tree before returning (so a
# later call in this same handler never shares a worktree with a leftover writer, and
# the background tasks an ended session abandoned die with it). Sets $rc to the CLI's
# exit status. The handler may make up to 1 + GARDEN_COMPLETION_NUDGES calls.
claude_call() {
  local call_budget="$1" call_prompt="$2"; shift 2
  set +e
  set -m
  if [ -x /usr/bin/time ]; then
    ( cd "$worktree" && /usr/bin/time -o "$rusage" -f '%U\t%S\t%M' env -u GARDEN_USAGE_FILE -u GARDEN_ENGAGEMENT_USAGE "${provider_auth_env[@]}" "$claude_cli" -p --output-format stream-json --verbose --dangerously-skip-permissions --max-budget-usd "$call_budget" "$@" "${model_args[@]}" "$call_prompt" ) > "$envelope" &
  else
    ( cd "$worktree" && env -u GARDEN_USAGE_FILE -u GARDEN_ENGAGEMENT_USAGE "${provider_auth_env[@]}" "$claude_cli" -p --output-format stream-json --verbose --dangerously-skip-permissions --max-budget-usd "$call_budget" "$@" "${model_args[@]}" "$call_prompt" ) > "$envelope" &
  fi
  claude_pgid=$!
  set +m
  wait "$claude_pgid"; rc=$?
  claude_reap
  claude_pgid=""
  set -e
}

# claude_parse — classify the call just made. The stream is newline-delimited
# events. Validate every line and require exactly one terminal result event
# (common.sh § claude_stream_result): a truncated stream or a stream with no result
# is an authoritative transient failure, never a clean completion. Sets $outcome and
# $result_event, writes $report and the private usage handoff for THIS call.
claude_parse() {
  result_event="$(claude_stream_result "$envelope" 2>/dev/null || true)"
  rate_event=""
  if [ -n "$result_event" ]; then
    outcome="$(claude_result_outcome "$result_event")"
    rate_event="$(jq -cs '[.[]|select(.type=="rate_limit_event")]|last//empty' "$envelope" 2>/dev/null || true)"
    if jq -er '.result | strings' <<<"$result_event" > "$report" 2>/dev/null; then :; else
      jq -r '"Claude CLI ended with structured outcome: " + (.subtype//.terminal_reason//"unknown")' <<<"$result_event" > "$report"
    fi
    usage_capture_result "${GARDEN_USAGE_FILE:-/dev/null}" "${resolved_model:-}" "$result_event" || true
    [ -z "$rate_event" ] || usage_capture_rate_limit "${GARDEN_USAGE_FILE:-/dev/null}" "$rate_event" || true
    if [ -s "${GARDEN_USAGE_FILE:-/dev/null}" ]; then
      jq --arg outcome "$outcome" '. + {terminal_outcome:$outcome}' "${GARDEN_USAGE_FILE:-/dev/null}" \
        > "${GARDEN_USAGE_FILE:-/dev/null}.tmp" 2>/dev/null \
        && mv "${GARDEN_USAGE_FILE:-/dev/null}.tmp" "${GARDEN_USAGE_FILE:-/dev/null}" || true
    fi
    usage_capture_rusage "${GARDEN_USAGE_FILE:-/dev/null}" "$rusage" || true
  else
    outcome=transient-failure
    printf 'Claude CLI stream was truncated or ended without exactly one result event.\n' > "$report"
    printf '{"source":"none","terminal_outcome":"transient-failure","terminal":{"stream_valid":false}}\n' > "${GARDEN_USAGE_FILE:-/dev/null}" 2>/dev/null || true
  fi
}

# Feed the structured verdict into the existing requeue/quarantine/doom spine.
# Budget exhaustion is a normal bounded stop, not a job defect; quota cuts and
# malformed streams are likewise transient.  Policy refusals carry the existing
# narrow control-plane wording so the reaper quarantines them.  Other API errors
# remain real failures and surface rather than looping blindly.
claude_map_rc() {
  case "$outcome" in
    complete-candidate) : ;;
    budget-stop)
      printf 'Claude structured budget stop: max budget USD exhausted; requeueing bounded work.\n' >&2
      rc="${GARDEN_OFFLINE_RC:-75}"
      ;;
    quota-cut)
      printf 'Claude structured quota cut: usage limit reached; requeueing after provider backoff.\n' >&2
      rc="${GARDEN_OFFLINE_RC:-75}"
      ;;
    policy-refusal)
      printf 'Claude request was blocked by our usage policy (structured provider policy refusal).\n' >&2
      rc=1
      ;;
    api-error)
      printf 'Claude structured API error (status=%s).\n' "$(jq -r '.api_error_status//"unknown"' <<<"$result_event")" >&2
      rc=1
      ;;
    *)
      printf 'Claude structured transient failure; requeueing.\n' >&2
      rc="${GARDEN_OFFLINE_RC:-75}"
      ;;
  esac
}

# unfinished_end_turn — 0 iff the call just made ended CLEANLY (end_turn, rc 0) but
# its report lacks the completion marker: the session stopped rather than finished.
unfinished_end_turn() {
  [ "$outcome" = complete-candidate ] && [ "$rc" -eq 0 ] && ! report_has_completion_marker "$report"
}

claude_call "$max_budget_usd" "$prompt" "${session_args[@]}"
claude_parse
claude_map_rc

# --- in-process completion nudge (fix-finished-but-not-completed-requeue) -----
#
# A session that ends its turn cleanly WITHOUT the completion marker has usually
# DONE the work (committed, pushed, opened the PR) and then stopped — most often
# after backgrounding a CI wait or a Monitor and ending its turn "until notified",
# which headless never happens. Requeueing it costs a whole claim cycle, a doom or
# stage-retry tick, and (before the stream fix) a resume that died in seconds. So
# while the worktree and session are still warm, resume the SAME session once in
# THIS process with the explicit continuation prompt: "you stopped without
# completing; verify the deliverable and complete now". Bounded by
# GARDEN_COMPLETION_NUDGES (default 1; 0 disables) and by the call ceiling's
# REMAINING headroom (skipped under GARDEN_COMPLETION_NUDGE_MIN_USD), so it can
# never spend past what a single call was allowed. The nudge's usage is summed into
# the one handoff record so the ledger stays whole.
: "${GARDEN_COMPLETION_NUDGES:=1}"
: "${GARDEN_COMPLETION_NUDGE_MIN_USD:=0.50}"
case "$GARDEN_COMPLETION_NUDGES" in ''|*[!0-9]*) GARDEN_COMPLETION_NUDGES=0 ;; esac
nudges=0
while [ "$nudges" -lt "$GARDEN_COMPLETION_NUDGES" ] && [ -n "$session_id" ] && unfinished_end_turn; do
  spent="$(jq -r '.total_cost_usd // 0' <<<"${result_event:-{\}}" 2>/dev/null || echo 0)"
  nudge_budget="$(awk -v m="$max_budget_usd" -v s="${spent:-0}" 'BEGIN{r=m-s; if (r<0) r=0; printf "%.2f", r}')"
  if ! awk -v r="$nudge_budget" -v f="$GARDEN_COMPLETION_NUDGE_MIN_USD" 'BEGIN{exit !(r+0 >= f+0)}'; then
    log "job '$base' ended its turn without the completion signal; no completion nudge (remaining call budget USD $nudge_budget < $GARDEN_COMPLETION_NUDGE_MIN_USD)"
    break
  fi
  nudges=$((nudges + 1))
  log "job '$base' ended its turn without the completion signal; nudging the same session to verify and complete (nudge $nudges/$GARDEN_COMPLETION_NUDGES, budget USD $nudge_budget)"
  prior_usage=""
  [ -s "${GARDEN_USAGE_FILE:-/dev/null}" ] && prior_usage="$(cat "$GARDEN_USAGE_FILE" 2>/dev/null || true)"
  cp "$report" "$report.pre-nudge" 2>/dev/null || true
  nudge_prompt="$(worker_job_prompt "$base" "$jobfile" "$worktree" "$main_branch" continue)"
  claude_call "$nudge_budget" "$nudge_prompt" --resume "$session_id"
  claude_parse
  claude_map_rc
  # Sum the calls into one handoff: additive counters add, the terminal verdict and
  # rate-limit sample are the last call's.
  if [ -n "$prior_usage" ] && [ -s "${GARDEN_USAGE_FILE:-/dev/null}" ]; then
    jq --argjson p "$prior_usage" --argjson n "$nudges" '
      reduce ("num_turns","elapsed_s","input_tokens","output_tokens","cache_creation_tokens",
              "cache_read_tokens","total_cost_usd","cpu_user_ms","cpu_sys_ms") as $k (.;
        if ($p[$k] != null) then .[$k] = ((.[$k] // 0) + $p[$k]) else . end)
      + {completion_nudges:$n}' "$GARDEN_USAGE_FILE" > "$GARDEN_USAGE_FILE.tmp" 2>/dev/null \
      && mv "$GARDEN_USAGE_FILE.tmp" "$GARDEN_USAGE_FILE" || rm -f "$GARDEN_USAGE_FILE.tmp"
  fi
  # A nudge that itself failed to produce a report must not erase the first
  # session's report (the requeue diagnostics and any later human read it).
  if [ ! -s "$report" ] || [ "$outcome" != complete-candidate ]; then
    { cat "$report.pre-nudge" 2>/dev/null; printf '\n[completion nudge: %s]\n' "$outcome"; cat "$report" 2>/dev/null; } > "$report.merged" \
      && mv "$report.merged" "$report"
  fi
  rm -f "$report.pre-nudge"
done

# Close the nested-`claude -p` metering hole: when this handler supervised a panel
# (or any nested `claude -p`), the envelopes just captured account only for the
# top-level session. Augment the handoff with the COMPLETE session-log delta over
# the job's own worktree dirs — measured before the completion teardown below
# retires the top-level transcript — so the per-job ledger approximates real spend
# (designs/panel-seat-metering-and-tiering.md). No-op for a plain job (delta ~=
# envelope); best-effort and never fatal.
if [ -n "$result_event" ]; then
  usage_after_nested="$(meter_job_session_usage "$base" 2>/dev/null || true)"
  augment_usage_with_session_delta "${GARDEN_USAGE_FILE:-/dev/null}" \
    "$usage_before_nested" "$usage_after_nested" "${resolved_model:-}" || true
fi

# Remember, in the worktree's private admin dir, that this attempt STOPPED without
# completing (as opposed to being interrupted), so the next same-host claim resumes
# with the honest `continue` framing rather than "you were interrupted".
if [ -n "$unfinished_marker" ]; then
  if unfinished_end_turn; then : > "$unfinished_marker" 2>/dev/null || true
  else rm -f "$unfinished_marker" 2>/dev/null || true; fi
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
if [ "$outcome" = complete-candidate ] && [ "$rc" -eq 0 ] && [ -n "${GARDEN_COMPLETION_SENTINEL:-}" ] && report_has_completion_marker "$report"; then
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
