#!/bin/bash
# driver.sh -- the manually-invoked driver entry point.
#
# Usage:
#   scripts/driver/driver.sh <lane>
#
# <lane> is a small integer chosen by the maintainer. Two drivers on the
# same host must use different lane numbers.
#
# Environment overrides (honored by both the script and the test harness):
#   GARDEN_ROOT          default: script-location-relative grandparent
#   GARDEN_JOURNAL       default: $GARDEN_ROOT/journal
#   GARDEN_HOST          default: $(hostname -s)
#   DRIVER_WORKFLOW      default: inferred from DRIVER_PR or claimed job
#   DRIVER_PR            optional: <owner>/<repo>#<n> the driver subscribes to
#   DRIVER_TICK_SECONDS  default: 30
#   DRIVER_ONESHOT       default: 0 (set to 1 to run one pass and exit)
#
# The driver wraps its inner body in a -x subshell that captures a
# transcript. An ERR trap fans unexpected failures out to the gardener
# inbox via skills/gardener-inbox-error-reporting/report-error.sh.
#
# See scripts/driver/README.md for the human-facing overview.
# See skills/driver-pr-creation-state-machine/SKILL.md for the PR-creation
# workflow's full state diagram.
# See skills/driver-design-only-pr-workflow/SKILL.md for the design-only
# workflow used in Phase 2.

set -uo pipefail

# --- argument parsing ---------------------------------------------------

if [ "$#" -lt 1 ]; then
  echo "usage: $0 <lane>" >&2
  exit 64
fi

LANE=$1
case "$LANE" in
  ''|*[!0-9]*) echo "driver: lane must be a non-negative integer (got: $LANE)" >&2; exit 64;;
esac

# --- environment resolution --------------------------------------------

SCRIPT_PATH=$(cd "$(dirname "$0")" && pwd)
DEFAULT_GARDEN_ROOT=$(cd "$SCRIPT_PATH/../.." && pwd)
GARDEN_ROOT=${GARDEN_ROOT:-$DEFAULT_GARDEN_ROOT}
GARDEN_HOST=${GARDEN_HOST:-$(hostname -s)}
DRIVER_WORKFLOW=${DRIVER_WORKFLOW:-}
DRIVER_PR=${DRIVER_PR:-}
DRIVER_TICK_SECONDS=${DRIVER_TICK_SECONDS:-30}
DRIVER_ONESHOT=${DRIVER_ONESHOT:-0}

# Snapshot whether the lane was bound externally via env at startup. An
# env-bound lane drives one PR to terminal and exits (legacy bring-up
# shape); a claim-bound lane (no DRIVER_PR at startup) claims jobs from
# journal/jobs/open/ and resumes the loop after each terminal so systemd
# keeps the unit alive across many jobs.
DRIVER_PR_FROM_ENV=$DRIVER_PR
DRIVER_WORKFLOW_FROM_ENV=$DRIVER_WORKFLOW

# Per-lane journal worktree. The primary journal at GARDEN_ROOT/journal
# holds the shared .git database. Each lane operates in its own
# detached worktree under journal-worktrees/<lane>/ so concurrent
# claim/complete/reset/rebase operations across lanes do not share an
# index — each lane has its own .git/worktrees/<lane>/{HEAD,index},
# and bash's filesystem-level race surface shrinks to just the shared
# objects database, which git already serializes via the loose-object
# write protocol.
PRIMARY_JOURNAL="$GARDEN_ROOT/journal"
GARDEN_JOURNAL=${GARDEN_JOURNAL:-$GARDEN_ROOT/journal-worktrees/$LANE}

test -d "$GARDEN_ROOT" || { echo "driver: GARDEN_ROOT not a directory: $GARDEN_ROOT" >&2; exit 1; }

# Self-heal the per-lane worktree on first start (or after the host
# operator removes it).  Created detached at origin/journal so the
# lane begins from upstream's view; the bot identity propagates from
# the primary worktree's local git config.
ensure_lane_worktree() {
  if [ -d "$GARDEN_JOURNAL/.git" ] || [ -f "$GARDEN_JOURNAL/.git" ]; then
    return 0
  fi
  if [ ! -d "$PRIMARY_JOURNAL/.git" ]; then
    echo "driver: PRIMARY_JOURNAL not a git repository: $PRIMARY_JOURNAL" >&2
    echo "driver: clone kriskowal/garden:journal there before starting lanes" >&2
    return 1
  fi
  git -C "$PRIMARY_JOURNAL" fetch --quiet origin journal 2>/dev/null || true
  mkdir -p "$(dirname "$GARDEN_JOURNAL")"
  git -C "$PRIMARY_JOURNAL" worktree add --detach "$GARDEN_JOURNAL" origin/journal >/dev/null
  local n e
  n=$(git -C "$PRIMARY_JOURNAL" config --get user.name 2>/dev/null || echo "")
  e=$(git -C "$PRIMARY_JOURNAL" config --get user.email 2>/dev/null || echo "")
  [ -n "$n" ] && git -C "$GARDEN_JOURNAL" config user.name "$n"
  [ -n "$e" ] && git -C "$GARDEN_JOURNAL" config user.email "$e"
}

