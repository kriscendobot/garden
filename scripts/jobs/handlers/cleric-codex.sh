#!/bin/bash
# cleric-codex.sh — the cleric job handler: do the work via `codex` (OpenAI).
#
# Invoked by the shared worker spine (gardener.sh) EXACTLY as the claude handler is:
#     cleric-codex.sh <base> <job-file> <report-out>
# It wears the gardener role brief (a cleric is a codex-backed gardener), performs
# the job described in <job-file>, and writes a completion report to <report-out>.
# It obeys the SAME completion contract the spine gates on: write the sentinel at
# GARDEN_COMPLETION_SENTINEL iff codex exited 0 AND the report's final line is
# GARDEN_COMPLETION_MARKER. It shares the per-job worktree lifecycle and the prompt
# text with the claude handler via handlers/worker-common.sh, so the two backends
# cannot drift on injection hygiene or the completion contract (design §1.1/§2.2,
# cleric-worker-bid-auction-reputation.md).
#
# This is a PRODUCTION path, not exercised by the automated gardener tests (those
# stub GARDEN_JOB_HANDLER). Its own behavior needs a live codex CLI to exercise.
#
# LIVE-CLI PROVENANCE / TODO: the flag surface below (codex exec, -m,
# -c model_reasoning_effort=, --output-last-message, --json, --skip-git-repo-check,
# --dangerously-bypass-approvals-and-sandbox, codex login status, codex exec resume)
# is transcribed from designs/provider-model-catalog.md (verified live on
# codex-cli 0.144.3) and designs/cleric-worker-bid-auction-reputation.md §1.1. codex
# was NOT installed in the build worktree that authored this file, so the session-id
# parse (§ resume) and the usage-event field names (§2.3, deferred) MUST be
# re-verified on a host where `codex` is on PATH before the first real cleric job —
# the catalog warns the CLI surface is server-resolved and living.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"
# shellcheck source=worker-common.sh
source "$HERE/worker-common.sh"     # shared worktree lifecycle + prompt (anti-drift)
# shellcheck source=codex-provider-common.sh
source "$HERE/codex-provider-common.sh" # shared Codex/OpenAI/Ollama conventions

base="${1:?base}"; jobfile="${2:?jobfile}"; report="${3:?report-out}"
main_branch="${GARDEN_MAIN_BRANCH:-main2}"
worktree="$(worker_worktree_path "$base")"

# --- worker kind + provider (this handler serves BOTH codex-backed kinds) ------
#
# The SAME Codex handler drives two worker kinds, distinguished by their registry
# `provider` field (common.sh worker-kind registry): the paid-OpenAI `cleric`
# (provider=openai), LOCAL `hermit` (provider=local), and explicit Fireworks
# `fireworker` (provider=fireworks). Kimi intentionally has its own official CLI
# handler. Everything below that differs between the Codex kinds: the tier map,
# fleet-default model, auth/reachability preflight, and provider route key off
# $provider. The spine exports
# GARDEN_WORKER_KIND; default to cleric for a standalone invocation.
KIND="${GARDEN_WORKER_KIND:-cleric}"
provider="$(worker_kind_field "$KIND" provider 2>/dev/null || echo openai)"
state_ns="$(worker_kind_field "$KIND" state_ns 2>/dev/null || echo clerics)"
[ "$provider" != fireworks ] || [ "$KIND" = fireworker ] || die "Fireworks provider requires the fireworker kind"
# --- session resume across a reaper requeue ----------------------------------
#
# codex assigns its OWN session UUID (no deterministic-session-id analogue of the
# claude handler's uuid5(base)). We parse the session id from codex's --json stream
# (below) and persist it in a per-base sidecar under $GARDEN_STATE — which survives
# the worktree-teardown races and is removed on completion — so a requeue with a
# live sidecar can resume via `codex exec resume <sid>`. Resume is best-effort and
# same-host; if the sidecar is absent (fresh claim, or requeue on another host) we
# start a fresh session over whatever the worktree holds. The spine's requeue
# semantics do not depend on backend resume: the uncommitted work carries the state.
session_sidecar="$GARDEN_STATE/$state_ns/sessions/$base"
resuming=false
resume_sid=""
if [ -s "$session_sidecar" ] && [ -d "$worktree" ]; then
  resume_sid="$(tr -dc 'A-Za-z0-9-' < "$session_sidecar" 2>/dev/null | head -c 200 || true)"
  [ -n "$resume_sid" ] && resuming=true
