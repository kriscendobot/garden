#!/bin/bash
# mystic-kimi-code.sh — Moonshot Kimi K3 worker handler via official Kimi Code.
#
# Contract: invoked by the shared gardener spine as
#   mystic-kimi-code.sh <base> <job-file> <report-out>
# It retains the shared worktree/prompt/completion contract and gives every job an
# isolated, persistent KIMI_CODE_HOME. Kimi Code's KIMI_MODEL_* channel supplies
# the Open Platform model and credential only for this invocation, so neither a
# config.toml nor a credential is written into the worktree or a shared user home.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"
# shellcheck source=worker-common.sh
source "$HERE/worker-common.sh"

base="${1:?base}"; jobfile="${2:?jobfile}"; report="${3:?report-out}"
KIND="${GARDEN_WORKER_KIND:-mystic}"
provider="$(worker_kind_field "$KIND" provider 2>/dev/null || true)"
state_ns="$(worker_kind_field "$KIND" state_ns 2>/dev/null || true)"
[ "$provider" = moonshot ] && [ -n "$state_ns" ] \
  || die "mystic Kimi Code handler requires worker kind mystic (got '$KIND')"

command -v kimi >/dev/null 2>&1 \
  || die "kimi not on PATH; install the official Kimi Code CLI before running mystic worker '$base'"
[ -n "${MOONSHOT_API_KEY:-}" ] \
  || die "MOONSHOT_API_KEY is not set; export it before recreating the garden container so systemd inherits it"

main_branch="${GARDEN_MAIN_BRANCH:-main2}"
worktree="$(worker_worktree_path "$base")"
# Kimi Code keeps config, sessions, logs, and credentials below KIMI_CODE_HOME.
# A per-base state directory gives resume its same-worktree history without sharing
# mutable sessions across workers or writing credentials to ~/.kimi-code.
kimi_home="$GARDEN_STATE/$state_ns/kimi-code/$base"
mkdir -p -m 700 "$kimi_home"
chmod 700 "$kimi_home" 2>/dev/null || true

# `--continue` is valid only after Kimi persisted a session for this exact
# worktree. The state is retained whenever completion was not signaled, so a
# requeue resumes rather than starts a concurrent/new conversation.
resuming=false
if [ -s "$kimi_home/session_index.jsonl" ] && [ -d "$worktree" ]; then
  resuming=true
fi

kill_stale_worktree_handlers "$worktree"
worker_ensure_worktree "$worktree" "$main_branch" "$resuming"
if $resuming; then
  log "resuming Kimi Code session for requeued job '$base' in worktree $worktree"
  prompt="$(worker_job_prompt "$base" "$jobfile" "$worktree" "$main_branch" resume)"
else
  prompt="$(worker_job_prompt "$base" "$jobfile" "$worktree" "$main_branch" fresh)"
fi

# K3 accepts low, high, and max. Garden's common effort scale has medium, so map
# it to high rather than silently asking Kimi for an unsupported value.
requested_effort="$(plan_field "$jobfile" effort)"
requested_role="$(plan_role "$jobfile")"
case "${requested_effort:-$(role_default_effort "$KIND" "$requested_role")}" in
  low|high|max) effort="${requested_effort:-$(role_default_effort "$KIND" "$requested_role")}" ;;
  *) effort=high ;;
esac

: > "$report"
set +e
if $resuming; then
  ( cd "$worktree" && \
    KIMI_CODE_HOME="$kimi_home" KIMI_DISABLE_TELEMETRY=1 \
    KIMI_MODEL_NAME=kimi-k3 KIMI_MODEL_API_KEY="$MOONSHOT_API_KEY" \
    KIMI_MODEL_PROVIDER_TYPE=kimi KIMI_MODEL_BASE_URL=https://api.moonshot.ai/v1 \
    KIMI_MODEL_MAX_CONTEXT_SIZE=1048576 KIMI_MODEL_CAPABILITIES=tool_use,thinking \
    KIMI_MODEL_THINKING_EFFORT="$effort" \
    kimi --auto --continue -p "$prompt" --output-format text ) > "$report"
  rc=$?
else
  ( cd "$worktree" && \
    KIMI_CODE_HOME="$kimi_home" KIMI_DISABLE_TELEMETRY=1 \
    KIMI_MODEL_NAME=kimi-k3 KIMI_MODEL_API_KEY="$MOONSHOT_API_KEY" \
    KIMI_MODEL_PROVIDER_TYPE=kimi KIMI_MODEL_BASE_URL=https://api.moonshot.ai/v1 \
    KIMI_MODEL_MAX_CONTEXT_SIZE=1048576 KIMI_MODEL_CAPABILITIES=tool_use,thinking \
    KIMI_MODEL_THINKING_EFFORT="$effort" \
    kimi --auto -p "$prompt" --output-format text ) > "$report"
  rc=$?
fi
set -e

# The shared spine completes only after this exact marker-derived sentinel. A clean
# CLI exit without the marker preserves both the worktree and Kimi session for a
# requeue; it cannot accidentally become a tada report.
if [ "$rc" -eq 0 ] && [ -n "${GARDEN_COMPLETION_SENTINEL:-}" ] && report_has_completion_marker "$report"; then
  strip_completion_marker "$report"
  : > "$GARDEN_COMPLETION_SENTINEL"
fi

if [ -n "${GARDEN_COMPLETION_SENTINEL:-}" ] && [ -e "$GARDEN_COMPLETION_SENTINEL" ]; then
  scratch_cleanup "$worktree"
  rm -rf "$kimi_home" 2>/dev/null || true
fi
exit "$rc"
