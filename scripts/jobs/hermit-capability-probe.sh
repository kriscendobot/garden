#!/bin/bash
# hermit-capability-probe.sh — after a local/ollama (hermit) worker DETERMINISTICALLY
# fails a job, measure whether a CAPABLE reference model (claude/codex) would have
# completed the same work, and if so record a DEMERIT against the local arm's
# reputation (design hermit-failure-capability-demerit.md; maintainer directive
# 2026-07-27).
#
# Invoked BEST-EFFORT and BOUNDED from gardener.sh's real-failure branch, only when
# KIND=hermit (provider: local). Everything here is fail-open: every guard that is not
# satisfied exits 0 WITHOUT probing, and no failure of the probe may ever strand or
# block the failed job (which the spine already left in doin for the reaper).
#
# What "measurement-only" means (the anti-double-run invariant): the probe re-attempts
# the SAME job's WORK on a capable model in an ISOLATED throwaway worktree keyed by a
# probe-specific base, under a prompt that FORBIDS every side effect — no push, no PR /
# issue / board mutation, no ferry, no messaging. It never touches the original job's
# board entry (that job is requeued by the reaper independently) and never pushes live
# project changes, so it cannot double-run live work. Its ONLY durable output is a
# per-base probe record and, on a capable success, a demerit reputation event — both
# ride one single-writer CAS push to the journal.
#
# Cost + loop guards: single bounded `claude -p` attempt per capable agent (timeout),
# once-per-base (a committed probe marker dedups across reaper requeues), and SKIPPED
# while the fleet brake is engaged (the budget freeze — the probe spends capable-model
# tokens, so a quota storm must not be fed by it).
#
# Usage: hermit-capability-probe.sh <base> <jobfile>
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
# shellcheck source=auction.sh
source "$HERE/auction.sh"     # reputation.sh helpers (rep_*) + JOBS_* (source-once guarded)
# shellcheck source=handlers/worker-common.sh
source "$HERE/handlers/worker-common.sh"   # worker_worktree_path / worker_ensure_worktree

GARDEN_TAG="hermit-probe"