ensure_lane_worktree || exit 1
test -d "$GARDEN_JOURNAL" || { echo "driver: GARDEN_JOURNAL not a directory: $GARDEN_JOURNAL" >&2; exit 1; }

STATE_DIR="$GARDEN_JOURNAL/drivers/$GARDEN_HOST"
STATE_FILE="$STATE_DIR/$LANE.md"
SUBSCRIPTIONS_FILE="$STATE_DIR/$LANE.subscriptions"
# Tracks which jobs/claimed/...md path this lane is currently working,
# so a daemon restart can resume the same claim instead of stranding it.
CLAIMED_JOB_FILE="$STATE_DIR/$LANE.claimed-job"
mkdir -p "$STATE_DIR"

# --- transcript and trap setup -----------------------------------------

TRANSCRIPT_DIR=${TMPDIR:-/tmp}
TRANSCRIPT=$(mktemp "$TRANSCRIPT_DIR/driver-lane${LANE}-XXXXXX.log")
TRANSCRIPT_KEPT=0

cleanup_transcript() {
  # Hash the transcript into the journal so it survives the temp-dir
  # cleanup that any harness might do, even on a clean exit. The blob is
  # unreferenced; git gc will collect it after the journal's grace window.
  if [ -s "$TRANSCRIPT" ] && { [ -d "$GARDEN_JOURNAL/.git" ] || [ -f "$GARDEN_JOURNAL/.git" ]; }; then
    git -C "$GARDEN_JOURNAL" hash-object -w --stdin < "$TRANSCRIPT" >/dev/null 2>&1 || true
  fi
  if [ "$TRANSCRIPT_KEPT" = 0 ] && [ -f "$TRANSCRIPT" ]; then
    rm -f "$TRANSCRIPT"
  fi
}

# Report unexpected exits to the gardener inbox. The trap discriminates on
# $? at EXIT time: a non-zero exit is treated as unexpected unless the
# driver set DRIVER_EXPECTED_EXIT=1 just before returning.
DRIVER_EXPECTED_EXIT=0
report_unexpected_exit() {
  local rc=$?
  if [ "$rc" -ne 0 ] && [ "$DRIVER_EXPECTED_EXIT" = 0 ]; then
    TRANSCRIPT_KEPT=1
    local state="unknown"
    if [ -f "$STATE_FILE" ]; then
      state=$(sed -n 's/^state: //p' "$STATE_FILE" 2>/dev/null | head -1)
      [ -z "$state" ] && state="unknown"
    fi
    "$GARDEN_ROOT/skills/gardener-inbox-error-reporting/report-error.sh" \
      --transcript "$TRANSCRIPT" \
      --lane "$LANE" \
      --pr "${DRIVER_PR:-(none)}" \
      --state "$state" \
      --context "driver lane $LANE exited with code $rc during workflow ${DRIVER_WORKFLOW:-unknown}" \
      >/dev/null 2>&1 || true
  fi
  cleanup_transcript
}

trap 'report_unexpected_exit' EXIT

# --- workflow selection -------------------------------------------------

select_workflow() {
  # Resolve DRIVER_WORKFLOW from explicit env, or from the state file's
  # `workflow:` field if a state file exists, or by inferring from
  # DRIVER_PR's title (a design-only PR's title contains "design(" by
  # convention). Default: design-only-pr for Phase 2 simplicity.
  if [ -n "$DRIVER_WORKFLOW" ]; then
    return 0
  fi
  if [ -f "$STATE_FILE" ]; then
    local from_state
    from_state=$(sed -n 's/^workflow: //p' "$STATE_FILE" | head -1)
    if [ -n "$from_state" ]; then
      DRIVER_WORKFLOW=$from_state
      return 0
    fi
  fi
  # Phase 2 default: design-only-pr. Sibling PRs land the
  # PR-creation-workflow path with a different inference rule.
  DRIVER_WORKFLOW=design-only-pr
}

# --- state file helpers -------------------------------------------------

