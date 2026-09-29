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
# minion.town MCP attach (fail-open: a missing lib must never stop a job, so it
# degrades to "never attach").
# shellcheck source=../minion-mcp-lib.sh
if [ -f "$HERE/../minion-mcp-lib.sh" ]; then source "$HERE/../minion-mcp-lib.sh"; else minion_mcp_prepare() { return 1; }; fi
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
# mentor capability boundary.
[ "$(job_tier "$jobfile" 2>/dev/null || true)" = mentor ] \
  || die "mystic only runs tier: mentor jobs (refusing '$base')"
if job_provider_is_constrained "$jobfile"; then
  [ "$(job_provider_constraint "$jobfile" 2>/dev/null || true)" = moonshot ] \
    || die "job '$base' is constrained to an unavailable or foreign provider"
fi
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

# minion.town MCP (standing order; context/operations/minion-town-mcp.md). Kimi Code
# reads MCP servers only from $KIMI_CODE_HOME/mcp.json, so write (or remove) it in the
# job's private home on every launch; a resumed job re-evaluates the gate. Fail-open.
if minion_mcp_prepare "$base" "$jobfile"; then
  minion_mcp_kimi_write "$kimi_home" on
  log "job '$base' attaching minion.town MCP (stdio bridge)"
else
  minion_mcp_kimi_write "$kimi_home" off
fi

# A resumed attempt whose predecessor STOPPED cleanly without completing (the
# shared unfinished-end-turn marker, worker-common.sh § completion-nudge policy)
# gets the honest `continue` framing — it was not interrupted, so the plain resume
# framing would be false.
unfinished_marker="$(worker_unfinished_marker "$worktree")"
if $resuming && [ -n "$unfinished_marker" ] && [ -e "$unfinished_marker" ]; then
  log "resuming Kimi Code session for job '$base' that STOPPED without completing; continue framing"
  prompt="$(worker_job_prompt "$base" "$jobfile" "$worktree" "$main_branch" continue)"
elif $resuming; then
  log "resuming Kimi Code session for requeued job '$base' in $kimi_home"
  prompt="$(worker_job_prompt "$base" "$jobfile" "$worktree" "$main_branch" resume)"
else
  prompt="$(worker_job_prompt "$base" "$jobfile" "$worktree" "$main_branch" fresh)"
fi

: > "$report"
diagnostic="$(mktemp "${TMPDIR:-/tmp}/garden-kimi-diagnostic-$base.XXXXXX")"
# kimi_call <continue true|false> <prompt> — run ONE headless Kimi Code invocation
# into $report and normalize its completion-marker decoration; sets $rc.
# `kimi-k3` is both the garden's explicit routing/reputation id and Moonshot's
# documented wire model id. KIMI_MODEL_* synthesizes Kimi Code's temporary model
# in memory. Do not add --model: it overrides that temporary selection and makes
# Kimi Code look for a persisted config.toml alias instead. `--continue` resumes
# the previous session for this working directory WITHIN the job's private
# KIMI_CODE_HOME, so it can only ever continue this job's own session.
kimi_call() {
  local cont="$1" call_prompt="$2" kimi_args
  kimi_args=(--prompt "$call_prompt" --output-format text)
  [ "$cont" = true ] && kimi_args=(--continue "${kimi_args[@]}")
  set +e
  ( cd "$worktree" && kimi_model_environment "$kimi_home" kimi-k3 kimi "${kimi_args[@]}" ) > "$report" 2> "$diagnostic"
  rc=$?
  set -e
  # Kimi Code 0.29.1 renders the first text line with a bullet, but indents
  # continuation lines (including the completion marker) with two spaces.
  # Normalize only the last non-blank line and accept only that decoration:
  # leading horizontal whitespace, or one bullet followed by horizontal whitespace.
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
}
# Cost-ledger capture (designs/token-cost-ledger.md): snapshot this lane's cumulative
# per-turn token usage from KIMI_CODE_HOME before the first invocation; the delta
# taken after the FINAL invocation below is exactly this handler run's turns
# (naturally including a completion nudge's) — correct even when a persisted
# --continue home already holds prior attempts' records. Best-effort; a failure to
# snapshot never perturbs the run (the ledger just records source:none).
usage_pre="$(meter_kimi_home_usage "$kimi_home" 2>/dev/null || true)"
kimi_call "$resuming" "$prompt"