fi

# --- close the two-writer window BEFORE we touch the worktree -----------------
#
# A reaper requeue re-runs the SAME base into the SAME deterministic worktree path;
# reap any live predecessor codex process rooted there first, so a fresh claim does
# not rm the tree out from under a live writer and a resume does not launch a second
# codex interleaving edits (the endo-but-for-bots #58 corruption class).
# kill_stale_worktree_handlers keys on the worktree path, not the binary name, so it
# covers the codex process tree exactly as it covers claude's.
kill_stale_worktree_handlers "$worktree"
worker_ensure_worktree "$worktree" "$main_branch" "$resuming"

# The prompt framing (fresh/resume/fallback) is built by the shared spine helper, so
# the claude and codex handlers stay byte-identical on the completion contract, the
# worktree note, and injection hygiene. External text (the job body) is data. The
# mode is chosen honestly: a requeue whose sidecar session did NOT survive to this
# host (no sidecar, or claimed elsewhere) recreated a fresh worktree and lost its
# in-progress state, so it gets the `fallback` framing rather than the plain `fresh`
# one that would hide the requeue (issue #62 follow-up: cross-host requeue loses
# both transcript and worktree; do not imply otherwise).
if $resuming; then
  log "resuming codex session $resume_sid for requeued job '$base' in worktree $worktree"
  prompt="$(worker_job_prompt "$base" "$jobfile" "$worktree" "$main_branch" resume)"
elif [ "$(reap_count "$jobfile")" -gt 0 ]; then
  log "requeued job '$base' has no local codex sidecar on $GARDEN; prior session and worktree were lost — starting fresh with lost-state framing"
  prompt="$(worker_job_prompt "$base" "$jobfile" "$worktree" "$main_branch" fallback)"
else
  prompt="$(worker_job_prompt "$base" "$jobfile" "$worktree" "$main_branch" fresh)"
fi

# --- model + thoughtfulness selection ----------------------------------------
#
# Mirrors the claude handler's two-step resolution, but on THIS kind's provider tier
# map (common.sh resolve_model_tier "$provider" / role_default_model "$KIND"):
#   1. An explicit `model:` header requests a specific model (a short tier — openai:
#      terra/luna/frontier/mini; local has no short tier now, a concrete served tag
#      passes through iff the routing table classifies it as local).
#   2. Absent that, the job's `role:` selects a per-role default (designer/builder
#      or a classified mechanical role), else this kind's fleet default from the
#      journal-backed routing table
#      (model_routing_default: openai → gpt-5.6-terra; local → qwen3.6).
# Thoughtfulness resolves from an optional `effort:` header, else the role default
# (high for designer/builder, medium otherwise), then is normalized DOWN to the
# model's nearest supported level and passed as -c model_reasoning_effort=.
#
# The tier map and role defaults are provider/kind scoped; the fleet default is DATA
# read from the model-routing table (common.sh model_routing_default), so a local box
# swapping its served model (e.g. gpt-oss → qwen) is a journal edit, not a code edit.
# Fail-safe: an unresolvable table falls back to a sane built-in per provider.
fleet_default_model="$(model_routing_default "$provider" 2>/dev/null)"
if [ -z "$fleet_default_model" ]; then
  case "$provider" in
    local) fleet_default_model="qwen3.6" ;;
    fireworks) fleet_default_model="" ;; # explicit model only
    *)     fleet_default_model="gpt-5.6-terra" ;;
  esac
