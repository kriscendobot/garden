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
GARDEN_JOURNAL=${GARDEN_JOURNAL:-$GARDEN_ROOT/journal}
GARDEN_HOST=${GARDEN_HOST:-$(hostname -s)}
DRIVER_WORKFLOW=${DRIVER_WORKFLOW:-}
DRIVER_PR=${DRIVER_PR:-}
DRIVER_TICK_SECONDS=${DRIVER_TICK_SECONDS:-30}
DRIVER_ONESHOT=${DRIVER_ONESHOT:-0}

test -d "$GARDEN_ROOT" || { echo "driver: GARDEN_ROOT not a directory: $GARDEN_ROOT" >&2; exit 1; }
test -d "$GARDEN_JOURNAL" || { echo "driver: GARDEN_JOURNAL not a directory: $GARDEN_JOURNAL" >&2; exit 1; }

STATE_DIR="$GARDEN_JOURNAL/drivers/$GARDEN_HOST"
STATE_FILE="$STATE_DIR/$LANE.md"
SUBSCRIPTIONS_FILE="$STATE_DIR/$LANE.subscriptions"
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
  rm -f /tmp/driver-job-body.$$
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

# --- main loop ----------------------------------------------------------

run_once() {
  local state next_directive
  state=$(read_state)

  case "$DRIVER_WORKFLOW" in
    design-only-pr)
      next_directive=$(dispatch_design_only_pr_workflow "$state")
      ;;
    pr-creation)
      # Phase 2 stub: the PR-creation workflow lands in a sibling PR.
      echo "driver: workflow pr-creation not yet implemented in Phase 2" >&2
      escalate_to_claude "workflow-not-implemented:pr-creation" || true
      next_directive="wait"
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
      DRIVER_EXPECTED_EXIT=1
      return 2  # signal terminal to outer loop
      ;;
    *)
      echo "driver: workflow returned malformed directive: $next_directive" >&2
      return 1
      ;;
  esac
  return 0
}

main() {
  select_workflow

  # Initialize subscription advertisement.
  if [ -n "$DRIVER_PR" ]; then
    echo "$DRIVER_PR" > "$SUBSCRIPTIONS_FILE"
  else
    : > "$SUBSCRIPTIONS_FILE"
  fi

  # Initialize state file if missing.
  if [ ! -f "$STATE_FILE" ]; then
    write_state "initial" "null" "driver lane $LANE bootstrap"
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