base="${1:?usage: hermit-capability-probe.sh <base> <jobfile>}"
jobfile="${2:?missing jobfile}"
case "$base" in -*|*/*|.*|'') die "illegal basename: '$base'";; esac

# --- guards (each fail-safe: skip the probe, exit 0) -------------------------
[ "${GARDEN_HERMIT_PROBE:-1}" = 1 ] || { log "hermit capability probe disabled (GARDEN_HERMIT_PROBE=0); skipping '$base'"; exit 0; }

KIND="${GARDEN_WORKER_KIND:-}"
provider="$(worker_kind_field "$KIND" provider 2>/dev/null || echo "")"
if [ "$provider" != local ]; then
  log "worker '$KIND' is provider '$provider', not local; the probe measures the LOCAL arm only — skipping '$base'"
  exit 0
fi
[ -f "$jobfile" ] || { log "jobfile for '$base' is gone; nothing to probe"; exit 0; }

# Respect the budget freeze: the probe SPENDS capable-model tokens, so a fleet-wide
# quota storm (the same brake the gardener loop honors) must not be fed by it.
if fleet_brake_engaged; then
  log "fleet brake ENGAGED (budget freeze); skipping capability probe for '$base'"
  exit 0
fi

# --- journal clone for dedup + recording ------------------------------------
DIR="${GARDEN_HERMIT_PROBE_CLONE:-$GARDEN_STATE/hermit-probe/journal}"
if ! ensure_clone "$DIR"; then log "probe clone unavailable; skipping '$base'"; exit 0; fi
if ! sync_clone "$DIR"; then log "probe clone offline; skipping '$base'"; exit 0; fi

probe_marker="reputation/probes/$(rep_sanitize "$base").md"
demerit_rel="$(rep_demerit_event_relpath "$base")"
if [ -f "$DIR/$probe_marker" ] || [ -f "$DIR/$demerit_rel" ]; then
  clone_unlock "$DIR" 2>/dev/null || true
  log "'$base' already has a probe record; skipping (once-per-base dedup)"
  exit 0
fi
clone_unlock "$DIR" 2>/dev/null || true

# --- the LOCAL arm this failure demerits ------------------------------------
# Resolve the arm the hermit ACTUALLY ran, exactly as claim/complete resolve it.
{ read -r arm_provider; read -r arm_model; read -r arm_tht; } < <(rep_resolve_arm "$KIND" "$jobfile")
work_class="$(rep_work_class "$jobfile")"
target="$(rep_target "$jobfile")"

# The failed local attempt's own sunk agentic cost (censored -> the reducer would drop
# the event, so rep_record_demerit substitutes a positive nominal; we pass it through).
local_dollars="$(rep_agentic_dollars "$DIR" "$base" 2>/dev/null || echo censored)"

# --- the measurement-only prompt --------------------------------------------
# Embeds the ORIGINAL job spec verbatim (as DATA), then hard-forbids every side effect.
probe_prompt() {
  local worktree="$1" main_branch="$2"
  cat <<EOF
You are a CAPABILITY PROBE, not a working gardener. A local/ollama (hermit) worker
just FAILED garden job '$base'. Your ONE task is to determine whether YOU — a capable
reference model — can genuinely complete the WORK this job asks for. This is a
throwaway MEASUREMENT; your result is used only to score whether local inference was
fit for this job class, and your worktree is discarded afterward.

MEASUREMENT-ONLY CONSTRAINTS (hard — violating any of these corrupts the measurement
and is forbidden):
- Do ALL work in your isolated worktree at $worktree (checked out off
  origin/$main_branch), or, for a PROJECT-repo job, in an isolated project checkout
  keyed to the base 'hermit-probe-$base'. NEVER touch the failed job's own worktree,
  checkout, or board entry.
- Do NOT push to ANY remote. Do NOT open, edit, close, comment on, or review ANY pull
  request or issue. Do NOT modify the job board (no post-job / claim / complete / plan
  edits). Do NOT ferry anything upstream. Do NOT send any message on the bus or to the
  maintainer. Do NOT enable/modify any systemd unit or schedule.
- Work entirely locally and leave no external trace. Committing to your OWN throwaway
  worktree is fine (it is discarded); pushing anywhere is not.

Do the substance of the work locally to the point where you are confident it is
genuinely COMPLETE and correct (e.g. the code change is written and its tests pass in
your worktree). Then emit the completion signal.

COMPLETION SIGNAL (required): emit the exact line
    $GARDEN_COMPLETION_MARKER
as the very LAST line of your output, on its own line, ONLY if you GENUINELY completed
the substance of the work locally. If you could NOT complete it — you got stuck, the
task is underspecified, or you are unsure — do NOT emit that line. The absence of the
line is recorded as "a capable model also could not do it," which is the honest and
useful outcome; never emit it just to finish.

----- JOB $base -----
$(cat "$jobfile")
----- END JOB -----
EOF
}

# --- run the capable reference agent(s) -------------------------------------
# Iterate a configured agent list; the FIRST capable success records the demerit and
# stops (one demerit per base is the signal; more probing is wasted spend). Default is
# claude alone — the canonical capable reference; codex may be added via env once its
# probe harness is wired (a documented follow-up).
agents="${GARDEN_HERMIT_PROBE_AGENTS:-claude}"
main_branch="${GARDEN_MAIN_BRANCH:-main2}"
probe_timeout="${GARDEN_HERMIT_PROBE_TIMEOUT:-1200}"
case "$probe_timeout" in ''|*[!0-9]*) probe_timeout=1200 ;; esac

probe_worktree="$(worker_worktree_path "hermit-probe-$base")"
capable_succeeded=0
probe_agent=""
probe_model=""
outcomes=""

for agent in $agents; do
  case "$agent" in
    claude)
      cli="$(claude_bin 2>/dev/null)" || { log "claude CLI unavailable; cannot probe '$base' with claude"; outcomes="${outcomes}claude=unavailable;"; continue; }
      ;;
    *)
      # Only claude is wired as a probe harness today; any other configured agent is
      # skipped rather than mis-run. Adding codex is a clean follow-up.
      log "probe agent '$agent' has no wired harness; skipping it for '$base'"
      outcomes="${outcomes}${agent}=nowired;"
      continue
      ;;
  esac

  # Fresh isolated worktree per attempt (measurement is stateless; never resume).
  worker_ensure_worktree "$probe_worktree" "$main_branch" false || { log "could not create probe worktree for '$base'; skipping"; outcomes="${outcomes}${agent}=noworktree;"; continue; }
  prompt="$(probe_prompt "$probe_worktree" "$main_branch")"
  report="$(mktemp "${TMPDIR:-/tmp}/garden-probe-report-$base.XXXXXX")"
  envelope="$(mktemp "${TMPDIR:-/tmp}/garden-probe-envelope-$base.XXXXXX")"

  log "probing '$base' with $agent (bounded ${probe_timeout}s, measurement-only, worktree $probe_worktree)"
  set +e
  ( cd "$probe_worktree" && timeout --signal=TERM --kill-after=60 "$probe_timeout" \
      env -u GARDEN_USAGE_FILE -u GARDEN_ENGAGEMENT_USAGE -u GARDEN_COMPLETION_SENTINEL \
      "$cli" -p --output-format json --dangerously-skip-permissions "$prompt" ) >"$envelope" 2>/dev/null
  rc=$?
  set -e 2>/dev/null || true

  # Extract the agent's .result (its report) from the JSON envelope; a malformed or
  # truncated envelope falls back to the raw bytes, exactly as the real handler does.
  if command -v jq >/dev/null 2>&1 && jq -er '.result' "$envelope" >"$report" 2>/dev/null; then
    :
  else
    cp "$envelope" "$report" 2>/dev/null || : >"$report"
  fi

  if [ "$rc" -eq 0 ] && report_has_completion_marker "$report"; then
    capable_succeeded=1
    probe_agent="$agent"
    probe_model="$(sed -n 's/^model:[[:space:]]*//p' "$jobfile" 2>/dev/null | head -1)"
    [ -n "$probe_model" ] || probe_model="$agent-default"
    outcomes="${outcomes}${agent}=succeeded;"
    log "capability probe: $agent COMPLETED '$base' where the hermit failed — recording a demerit"
    rm -f "$report" "$envelope"
    break
  fi
  log "capability probe: $agent did NOT complete '$base' (rc=$rc, marker $( report_has_completion_marker "$report" && echo present || echo absent )); no demerit from this agent"
  outcomes="${outcomes}${agent}=rc$rc;"
  rm -f "$report" "$envelope"