# --- in-process completion nudge (designs/non-claude-completion-nudge-parity.md) --
#
# A Kimi run that exited 0 WITHOUT the completion marker stopped rather than
# finished. Resume the SAME session once in THIS process (`--continue` against the
# same private home and worktree) with the honest `continue` framing, bounded by
# the shared policy (worker-common.sh § completion-nudge policy). A failed nudge
# restores the first report and the clean-markerless outcome (rc=0) so the spine
# takes the ordinary requeue; the unfinished marker below gives the next same-host
# claim the `continue` framing.
kimi_unfinished_end_turn() {
  [ "$rc" -eq 0 ] && ! report_has_completion_marker "$report"
}
nudges=0
while [ "$nudges" -lt "$GARDEN_COMPLETION_NUDGES" ] && kimi_unfinished_end_turn; do
  if ! worker_nudge_time_ok; then
    log "job '$base' ended its turn without the completion signal; no completion nudge (remaining handler wall time under ${GARDEN_COMPLETION_NUDGE_MIN_SECONDS}s floor)"
    break
  fi
  nudges=$((nudges + 1))
  log "job '$base' ended its turn without the completion signal; nudging the same Kimi session to verify and complete (nudge $nudges/$GARDEN_COMPLETION_NUDGES)"
  cp "$report" "$report.pre-nudge" 2>/dev/null || true
  nudge_prompt="$(worker_job_prompt "$base" "$jobfile" "$worktree" "$main_branch" continue)"
  kimi_call true "$nudge_prompt"
  if [ "$rc" -ne 0 ] || [ ! -s "$report" ]; then
    log "Kimi completion nudge for '$base' failed (rc=$rc); restoring first report and taking the ordinary requeue"
    printf 'Kimi Code completion nudge failed (rc=%s); first report restored, per-job state retained for resume.\n' "$rc" >&2
    { cat "$report.pre-nudge" 2>/dev/null; printf '\n[completion nudge failed: rc=%s]\n' "$rc"; } > "$report.merged" \
      && mv "$report.merged" "$report"
    rc=0
    rm -f "$report.pre-nudge"
    break
  fi
  rm -f "$report.pre-nudge"
done

# Fold this handler run's kimi token delta into the engagement usage handoff the
# gardener spine reads ($GARDEN_USAGE_FILE). Kimi reports no provider dollars, so the
# row is measured-but-unpriced tokens (source:result), never a guessed rate — the
# openai/codex lane records the same way. Written AFTER the run and OUTSIDE the
# credential-stripped kimi environment, in plain code: the agent can neither author
# nor destroy it. Entirely best-effort and fail-open: any gap leaves the spine to
# record source:none, and it can never change the handler's exit code or report.
usage_post="$(meter_kimi_home_usage "$kimi_home" 2>/dev/null || true)"
if [ -n "${GARDEN_USAGE_FILE:-}" ] && command -v jq >/dev/null 2>&1 \
   && [[ "$usage_pre" =~ ^[0-9]+$'\t'[0-9]+$'\t'[0-9]+$'\t'[0-9]+$ ]] \
   && [[ "$usage_post" =~ ^[0-9]+$'\t'[0-9]+$'\t'[0-9]+$'\t'[0-9]+$ ]]; then
  awk -F'\t' 'NR==1{for(i=1;i<=4;i++)a[i]=$i} NR==2{
      i=$1-a[1]; o=$2-a[2]; c=$3-a[3]; r=$4-a[4];
      if(i<0)i=0; if(o<0)o=0; if(c<0)c=0; if(r<0)r=0;
      printf "{\"source\":\"result\",\"model\":\"kimi-k3\",\"input_tokens\":%d,\"output_tokens\":%d,\"cache_creation_tokens\":%d,\"cache_read_tokens\":%d}\n", i,o,c,r
    }' <(printf '%s\n' "$usage_pre") <(printf '%s\n' "$usage_post") > "$GARDEN_USAGE_FILE" 2>/dev/null || true
  if [ "$nudges" -gt 0 ] && [ -s "$GARDEN_USAGE_FILE" ]; then
    jq --argjson n "$nudges" '. + {completion_nudges:$n}' "$GARDEN_USAGE_FILE" \
      > "$GARDEN_USAGE_FILE.tmp" 2>/dev/null \
      && mv "$GARDEN_USAGE_FILE.tmp" "$GARDEN_USAGE_FILE" || rm -f "$GARDEN_USAGE_FILE.tmp"
  fi
fi

# Remember, in the worktree's private admin dir, that this attempt STOPPED without
# completing (as opposed to being interrupted), so the next same-host claim resumes
# with the honest `continue` framing rather than "you were interrupted".
if [ -n "$unfinished_marker" ]; then
  if kimi_unfinished_end_turn; then : > "$unfinished_marker" 2>/dev/null || true
  else rm -f "$unfinished_marker" 2>/dev/null || true; fi
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
