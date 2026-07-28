#!/bin/bash
# mystic-kimi.sh: official Kimi Code CLI handler for explicit Moonshot K3 jobs.
#
# This handler intentionally does not share the Codex harness. Kimi Code's supported
# CI path is `kimi --prompt` and its supported resume path is `kimi --continue`.
# Every job receives a private KIMI_CODE_HOME below its Mystic state namespace, so
# config, logs, and session data cannot bleed across jobs and survive a requeue.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"
# shellcheck source=worker-common.sh
source "$HERE/worker-common.sh"
# shellcheck source=kimi-provider-common.sh
source "$HERE/kimi-provider-common.sh"

base="${1:?base}"; jobfile="${2:?jobfile}"; report="${3:?report-out}"
KIND="${GARDEN_WORKER_KIND:-mystic}"
provider="$(worker_kind_field "$KIND" provider 2>/dev/null || true)"
state_ns="$(worker_kind_field "$KIND" state_ns 2>/dev/null || true)"
[ "$KIND" = mystic ] && [ "$provider" = moonshot ] && [ -n "$state_ns" ] \
  || die "mystic Kimi handler invoked for invalid worker kind '$KIND'"

# Mystic never supplies a fallback model. Keep the handler's direct invocation as
# strict as claim-job.sh so an accidental manual invocation cannot bypass the
# explicit-model-only routing policy.
[ "$(plan_field "$jobfile" model)" = kimi-k3 ] \
  || die "mystic only runs explicit model: kimi-k3 jobs (refusing '$base')"
kimi_provider_preflight "$base" || exit 1

# Publish the resolved model so the fleet's gh wrapper can stamp it into the
# GitHub-comment provenance footer (scripts/jobs/comment-provenance.sh).
export GARDEN_JOB_MODEL="kimi-k3"

main_branch="${GARDEN_MAIN_BRANCH:-main2}"
worktree="$(worker_worktree_path "$base")"
kimi_home="$GARDEN_STATE/$state_ns/kimi/$base"
resuming=false
if [ -d "$kimi_home" ] && [ -d "$worktree" ]; then resuming=true; fi

# Close the same two-writer window as the other handlers before touching a stable
# requeue worktree. Kimi's own child processes remain inside the gardener-spine
# process group and are also swept by its timeout/process cleanup.
kill_stale_worktree_handlers "$worktree"
worker_ensure_worktree "$worktree" "$main_branch" "$resuming"
umask 077
mkdir -p "$kimi_home"
chmod 700 "$kimi_home" 2>/dev/null || true

if $resuming; then
  log "resuming Kimi Code session for requeued job '$base' in $kimi_home"
  prompt="$(worker_job_prompt "$base" "$jobfile" "$worktree" "$main_branch" resume)"
else
  prompt="$(worker_job_prompt "$base" "$jobfile" "$worktree" "$main_branch" fresh)"
fi

: > "$report"
diagnostic="$(mktemp "${TMPDIR:-/tmp}/garden-kimi-diagnostic-$base.XXXXXX")"
# `kimi-k3` is both the garden's explicit routing/reputation id and Moonshot's
# documented wire model id. KIMI_MODEL_* synthesizes Kimi Code's temporary model
# in memory. Do not add --model: it overrides that temporary selection and makes
# Kimi Code look for a persisted config.toml alias instead.
kimi_args=(--prompt "$prompt" --output-format text)
$resuming && kimi_args=(--continue "${kimi_args[@]}")
set +e
( cd "$worktree" && kimi_model_environment "$kimi_home" kimi-k3 kimi "${kimi_args[@]}" ) > "$report" 2> "$diagnostic"
rc=$?
set -e

# Kimi Code 0.29.1 renders the first text line with a bullet, but indents
# continuation lines (including the completion marker) with two spaces.
# Normalize only the last non-blank line and accept only that decoration: leading
# horizontal whitespace, or one bullet followed by horizontal whitespace.
if [ "$rc" -eq 0 ]; then
  awk -v m="$GARDEN_COMPLETION_MARKER" -v b="$(printf '\342\200\242')" '
    { line[NR]=$0 }
    END {
      n=NR
      while (n>0 && line[n] ~ /^[ \t]*$/) n--
      if (n>0 && (line[n] ~ "^[ \\t]*" m "$" || line[n] ~ "^" b "[ \\t]+" m "$")) line[n]=m
      for (i=1; i<=NR; i++) print line[i]
    }
  ' "$report" > "$report.normalized" && mv "$report.normalized" "$report"
fi

# Do not replay CLI diagnostics: an upstream CLI might include its resolved
# configuration in an error. The persisted per-job KIMI_CODE_HOME retains its own
# private diagnostic state for a resumed attempt, while the worker gets a safe,
# actionable failure line without exposing MOONSHOT_API_KEY.
if [ "$rc" -ne 0 ]; then
  printf 'Kimi Code CLI failed for %q (rc=%s); its per-job state is retained for resume.\n' "$base" "$rc" >&2
fi

if [ "$rc" -eq 0 ] && [ -n "${GARDEN_COMPLETION_SENTINEL:-}" ] && report_has_completion_marker "$report"; then
  strip_completion_marker "$report"
  : > "$GARDEN_COMPLETION_SENTINEL"
fi

# Preserve state and worktree on every unfinished outcome. A genuine completion is
# the only point at which the per-base session state is retired.
if [ -n "${GARDEN_COMPLETION_SENTINEL:-}" ] && [ -e "$GARDEN_COMPLETION_SENTINEL" ]; then
  scratch_cleanup "$worktree"
  rm -rf "$kimi_home"
fi
rm -f "$diagnostic"
exit "$rc"