read_state() {
  if [ ! -f "$STATE_FILE" ]; then
    echo "initial"
    return 0
  fi
  # sed (not awk -F:) so internal colons in values like
  # "solicitor:design-panel" survive parsing.
  sed -n 's/^state: //p' "$STATE_FILE" | head -1
}

read_awaits() {
  if [ ! -f "$STATE_FILE" ]; then
    echo ""
    return 0
  fi
  sed -n 's/^awaits: //p' "$STATE_FILE" | head -1
}

write_state() {
  local state=$1
  local awaits=${2:-null}
  local body=${3:-"driver lane $LANE in state $state"}
  local iso
  iso=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  cat > "$STATE_FILE" <<EOF
---
host: $GARDEN_HOST
lane: $LANE
workflow: $DRIVER_WORKFLOW
pr: ${DRIVER_PR:-(none)}
state: $state
awaits: $awaits
last_tick: $iso
---

# driver lane $LANE state

$body
EOF
}

# --- workflow dispatchers ----------------------------------------------

# A workflow dispatcher takes the current state name and returns one of:
#   advance:<next-state>:<awaits-or-null>
#   wait
#   escalate:<reason>
#   terminal:<final-state>
#
# Each workflow dispatcher reads PR state via the get_pr_json helper,
# which the test harness can stub by setting GH_STUB=path/to/stubbed-json.

get_pr_json() {
  if [ -n "${GH_STUB:-}" ] && [ -f "$GH_STUB" ]; then
    cat "$GH_STUB"
    return 0
  fi
  if [ -z "$DRIVER_PR" ]; then
    echo "{}"
    return 0
  fi
  # Split <owner>/<repo>#<n>.
  local pr_id=$DRIVER_PR
  local owner_repo=${pr_id%%#*}
  local n=${pr_id##*#}
  gh pr view "$n" --repo "$owner_repo" --json state,isDraft,reviews,labels,files,title 2>/dev/null || echo "{}"
}

dispatch_design_only_pr_workflow() {
  local state=$1
  local pr_json
  pr_json=$(get_pr_json)
  case "$state" in
    initial)
      # Predicate: a design file exists, no PR is open yet. Side effect:
      # post a build-design-only job to the builder board (or, in Phase
      # 2 simplification, advance straight to build if the PR already
      # exists per DRIVER_PR).
      if [ -n "$DRIVER_PR" ]; then
        echo "advance:build:null"
      else
        # No PR yet, no DRIVER_PR set: post a build job. Phase 2 stops
        # at the "post" step; the test harness exercises the path with
        # DRIVER_PR already set.
        echo "advance:build:builder:build-design-only"
      fi
      ;;
    build)
      # Predicate: a DRAFT PR exists matching the design's title. The
      # builder worker's result is recorded in the state file's awaits
      # field; the deterministic check is `isDraft == true` and
      # `state == OPEN`.
      local pr_state pr_draft
      pr_state=$(printf '%s' "$pr_json" | sed -n 's/.*"state":"\([^"]*\)".*/\1/p' | head -1)
      pr_draft=$(printf '%s' "$pr_json" | sed -n 's/.*"isDraft":\(true\|false\).*/\1/p' | head -1)
      if [ "$pr_state" = "OPEN" ] && [ "$pr_draft" = "true" ]; then
        echo "advance:panel:solicitor:design-panel"
      else
        echo "wait"
      fi
      ;;
    panel)
      # Predicate: the solicitor's result entry has landed (a kriscendobot
      # review exists on the PR). The driver reads the verdict and
      # classifies it.
      local has_review
      has_review=$(printf '%s' "$pr_json" | grep -c 'kriscendobot' || true)
      if [ "$has_review" -gt 0 ]; then
        echo "advance:verdict:null"
      else
        echo "wait"
      fi
      ;;
    verdict)
      # Classify the verdict. Phase 2 treats a "verdict: approve" string
      # in the review body as deterministic; anything else escalates.
      local approve_signal must_fix_signal appellate_signal
      approve_signal=$(printf '%s' "$pr_json" | grep -c 'verdict: approve' || true)
      must_fix_signal=$(printf '%s' "$pr_json" | grep -c 'verdict: must-fix-loop' || true)
      appellate_signal=$(printf '%s' "$pr_json" | grep -c 'verdict: appeal-ok' || true)
      if [ "$approve_signal" -gt 0 ]; then
        echo "advance:un-draft:null"
      elif [ "$appellate_signal" -gt 0 ]; then
        echo "advance:appellate:appellate:design-appeal"
      elif [ "$must_fix_signal" -gt 0 ]; then
        echo "advance:fixer-design:designer:design-amend"
      else
        echo "escalate:verdict-body-ambiguous"
      fi
      ;;
    un-draft)
      # Deterministic action: gh pr ready <n>. Phase 2 calls a stubbable
      # helper so tests can verify the call without a real gh.
      run_un_draft "$DRIVER_PR" && echo "advance:await-maintainer:null"
      ;;
    await-maintainer)
      # Wait for a maintainer event. Phase 2 happy path: APPROVED review
      # lands deterministically.
      local maintainer_approved
      maintainer_approved=$(printf '%s' "$pr_json" | grep -c 'APPROVED' || true)
      if [ "$maintainer_approved" -gt 0 ]; then
        echo "advance:approved+green:conductor:design-merge"
      else
        echo "wait"
      fi
      ;;
    approved+green)
      # Watch for the conductor's merge to land.
      local pr_state
      pr_state=$(printf '%s' "$pr_json" | sed -n 's/.*"state":"\([^"]*\)".*/\1/p' | head -1)
      if [ "$pr_state" = "MERGED" ]; then
        echo "terminal:merged"
      else
        echo "wait"
      fi
      ;;
    fixer-design)
      # Wait for a designer push to land, then return to panel.
      # Phase 2 does not exercise this branch; predicate is here for
      # completeness.
      echo "wait"
      ;;
    appellate)
      # Wait for the appellate result.
      echo "wait"
      ;;
    merged|closed|abandoned)
      echo "terminal:$state"
      ;;
    *)
      echo "escalate:unknown-state-$state"
      ;;
  esac
}