done

# Teardown the throwaway worktree; it carries no keepable state.
[ -e "$probe_worktree" ] && scratch_cleanup "$probe_worktree" 2>/dev/null || true

# --- record the outcome (probe marker always; demerit on capable success) ----
# Both ride ONE single-writer CAS push (own files under reputation/), retried on a lost
# race exactly like complete-job's completion push.
for attempt in $(seq 1 20); do
  sync_clone "$DIR" || { log "probe clone offline while recording '$base'; will retry"; backoff "$attempt"; continue; }

  # Re-check dedup under the fresh sync: a peer host may have recorded it meanwhile.
  if [ -f "$DIR/$probe_marker" ] || [ -f "$DIR/$demerit_rel" ]; then
    clone_unlock "$DIR" 2>/dev/null || true
    log "'$base' probe record appeared from a peer; nothing to record"
    exit 0
  fi

  mkdir -p "$DIR/$(dirname "$probe_marker")"
  {
    printf -- '---\n'
    printf 'base: %s\n' "$base"
    printf 'kind: %s\n' "$KIND"
    printf 'provider: %s\n' "$arm_provider"
    printf 'model: %s\n' "$arm_model"
    printf 'thoughtfulness: %s\n' "$arm_tht"
    printf 'work_class: %s\n' "$work_class"
    printf 'target: %s\n' "$target"
    printf 'capable_succeeded: %s\n' "$capable_succeeded"
    printf 'probe_agent: %s\n' "${probe_agent:-none}"
    printf 'agent_outcomes: %s\n' "${outcomes:-none}"
    printf 'recorded_by: %s\n' "${GARDEN:-unknown}/hermit-probe"
    printf 'recorded_at: %s\n' "$(date -u +%FT%TZ)"
    printf -- '---\n'
    if [ "$capable_succeeded" -eq 1 ]; then
      printf 'hermit probe for %s: a capable model (%s) COMPLETED the work the local/%s arm failed; demerit recorded for work_class %s target %s\n' \
        "$base" "$probe_agent" "$arm_model" "$work_class" "$target"
    else
      printf 'hermit probe for %s: no capable agent completed the work either (%s); the local/%s failure is not attributed a demerit\n' \
        "$base" "${outcomes:-none}" "$arm_model"
    fi
  } > "$DIR/$probe_marker"
  git -C "$DIR" add "$probe_marker"

  if [ "$capable_succeeded" -eq 1 ]; then
    rep_record_demerit "$DIR" "$base" "$KIND" "$arm_provider" "$arm_model" "$arm_tht" \
      "$work_class" "$target" "$local_dollars" "$probe_agent" "$probe_model"
  fi

  rc=0; commit_and_push "$DIR" "hermit-probe($base): capable_succeeded=$capable_succeeded ($GARDEN)" || rc=$?
  if [ "$rc" -eq 0 ]; then
    log "recorded hermit probe for '$base' (capable_succeeded=$capable_succeeded)"
    exit 0
  fi
  [ "$rc" -eq 2 ] && { log "hermit probe for '$base' already recorded (nothing to commit)"; exit 0; }
  log "hermit probe record for '$base' lost a push race (attempt $attempt); retrying"
  backoff "$attempt"
done
log "could not record hermit probe for '$base' after retries; leaving unrecorded (best-effort)"
exit 0