fi
requested_tier="$(job_tier "$jobfile" 2>/dev/null || true)"
requested_role="$(plan_role "$jobfile")"
requested_effort="$(plan_field "$jobfile" effort)"
if job_provider_is_constrained "$jobfile"; then
  constrained_provider="$(job_provider_constraint "$jobfile" 2>/dev/null || true)"
  [ "$constrained_provider" = "$provider" ] \
    || die "job '$base' is constrained to an unavailable or foreign provider"
fi

model=""
if [ -n "$requested_tier" ]; then
  model="$(tier_model_for_provider "$requested_tier" "$provider")"
  if [ -n "$model" ]; then
    log "job '$base' resolved tier '$requested_tier' -> codex -m $model"
  else
    die "job '$base' tier '$requested_tier' is unavailable to $provider"
  fi
fi
if [ -z "$model" ] && [ -n "$requested_role" ]; then
  model="$(role_default_model "$KIND" "$requested_role")"
  [ -n "$model" ] && log "job '$base' role '$requested_role' -> default codex model $model"
fi
[ -n "$model" ] || model="$fleet_default_model"
[ -n "$model" ] || die "no model resolved for $KIND job '$base'"
# The namespace is garden-only routing metadata.  The provider receives the exact
# wire identifier after `fireworks/`, which can be a Serverless, Fast-router, or
# dedicated deployment id without a code/catalog release.
if [ "$provider" = fireworks ]; then
  [[ "$model" == fireworks/* ]] && [ -n "${model#fireworks/}" ] || die "invalid Fireworks model selector for tier '$requested_tier'"
  model="${model#fireworks/}"
fi

# Publish the resolved model so the fleet's gh wrapper can stamp it into the
# GitHub-comment provenance footer (scripts/jobs/comment-provenance.sh); the agent
# and every gh call it makes inherit this environment.
export GARDEN_JOB_MODEL="$model"
export GARDEN_JOB_ROLE="$requested_role"
# Publish the job base too (see gardener-claude.sh): per-job helpers key their
# isolated state by THIS job's unique base, never one shared path.
export GARDEN_JOB_BASE="$base"

# --- reachability + model-presence preflight ----------------------------------
#
# A backend outage or an unpulled local model must read as a HOST defect, not a job
# defect. Resolve the model first so LOCAL preflight can reject an empty Ollama store
# before Codex spends its reconnect attempts on deterministic 404s. A hermit is
# pinned local, so its endpoint liveness check self-heals; an unpulled model remains
# an actionable operator fix.
codex_provider_preflight "$provider" "$KIND" "$base" "$state_ns" 1 "$model" || exit 1

# codex_effort_for_model <model> <level> — normalize a unified-axis thoughtfulness
# level DOWN to the model's nearest supported codex reasoning-effort (catalog §2):
# terra supports low·medium·high·xhigh·max·ultra; luna low·…·max; gpt-5.5 and
# gpt-5.4-mini low·…·xhigh. An unknown/blank level resolves to medium (codex's own
# per-model default). The normalized level is what actually runs, and is what a
# future reputation event (§2.3/§4.2) keys the arm on — apples-to-apples.
effort_level="${requested_effort:-$(role_default_effort "$KIND" "$requested_role")}"
effort="$(codex_effort_for_model "$model" "$effort_level")"
[ "$effort" != "$effort_level" ] \
  && log "job '$base' effort '$effort_level' normalized to '$effort' for $model (model's nearest supported level)"

# --- run codex ----------------------------------------------------------------
#
# `codex exec` is the headless mode (no approval prompts by construction).
# --dangerously-bypass-approvals-and-sandbox is the posture parity of the claude
# handler's --dangerously-skip-permissions: the fleet's container IS the sandbox, and
# codex's own sandbox would otherwise deny the git push / gh / network a job needs.
# --skip-git-repo-check lets codex run with cwd inside the per-job worktree without
# re-asserting repo shape. --output-last-message captures the final agent message as
# the report (the analogue of `claude -p`'s stdout). The --json event stream goes to
# a capture temp for the session-id parse below (and, once §2.3 lands, the usage
# adapter). The job runs with cwd = $worktree so relative paths land in its worktree;
# $report is absolute so --output-last-message is unaffected by the cd.
json_capture="$(mktemp "${TMPDIR:-/tmp}/garden-codex-json-$base.XXXXXX")"
: > "$report"
codex_args=(
  --dangerously-bypass-approvals-and-sandbox
  --skip-git-repo-check
  -m "$model"
  -c "model_reasoning_effort=$effort"
  --output-last-message "$report"
  --json
)

# LOCAL provider (hermit): point codex at the on-box Ollama /v1 endpoint instead of
# paid OpenAI. The provider block is supplied INLINE via `-c` dotted overrides rather
# than depending on a ~/.codex/config.toml file, so it is durable across a garden
# reset / fresh checkout with NO seeded config (the bind-mounted home carries no
# config, and a reset would lose one). env_key names a var codex reads for the (
# ignored-by-Ollama) API key; export a non-empty placeholder so codex does not refuse
# for a missing key. codex additionally offers a native `--oss` shortcut for a local
# Ollama at its default port; the explicit provider block is used here so a non-default
# GARDEN_LOCAL_OLLAMA_URL (another port/box) is honored.
# LIVE-CLI PROVENANCE / TODO (extends the file-header caveat to the local path): the
# `-c model_provider=…` inline-provider surface and the /v1 endpoint contract are
# transcribed from context/operations/local-inference-amd.md §4 and are UNVERIFIED
# against an installed codex on a GPU host — codex was not on PATH in the build
# worktree. Re-verify the exact `-c` key names and string-quoting on the live CLI
# before the first real hermit job (guide §6 flags the end-to-end GPU run as the one
# check confirmable only on a real rebuild).
if [ "$provider" = local ] || [ "$provider" = fireworks ]; then
  codex_provider_extra_args "$provider"
  codex_args+=("${CODEX_PROVIDER_EXTRA_ARGS[@]}")
  if [ "$provider" = local ]; then
    log "job '$base' running on LOCAL provider ($model via $GARDEN_LOCAL_OLLAMA_URL)"
  else
    log "job '$base' running on Fireworks provider (explicit model selected; endpoint configured)"
  fi
fi

set +e
if $resuming && [ -n "$resume_sid" ]; then
  ( cd "$worktree" && env -u GARDEN_USAGE_FILE -u GARDEN_ENGAGEMENT_USAGE codex exec resume "$resume_sid" "${codex_args[@]}" "$prompt" ) > "$json_capture" 2>&1
  rc=$?
  # A resume that fails on an unusable session (pruned/expired) falls back to a fresh
  # session over the preserved worktree — the uncommitted work carries the state.
  if [ "$rc" -ne 0 ]; then
    log "codex resume of session $resume_sid failed (rc=$rc) for '$base'; retrying as a FRESH session over the preserved worktree"
    ( cd "$worktree" && env -u GARDEN_USAGE_FILE -u GARDEN_ENGAGEMENT_USAGE codex exec "${codex_args[@]}" "$prompt" ) > "$json_capture" 2>&1
    rc=$?
  fi
else
  attempt=1
  while :; do
    ( cd "$worktree" && env -u GARDEN_USAGE_FILE -u GARDEN_ENGAGEMENT_USAGE codex exec "${codex_args[@]}" "$prompt" ) > "$json_capture" 2>&1
    rc=$?
    [ "$provider" = fireworks ] && [ "$rc" -ne 0 ] && fireworks_retryable_failure "$json_capture" \
      && [ "$attempt" -lt "$GARDEN_FIREWORKS_RETRY_ATTEMPTS" ] || break
    delay=$(( GARDEN_FIREWORKS_RETRY_DELAY * (2 ** (attempt - 1)) ))
    log "Fireworks transient capacity/availability failure for '$base'; retrying attempt $((attempt + 1))/$GARDEN_FIREWORKS_RETRY_ATTEMPTS after ${delay}s"
    sleep "$delay"; attempt=$((attempt + 1))
  done
fi
set -e

# Persist codex's session id (parsed from the --json stream's initial events) to the
# per-base sidecar so a requeue can resume. Tolerant parse: match the first session/
# thread id field the event stream carries. Best-effort — an unparsable id just means
# the next attempt starts fresh (safe). VERIFY the exact field name on the live CLI.
sid="$(grep -oE '"(session_id|thread_id|conversation_id|id)"[[:space:]]*:[[:space:]]*"[A-Za-z0-9-]+"' "$json_capture" 2>/dev/null \
        | head -1 | grep -oE '"[A-Za-z0-9-]+"$' | tr -d '"' || true)"
if [ -n "$sid" ]; then
  mkdir -p "$(dirname "$session_sidecar")" 2>/dev/null || true
  printf '%s\n' "$sid" > "$session_sidecar" 2>/dev/null || true
fi
# Codex's JSON stream carries its terminal `token_count` event.  It presently
# exposes token classes but no provider-computed dollars, so this is a real token
# measurement and deliberately remains unpriced for reputation.  Do not guess a
# rate card here: a measured row must never masquerade as an invoice.
if command -v jq >/dev/null 2>&1 && [ -n "${GARDEN_USAGE_FILE:-}" ]; then
  codex_usage="$(jq -sce '
    [ . | select(.payload.type? == "token_count") | .payload.info.last_token_usage ] | last // empty
    | {source:"result", model:$model,
       input_tokens: ((.input_tokens // 0) - (.cached_input_tokens // 0) | if . < 0 then 0 else . end),
       output_tokens:(.output_tokens // 0), cache_read_tokens:(.cached_input_tokens // 0)}' \
      --arg model "$model" "$json_capture" 2>/dev/null || true)"
  [ -n "$codex_usage" ] && printf '%s\n' "$codex_usage" > "$GARDEN_USAGE_FILE" 2>/dev/null || true
fi
# The --json capture also carries any codex diagnostics; fold its tail onto the
# report's stderr channel (the spine captures the handler's stdout+stderr for
# failure hashing) so a codex failure is not silent. Keep it off the report body,
# which must stay the clean agent message for tada.
if [ "$rc" -ne 0 ]; then
  if [ "$provider" = fireworks ]; then
    # Fireworks errors may echo request metadata.  Preserve only a safe class.
    if fireworks_retryable_failure "$json_capture"; then
      printf 'Fireworks request ended after retryable capacity/availability failures; retained state for resume.\n' >&2
    else
      printf 'Fireworks request failed (non-retryable provider/configuration class); retained state for resume.\n' >&2
    fi
  else
    tail -n 40 "$json_capture" >&2 2>/dev/null || true
  fi
fi

# --- deterministic completion signal -----------------------------------------
#
# Same contract as the claude handler (common.sh § job completion signal): write the
# sentinel ONLY when codex exited 0 AND the report's final line is
# GARDEN_COMPLETION_MARKER. A codex that exited 0 without finishing leaves the marker
# absent, so no sentinel is written and the spine requeues the job. Strip the marker
# before it lands in the human-facing tada report.
if [ "$rc" -eq 0 ] && [ -n "${GARDEN_COMPLETION_SENTINEL:-}" ] && report_has_completion_marker "$report"; then
  strip_completion_marker "$report"
  : > "$GARDEN_COMPLETION_SENTINEL"
fi

# Teardown on genuine COMPLETION only — keyed on the same signal the spine gates on.
# A clean-but-unfinished exit-0 (no marker) will be REQUEUED, so its worktree and
# session sidecar must survive for the resumed run. A truly dead job's worktree is
# reclaimed by the reaper's scratch janitor after GARDEN_SCRATCH_GC_AGE hours.
if [ -n "${GARDEN_COMPLETION_SENTINEL:-}" ] && [ -e "$GARDEN_COMPLETION_SENTINEL" ]; then
  scratch_cleanup "$worktree"
  rm -f "$session_sidecar" 2>/dev/null || true   # a re-posted base must start fresh
fi
rm -f "$json_capture" 2>/dev/null || true
exit "$rc"