# Run-the-gamut workflow.  Drives a code PR through the full
# PR-creation-flow chain (builder → cleaner → barrister → fixer-loop →
# appellate → un-draft).  Phase 2 implements only the entry and the
# terminal predicates; the in-flight body delegates substantive next-
# stage advancement to claude via escalate_to_claude, which lands a
# gardener-inbox message naming the PR and the lane.  The driver still
# polls the PR each tick and reaches terminal when GitHub reports the
# PR as MERGED or CLOSED.
dispatch_gamut_workflow() {
  local state=$1
  local pr_json
  pr_json=$(get_pr_json)
  case "$state" in
    initial)
      # Acknowledge the claim by escalating once, then transition to
      # the long-polling in-flight state.  The escalation lands one
      # gardener-inbox message naming the PR; subsequent ticks do not
      # re-escalate unless the PR's state changes unexpectedly.
      escalate_to_claude "gamut-bootstrap:${DRIVER_PR:-unknown}" >/dev/null 2>&1 || true
      echo "advance:in-flight:null"
      ;;
    in-flight)
      # Terminal predicates: GitHub reports MERGED or CLOSED.  Anything
      # else is "still in motion"; wait until the next tick.
      local pr_state
      pr_state=$(printf '%s' "$pr_json" | sed -n 's/.*"state":"\([^"]*\)".*/\1/p' | head -1)
      case "$pr_state" in
        MERGED) echo "terminal:merged" ;;
        CLOSED) echo "terminal:closed" ;;
        *) echo "wait" ;;
      esac
      ;;
    merged|closed)
      echo "terminal:$state"
      ;;
    *)
      echo "escalate:unknown-state-$state"
      ;;
  esac
}

# --- deterministic-step helpers ----------------------------------------

