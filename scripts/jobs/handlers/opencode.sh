#!/bin/bash
# opencode.sh - provider-parameterized OpenCode worker handler (Anthropic probe).

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"
# shellcheck source=worker-common.sh
source "$HERE/worker-common.sh"

base="${1:?base}"; jobfile="${2:?jobfile}"; report="${3:?report-out}"
KIND="${GARDEN_WORKER_KIND:-opencode-anthropic}"
provider="$(worker_kind_field "$KIND" provider 2>/dev/null || true)"
state_ns="$(worker_kind_field "$KIND" state_ns 2>/dev/null || true)"
if [ "$KIND" != opencode-anthropic ] || [ "$provider" != anthropic ] || [ -z "$state_ns" ]; then
  die "OpenCode handler invoked for invalid worker kind '$KIND'"
fi

cli="$(agent_bin opencode)" \
  || die_environmental "cannot run '$base': the opencode CLI is absent"
[ -n "${ANTHROPIC_API_KEY:-}" ] \
  || die_environmental "cannot run '$base': ANTHROPIC_API_KEY is absent"

# This paid probe lane is explicit-model-only, matching claim-job.sh. Resolve the
# garden Anthropic alias/id, then add OpenCode's provider namespace only at the CLI.
pin="$(plan_field "$jobfile" model)"
[[ "$pin" == opencode-anthropic/* ]] \
  || die "opencode-anthropic requires an opencode-anthropic/<model> pin"
model="$(resolve_model_tier anthropic "${pin#opencode-anthropic/}")"
[ -n "$model" ] || die "opencode-anthropic cannot resolve model pin '$pin'"
if job_provider_is_constrained "$jobfile"; then
  [ "$(job_provider_constraint "$jobfile" 2>/dev/null || true)" = anthropic ] \
    || die "job '$base' is constrained to a foreign provider"
fi
GARDEN_JOB_ROLE="$(plan_role "$jobfile")"
export GARDEN_JOB_MODEL="$model" GARDEN_JOB_BASE="$base" GARDEN_JOB_ROLE

main_branch="${GARDEN_MAIN_BRANCH:-main2}"
worktree="$(worker_worktree_path "$base")"
session_sidecar="$GARDEN_STATE/$state_ns/sessions/$base"
private_root="$GARDEN_STATE/$state_ns/opencode/$base"
data_home="$private_root/data"
config_home="$private_root/config"
cache_home="$private_root/cache"
resume_sid=""
resuming=false
if [ -s "$session_sidecar" ] && [ -d "$worktree" ] && [ -d "$data_home" ]; then
  resume_sid="$(tr -dc 'A-Za-z0-9_-' < "$session_sidecar" | head -c 200 || true)"
  [ -n "$resume_sid" ] && resuming=true
fi

kill_stale_worktree_handlers "$worktree"
worker_ensure_worktree "$worktree" "$main_branch" "$resuming"
umask 077
mkdir -p "$data_home" "$config_home" "$cache_home"
chmod 700 "$private_root" "$data_home" "$config_home" "$cache_home" 2>/dev/null || true

if $resuming; then
  log "resuming OpenCode session $resume_sid for requeued job '$base'"
  prompt="$(worker_job_prompt "$base" "$jobfile" "$worktree" "$main_branch" resume)"
elif [ "$(reap_count "$jobfile")" -gt 0 ]; then
  prompt="$(worker_job_prompt "$base" "$jobfile" "$worktree" "$main_branch" fallback)"
else
  prompt="$(worker_job_prompt "$base" "$jobfile" "$worktree" "$main_branch" fresh)"
fi

events="$(mktemp "${TMPDIR:-/tmp}/garden-opencode-events-$base.XXXXXX")"
: > "$report"
args=(run --pure --auto --format json -m "anthropic/$model")
$resuming && args+=(--session "$resume_sid")

# Keep OpenCode's SQLite session store, logs, cache, and config private per job.
# Current OpenCode follows XDG_*; OPENCODE_DATA_DIR from the original design is no
# longer a supported CLI variable. external_directory=deny bounds tool access to
# the per-job cwd while --auto permits the ordinary in-worktree tool loop.
config='{"permission":{"external_directory":"deny"},"share":"disabled","autoupdate":false}'
set +e
( cd "$worktree" && \
  XDG_DATA_HOME="$data_home" XDG_CONFIG_HOME="$config_home" XDG_CACHE_HOME="$cache_home" \
  OPENCODE_CONFIG_CONTENT="$config" OPENCODE_DISABLE_AUTOUPDATE=true \
  "$cli" "${args[@]}" "$prompt" ) > "$events" 2>&1
rc=$?
set -e

# sessionID is present even on an early provider error. Persist it before any
# classification so an externally killed/requeued attempt can continue with -s.
sid="$(jq -r 'select((.sessionID? | type)=="string") | .sessionID' "$events" 2>/dev/null | head -1 || true)"
if [[ "$sid" =~ ^[A-Za-z0-9_-]+$ ]]; then
  mkdir -p "$(dirname "$session_sidecar")"
  printf '%s\n' "$sid" > "$session_sidecar"
fi

# Raw JSON text parts are the agent's stdout-equivalent completion report.
jq -r 'select(.type=="text") | (.part.text // .text // empty)' "$events" \
  > "$report" 2>/dev/null || true

# Sum every priced step_finish event. Never turn an absent price into a zero-dollar
# invoice: without at least one numeric cost, leave the usage handoff absent so the
# ledger records source:none/censored.
if [ -n "${GARDEN_USAGE_FILE:-}" ] && command -v jq >/dev/null 2>&1; then
  usage="$(jq -sce --arg model "$model" '
    [ .[] | select(.type=="step_finish")
        | (.part // .) | select((.cost? | type)=="number") ] as $s
    | if ($s|length)==0 then empty else
        {source:"result", model:$model,
         input_tokens:  ([$s[] | (.tokens.input // 0)] | add),
         output_tokens: ([$s[] | (.tokens.output // 0)] | add),
         cache_read_tokens:  ([$s[] | (.tokens.cache.read // 0)] | add),
         cache_creation_tokens: ([$s[] | (.tokens.cache.write // 0)] | add),
         total_cost_usd: ([$s[] | .cost] | add)} end' "$events" 2>/dev/null || true)"
  [ -n "$usage" ] && printf '%s\n' "$usage" > "$GARDEN_USAGE_FILE"
fi

# OpenCode 1.18.25 returns rc=1 for a refused API key. That is a host credential
# defect, not a job defect, so normalize authentication/quota/capacity responses to
# EX_TEMPFAIL. External SIGTERM/SIGKILL remains 143/137 and the spine already treats
# those codes as transient independently of captured output.
if [ "$rc" -ne 0 ] && jq -e '
    select(.type=="error")
    | ((.error.data.statusCode // 0) as $s
       | ($s==401 or $s==403 or $s==408 or $s==409 or $s==429 or $s>=500))
  ' "$events" >/dev/null 2>&1; then
  printf 'OpenCode provider/authentication environment refused %q; retained session %s for resume.\n' \
    "$base" "${sid:-unknown}" >&2
  rc="${GARDEN_ENV_RC:-75}"
elif [ "$rc" -ne 0 ]; then
  # The raw stream can contain provider response bodies. Emit a secret-safe class.
  printf 'OpenCode CLI failed for %q (rc=%s); retained private state for resume.\n' "$base" "$rc" >&2
fi

if [ "$rc" -eq 0 ] && [ -n "${GARDEN_COMPLETION_SENTINEL:-}" ] \
   && report_has_completion_marker "$report"; then
  strip_completion_marker "$report"
  : > "$GARDEN_COMPLETION_SENTINEL"
fi

if [ -n "${GARDEN_COMPLETION_SENTINEL:-}" ] && [ -e "$GARDEN_COMPLETION_SENTINEL" ]; then
  # Export the database-backed session to the established JSONL spool interface
  # before retiring private state. The export is JSON but line-safe and redacted by
  # transcript-capture.sh on drain exactly like native harness transcripts.
  if [ -n "${sid:-}" ]; then
    export_dir="$private_root/export/gardener-wt-$base"
    mkdir -p "$export_dir"
    XDG_DATA_HOME="$data_home" XDG_CONFIG_HOME="$config_home" XDG_CACHE_HOME="$cache_home" \
      "$cli" export "$sid" > "$export_dir/$sid.jsonl" 2>/dev/null || true
    transcript_spool "$export_dir/$sid.jsonl" "$base"
  fi
  scratch_cleanup "$worktree"
  rm -rf "$private_root"
  rm -f "$session_sidecar" 2>/dev/null || true
fi
rm -f "$events" 2>/dev/null || true
exit "$rc"