run_un_draft() {
  local pr_id=$1
  # Test harness can stub via UN_DRAFT_STUB=path/to/echo-script.
  if [ -n "${UN_DRAFT_STUB:-}" ]; then
    "$UN_DRAFT_STUB" "$pr_id"
    return $?
  fi
  if [ -z "$pr_id" ]; then
    return 1
  fi
  local owner_repo=${pr_id%%#*}
  local n=${pr_id##*#}
  gh pr ready "$n" --repo "$owner_repo"
}

post_job() {
  local role=$1
  local slug=$2
  # Test harness can stub via POST_JOB_STUB=path/to/echo-script.
  if [ -n "${POST_JOB_STUB:-}" ]; then
    "$POST_JOB_STUB" "$role" "$slug"
    return $?
  fi
  : >/tmp/driver-job-body.$$
  cat <<EOF >/tmp/driver-job-body.$$
Job posted by driver lane $LANE for PR ${DRIVER_PR:-(none)}.
Workflow: $DRIVER_WORKFLOW.
EOF
  GARDEN_ROLE=driver \
    "$GARDEN_ROOT/skills/job-board/post-job.sh" "$role" "$slug" \
      ${DRIVER_PR:+--repo "${DRIVER_PR%%#*}"} \
      ${DRIVER_PR:+--pr "${DRIVER_PR##*#}"} \
      --eligible "$role" \
      < /tmp/driver-job-body.$$
  local rc=$?
  rm -f /tmp/driver-job-body.$$
  return "$rc"
}

escalate_to_claude() {
  local reason=$1
  # Phase 2 placeholder: the prompt-on-failure-capture skill is a
  # sibling PR. Until that skill's helper lands, the escalation reports
  # to the gardener inbox and returns a non-fatal "park" signal.
  echo "driver: escalation requested ($reason); deferring to gardener inbox" >&2
  if [ -n "${CLAUDE_ESCALATE_STUB:-}" ]; then
    "$CLAUDE_ESCALATE_STUB" "$reason"
    return $?
  fi
  # Real implementation: hash the relevant slice of state, build a
  # four-slot prompt, pipe to `claude -p`. Phase 2 stubs this to a
  # gardener-inbox message.
  if [ -x "$GARDEN_ROOT/skills/gardener-inbox-error-reporting/report-error.sh" ]; then
    "$GARDEN_ROOT/skills/gardener-inbox-error-reporting/report-error.sh" \
      --transcript "$TRANSCRIPT" \
      --lane "$LANE" \
      --pr "${DRIVER_PR:-(none)}" \
      --state "$(read_state)" \
      --context "escalation: $reason (prompt-on-failure-capture skill pending)" \
      >/dev/null 2>&1 || true
  fi
  return 1
}

# --- per-tick capture + self-improvement -------------------------------

# capture_and_self_improve <tick-capture-path> <tick-rc>
#
# Hash the per-tick capture into the journal's object database so the
# transcript survives as a blob, then invoke an agent (claude) with the
# capture SHA and append the agent's analysis to a per-lane
# improvements file at $GARDEN_JOURNAL/drivers/<host>/<lane>.improvements.md.
#
# The agent invocation runs in the background so the next tick is not
# blocked. The agent reads the transcript on demand via
# `git -C <journal> cat-file blob <sha>`; the prompt stays small.
#
# Test harness can stub the agent invocation via SELF_IMPROVE_CLAUDE_STUB
# (path to a script that takes the SHA as its sole positional argument and
# emits the analysis on stdout); when unset, we exec `claude -p <prompt>`
# from PATH (the mock harness PATH-stubs `claude`).
#
# Failures here are silent: self-improvement is best-effort and must not
# crash the driver. Each branch ORs with `:` so a bad git, missing claude,
# or unwritable improvements file leaves the loop unaffected.
capture_and_self_improve() {
  local tick_capture=$1
  local tick_rc=$2

  # Bail if the capture is empty or the journal is not a git repo.
  if [ ! -s "$tick_capture" ]; then
    return 0
  fi
  if [ ! -d "$GARDEN_JOURNAL/.git" ] && [ ! -f "$GARDEN_JOURNAL/.git" ]; then
    return 0
  fi

  # Hash the capture into the journal's object DB. The blob is
  # unreferenced; git gc will collect it after the grace window unless
  # an agent or operator anchors it with refs/captures/...
  local capture_sha
  capture_sha=$(git -C "$GARDEN_JOURNAL" hash-object -w --stdin < "$tick_capture" 2>/dev/null) || return 0
  if [ -z "$capture_sha" ]; then
    return 0
  fi

  local improvements_dir="$GARDEN_JOURNAL/drivers/$GARDEN_HOST"
  local improvements_file="$improvements_dir/$LANE.improvements.md"
  mkdir -p "$improvements_dir"

  # Initialize the improvements file on first run with frontmatter so it
  # is grep-able by host/lane and the gardener can pick it up.
  if [ ! -f "$improvements_file" ]; then
    cat > "$improvements_file" <<EOF
---
host: $GARDEN_HOST
lane: $LANE
kind: driver-self-improvement-log
---

# driver lane $LANE self-improvement log

Per-tick agent analysis of driver loop iterations. Each section names
the tick's transcript SHA (inspect via \`git -C journal cat-file blob <sha>\`)
and the agent's suggestions for self-improvement.

EOF
  fi

  local iso state
  iso=$(date -u +%Y-%m-%dT%H:%M:%SZ)
  state=$(read_state 2>/dev/null) || state=unknown

  # Build the agent prompt. The four-slot brief mirrors the prompt-on-
  # failure-capture pattern: PR id, workflow, state, capture SHA.
  local prompt
  prompt="Driver loop iteration transcript SHA: $capture_sha
PR: ${DRIVER_PR:-(none)}
Workflow: ${DRIVER_WORKFLOW:-unknown}
State: $state
Tick exit code: $tick_rc

Please analyze the transcript and suggest any self-improvements for
the driver's behavior in this state. Read the transcript on demand via:
  git -C $GARDEN_JOURNAL cat-file blob $capture_sha
"

  # Invoke the agent. Run in the background so the next tick is not
  # blocked. The agent's response is appended atomically once it
  # completes; concurrent appends across overlapping ticks are vanishingly
  # rare in practice but a flock would close that race if it mattered.
  _self_improve_invoke_async "$capture_sha" "$state" "$tick_rc" "$iso" "$prompt" "$improvements_file" &
  # We deliberately do not `wait`; the background analyzer survives the
  # tick's return and writes its section when it finishes. In oneshot
  # mode the test harness joins via the SELF_IMPROVE_SYNC flag below.
  if [ "${SELF_IMPROVE_SYNC:-0}" = 1 ]; then
    wait
  fi
  return 0
}

_self_improve_invoke_async() {
  local capture_sha=$1
  local state=$2
  local tick_rc=$3
  local iso=$4
  local prompt=$5
  local improvements_file=$6

  local response
  if [ -n "${SELF_IMPROVE_CLAUDE_STUB:-}" ]; then
    response=$("$SELF_IMPROVE_CLAUDE_STUB" "$capture_sha" 2>/dev/null) || response="(stub returned non-zero)"
  elif command -v claude >/dev/null 2>&1; then
    response=$(printf '%s' "$prompt" | claude -p 2>/dev/null) || response="(claude invocation failed)"
  else
    response="(no agent available: claude not on PATH and no stub configured)"
  fi

  {
    printf '\n## tick at %s -- state=%s rc=%s sha=%s\n\n' \
      "$iso" "$state" "$tick_rc" "$capture_sha"
    printf 'PR: %s\n' "${DRIVER_PR:-(none)}"
    printf 'Workflow: %s\n\n' "${DRIVER_WORKFLOW:-unknown}"
    printf '### agent analysis\n\n'
    printf '%s\n' "$response"
  } >> "$improvements_file" 2>/dev/null || true
}

# --- job-board claim handling -------------------------------------------

read_claimed_job() {
  [ -f "$CLAIMED_JOB_FILE" ] || return 0
  cat "$CLAIMED_JOB_FILE"
}

write_claimed_job() {
  printf '%s\n' "$1" > "$CLAIMED_JOB_FILE"
}

clear_claimed_job() {
  rm -f "$CLAIMED_JOB_FILE"
}

# Parse a claimed job's frontmatter and populate DRIVER_WORKFLOW and
# DRIVER_PR. The post-job.sh schema emits `verb:` at the top level and
# `target.repo` / `target.pr` indented under `target:`.
parse_claimed_job_into_env() {
  local path=$1
  local verb repo pr
  verb=$(sed -n 's/^verb: //p' "$path" | head -1)
  repo=$(sed -n 's/^  repo: //p' "$path" | head -1)
  pr=$(sed -n 's/^  pr: //p' "$path" | head -1)
  DRIVER_WORKFLOW=$verb
  if [ -n "$repo" ] && [ "$repo" != "null" ] && [ -n "$pr" ] && [ "$pr" != "null" ]; then
    DRIVER_PR="${repo}#${pr}"
  else
    DRIVER_PR=""
  fi
}

# Workflows this driver knows how to dispatch. Jobs whose `verb:` is
# outside this set are skipped at claim time and left for some other
# eligible consumer (the steward, a future driver build) to claim. Add
# verbs here as new dispatch_<verb>_workflow functions land.
driver_handles_verb() {
  case "$1" in
    design-only-pr|gamut|pr-creation) return 0 ;;
    *) return 1 ;;
  esac
}

# Returns 0 if the job's `eligible_roles:` list names `driver`. The
# eligibility list is a top-level YAML field whose entries are indented
# `  - <role>` lines; the producer asserts which consumer roles are
# allowed to claim the job. A driver lane skips jobs that do not name
# it.
job_eligible_for_driver() {
  awk '
    /^[^[:space:]]/ { in_list=0 }
    /^eligible_roles:/ { in_list=1; next }
    in_list && /^  - / { sub(/^  - /, ""); roles[NR] = $0 }
    END {
      for (k in roles) if (roles[k] == "driver") { found=1; break }
      exit (found ? 0 : 1)
    }
  ' "$1"
}

# Race to claim one open job. Echoes the claimed path on success;
# returns 1 if the inbox is empty or every visible job was lost to
# another claimant. Filters out jobs whose `verb:` the driver does
# not implement or whose `eligible_roles:` does not include `driver`,
# so a lane only attempts claims it can actually drive.
try_claim_one() {
  local open_dir="$GARDEN_JOURNAL/jobs/open"
  [ -d "$open_dir" ] || return 1
  local f rel claimed verb
  for f in "$open_dir"/*.md; do
    [ -f "$f" ] || continue
    job_eligible_for_driver "$f" || continue
    verb=$(sed -n 's/^verb: //p' "$f" | head -1)
    driver_handles_verb "$verb" || continue
    rel="jobs/open/$(basename "$f")"
    claimed=$(GARDEN_ROLE=driver "$GARDEN_ROOT/skills/job-board/claim-job.sh" "$rel" 2>/dev/null) || continue
    [ "$claimed" = "lost-race" ] && continue
    [ -n "$claimed" ] || continue
    printf '%s\n' "$claimed"
    return 0
  done
  return 1
}

# Returns 0 when this lane has a claimed job (existing or newly claimed)
# and DRIVER_PR/DRIVER_WORKFLOW are populated from its frontmatter.
# Returns 1 when no job is available — the caller should idle this tick.
ensure_claimed_job() {
  local recorded
  recorded=$(read_claimed_job)
  if [ -n "$recorded" ] && [ -f "$GARDEN_JOURNAL/$recorded" ]; then
    parse_claimed_job_into_env "$GARDEN_JOURNAL/$recorded"
    return 0
  fi
  # Stale or absent — try to claim a new one.
  local newly
  newly=$(try_claim_one) || return 1
  write_claimed_job "$newly"
  parse_claimed_job_into_env "$GARDEN_JOURNAL/$newly"
  # Reset state file for the new job. The workflow runs from `initial`.
  write_state "initial" "null" "claimed $newly"
  return 0
}

# Move the current claimed job to done/ via complete-job.sh, then clear
# the per-lane claim and workflow bindings so the next tick claims again.
release_claimed_job_done() {
  local recorded
  recorded=$(read_claimed_job)
  if [ -n "$recorded" ] && [ -x "$GARDEN_ROOT/skills/job-board/complete-job.sh" ]; then
    "$GARDEN_ROOT/skills/job-board/complete-job.sh" "$recorded" done >/dev/null 2>&1 || true
  fi
  clear_claimed_job
  DRIVER_PR=""
  DRIVER_WORKFLOW=""
}

# --- main loop ----------------------------------------------------------

run_once() {
  local state next_directive

  # Claim-bound lanes (no DRIVER_PR at startup) acquire their PR and
  # workflow from the job board on each tick. Env-bound lanes skip the
  # board entirely and drive the single PR they were launched with.
  # The journal is a shared clone of kriskowal/garden:journal; each
  # claim/complete via skills/job-board/{claim,complete}-job.sh fetches
  # from origin before touching the inbox, so no separate sync step is
  # needed here.
  if [ -z "$DRIVER_PR_FROM_ENV" ]; then
    if ! ensure_claimed_job; then
      # Inbox is empty. Surface the wait in the state file so external
      # observers see the lane is idle, then return so the outer loop
      # sleeps until the next tick.
      DRIVER_WORKFLOW=idle
      write_state "idle" "null" "no open jobs; polling inbox"
      return 0
    fi
    # Refresh the per-lane subscription advertisement to match the
    # currently-claimed PR.
    if [ -n "$DRIVER_PR" ]; then
      printf '%s\n' "$DRIVER_PR" > "$SUBSCRIPTIONS_FILE"
    else
      : > "$SUBSCRIPTIONS_FILE"
    fi
  fi

  state=$(read_state)

  case "$DRIVER_WORKFLOW" in
    design-only-pr)
      next_directive=$(dispatch_design_only_pr_workflow "$state")
      ;;
    gamut|pr-creation)
      # The two verbs share the same minimal Phase 2 state machine: a
      # one-shot escalation at claim and a poll-until-terminal body.
      next_directive=$(dispatch_gamut_workflow "$state")
      ;;
    *)
      echo "driver: unknown workflow: $DRIVER_WORKFLOW" >&2
      escalate_to_claude "unknown-workflow:$DRIVER_WORKFLOW" || true
      next_directive="wait"
      ;;
  esac

  case "$next_directive" in
    advance:*)
      # advance:<next-state>:<role>:<slug>  OR  advance:<next-state>:null
      local rest=${next_directive#advance:}
      local next_state
      local awaits=null
      local role_slug=${rest#*:}
      next_state=${rest%%:*}
      if [ "$role_slug" != "null" ] && [ -n "$role_slug" ]; then
        local role=${role_slug%%:*}
        local slug=${role_slug#*:}
        if post_job "$role" "$slug" >/dev/null 2>&1; then
          awaits="$role:$slug"
        else
          # Posting failed; persist the wait state instead of corrupting
          # the state file with a missing awaits.
          echo "driver: post_job $role $slug failed; staying in $state" >&2
          return 0
        fi
      fi
      write_state "$next_state" "$awaits" "transitioned from $state to $next_state"
      ;;
    wait)
      # No state change. Refresh last_tick by re-writing the state file.
      write_state "$state" "$(read_awaits)" "waiting in $state"
      ;;
    escalate:*)
      local reason=${next_directive#escalate:}
      if escalate_to_claude "$reason"; then
        : # claude resolved; the response should have been applied.
      else
        # Park in the same state; the next tick re-evaluates.
        write_state "$state" "$(read_awaits)" "parked; awaiting LLM after escalation: $reason"
      fi
      ;;
    terminal:*)
      local final=${next_directive#terminal:}
      write_state "$final" "null" "driver lane $LANE reached terminal state $final"
      if [ -n "$DRIVER_PR_FROM_ENV" ]; then
        # Env-bound: drove the one PR we were launched with; exit cleanly.
        DRIVER_EXPECTED_EXIT=1
        return 2
      fi
      # Claim-bound: release this job and keep ticking so the next tick
      # claims the next one. The outer loop stays alive.
      release_claimed_job_done
      ;;
    *)
      echo "driver: workflow returned malformed directive: $next_directive" >&2
      return 1
      ;;
  esac
  return 0
}

main() {
  # Env-bound lanes resolve their workflow once at startup. Claim-bound
  # lanes leave DRIVER_WORKFLOW unset and let ensure_claimed_job pick it
  # up per-job from each claimed frontmatter; the inbox sync happens
  # naturally inside the claim/complete scripts (each fetches origin
  # before touching the journal).
  if [ -n "$DRIVER_PR_FROM_ENV" ]; then
    select_workflow
  fi

  # Initialize subscription advertisement. Claim-bound lanes refresh
  # this each tick after ensure_claimed_job populates DRIVER_PR.
  if [ -n "$DRIVER_PR" ]; then
    echo "$DRIVER_PR" > "$SUBSCRIPTIONS_FILE"
  else
    : > "$SUBSCRIPTIONS_FILE"
  fi

  # Initialize state file if missing. Claim-bound lanes start "idle"
  # until a job is claimed; env-bound lanes start at the workflow's
  # initial state.
  if [ ! -f "$STATE_FILE" ]; then
    if [ -n "$DRIVER_PR_FROM_ENV" ]; then
      write_state "initial" "null" "driver lane $LANE bootstrap"
    else
      DRIVER_WORKFLOW=idle
      write_state "idle" "null" "driver lane $LANE bootstrap; awaiting claim"
    fi
  fi

  # Outer loop. The -x transcript capture happens inside the loop body so
  # the transcript reflects the most recent tick's commands. Each tick's
  # own stdout+stderr also lands in a per-tick capture file whose SHA is
  # fed to an agent for self-improvement analysis (see capture_and_self_improve).
  while true; do
    # Each tick runs in a subshell with -x so the transcript captures
    # commands and arguments. The outer driver only re-reads its state
    # file between ticks. We capture the tick's combined stdout+stderr to
    # a per-tick file first, then append it to the rolling transcript so
    # the trap path still has the full history if anything goes wrong.
    local tick_capture
    tick_capture=$(mktemp "$TRANSCRIPT_DIR/driver-lane${LANE}-tick-XXXXXX.log")
    ( set -x; run_once ) > "$tick_capture" 2>&1
    local rc=$?
    cat "$tick_capture" >> "$TRANSCRIPT"
    # Capture-and-self-improve happens after the state transition. The
    # agent invocation runs in the background so it does not block the
    # next tick; rc decisions below proceed without waiting. The
    # per-tick capture's content has already been hashed into the
    # journal object DB by the call below, so the tempfile is safe to
    # remove once the call returns (the background analyzer carries
    # only the SHA, not the path).
    capture_and_self_improve "$tick_capture" "$rc"
    rm -f "$tick_capture"
    case "$rc" in
      0) ;;             # continue the loop
      2) DRIVER_EXPECTED_EXIT=1; break;;   # terminal state reached
      *) echo "driver: tick returned $rc; exiting" >&2; exit "$rc";;
    esac
    if [ "$DRIVER_ONESHOT" = 1 ]; then
      DRIVER_EXPECTED_EXIT=1
      break
    fi
    sleep "$DRIVER_TICK_SECONDS"
  done

  DRIVER_EXPECTED_EXIT=1
  exit 0
}

main "$@"
