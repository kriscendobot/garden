#!/bin/bash
# ci-wait-merge.sh — block until a PR's CI reaches a terminal state, then CARRY
# THE MERGE TO COMPLETION in the same invocation. This is the deterministic spine
# of the conductor's "waiting for CI" step: a merge dispatch that finds CI pending
# must NOT end the job while waiting — it blocks here until CI settles and then
# merges on green (or reports on red), so a green-but-unmerged PR can never be left
# behind by a job that "completed while waiting" (the endo-but-for-bots #178 bug,
# which bit the same PR twice).
#
# Invoked as: ci-wait-merge.sh <owner/name> <pr-number> [--merge|--no-merge]
#
# Behaviour:
#   * Polls the statusCheckRollup (the source of truth — check_run/check_suite
#     events do NOT appear on the events feed; see skills/pr-ci-watch) on a real
#     timeout/backoff cadence until every check has SETTLED (no QUEUED/IN_PROGRESS/
#     PENDING/WAITING left), or the overall deadline passes.
#   * On GREEN terminal (no failures) and --merge (default): `"$GH" pr merge --merge
#     --delete-branch`, then VERIFY state=MERGED. Issuing the merge in the same
#     invocation as the wait is the whole point — never "wait, exit, hope a later
#     tick merges".
#   * On RED terminal: print the failing checks and exit 3 (the conductor stalls
#     `ci red: needs shepherd`; it does NOT merge red).
#   * On TIMEOUT while still pending: exit 4 — CI is NOT a terminal state, so the
#     caller MUST re-enqueue the merge job (leave it claimable) rather than
#     complete it unmerged.
#
# Exit codes ARE the contract (also echoes a single terminal status line):
#   0  merged (or already MERGED on entry)         → done
#   2  already CLOSED on entry                      → nothing to finalize
#   3  CI red (terminal failure)                    → stall: needs shepherd
#   4  timed out with CI still pending              → re-enqueue, still unmerged
#   1  hard error / merge blocked / not mergeable   → stall with the gh error
#
# --no-merge makes it a pure block-until-CI-terminal probe (exit 0 = green,
# 3 = red, 4 = timeout) for callers that drive the merge themselves.
#
# Silent-failure discipline (the 2026-06-24 jq-outage lesson): require_tools fails
# LOUD on a missing binary, and a failed gh read returns non-zero (escalate) rather
# than being swallowed into a false green.
#
# Tunables (env): GARDEN_CI_DEADLINE_SECS (default 5400 = 90 min),
#   GARDEN_CI_POLL_SECS (default 60), GARDEN_CI_POLL_MAX_SECS (backoff cap, 60).

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"
GARDEN_TAG="ci-wait-merge"

repo="${1:?usage: ci-wait-merge.sh <owner/name> <pr-number> [--merge|--no-merge]}"
pr="${2:?usage: ci-wait-merge.sh <owner/name> <pr-number> [--merge|--no-merge]}"
do_merge=1
case "${3:-}" in
  --no-merge) do_merge=0 ;;
  --merge|"") do_merge=1 ;;
  *) die "unknown flag: ${3:-} (expected --merge or --no-merge)" ;;
esac

# The gh binary is overridable (GARDEN_GH) so the block-then-merge logic can be
# driven by a stub in tests without a live GitHub.
GH="${GARDEN_GH:-gh}"
require_tools jq
{ [ -x "$GH" ] || command -v "$GH" >/dev/null 2>&1; } || require_tools "$GH"

deadline_secs="${GARDEN_CI_DEADLINE_SECS:-5400}"
poll_secs="${GARDEN_CI_POLL_SECS:-60}"
poll_max="${GARDEN_CI_POLL_MAX_SECS:-60}"
start="$(date +%s)"

# One rollup read. Echoes "<state>|<pending>|<failed>|<total>" on stdout, or
# returns non-zero (never a fabricated green) when the read itself fails.
read_rollup() {
  local json state pending failed total
  json="$("$GH" pr view "$pr" -R "$repo" --json state,mergeable,statusCheckRollup 2>/dev/null)" \
    || { log "gh pr view $repo#$pr failed — aborting this tick (never fabricate green)"; return 1; }
  [ -n "$json" ] || { log "empty PR state for $repo#$pr"; return 1; }
  state="$(printf '%s' "$json" | jq -r '.state // ""')"
  failed="$(printf '%s' "$json" | jq -r '
    [ .statusCheckRollup[]?
      | ((.conclusion // .state // "") | ascii_upcase) as $c
      | select($c=="FAILURE" or $c=="ERROR" or $c=="CANCELLED"
               or $c=="TIMED_OUT" or $c=="ACTION_REQUIRED" or $c=="STARTUP_FAILURE") ]
    | length')"
  pending="$(printf '%s' "$json" | jq -r '
    [ .statusCheckRollup[]?
      | ((.status // .state // "") | ascii_upcase) as $s
      | select($s=="QUEUED" or $s=="IN_PROGRESS" or $s=="PENDING" or $s=="WAITING") ]
    | length')"
  total="$(printf '%s' "$json" | jq -r '[ .statusCheckRollup[]? ] | length')"
  printf '%s|%s|%s|%s\n' "$state" "${pending:-0}" "${failed:-0}" "${total:-0}"
}

print_failures() {
  # shellcheck disable=SC2016  # jq program — $c is jq's, not the shell's.
  "$GH" pr view "$pr" -R "$repo" --json statusCheckRollup --jq '
    .statusCheckRollup[]?
    | ((.conclusion // .state // "") | ascii_upcase) as $c
    | select($c=="FAILURE" or $c=="ERROR" or $c=="CANCELLED"
             or $c=="TIMED_OUT" or $c=="ACTION_REQUIRED" or $c=="STARTUP_FAILURE")
    | "  red: \(.name // .context // "?") = \($c)"' 2>/dev/null || true
}

# A persistent read failure must NOT loop past the deadline. Honor the same bound
# the pending branch does, so a flapping gh/network can never spin unbounded.
past_deadline() { [ $(( $(date +%s) - start )) -ge "$deadline_secs" ]; }

# --- block until CI is terminal (or the deadline passes) --------------------
while :; do
  if ! rollup="$(read_rollup)"; then
    if past_deadline; then
      echo "ci-wait-timeout repo=$repo pr=$pr (gh read kept failing) after ${deadline_secs}s — STILL UNMERGED, re-enqueue"
      exit 4
    fi
    sleep "$poll_secs"; continue
  fi
  IFS='|' read -r state pending failed total <<<"$rollup"

  case "$state" in
    MERGED) echo "terminal repo=$repo pr=$pr state=MERGED (already merged)"; exit 0 ;;
    CLOSED) echo "terminal repo=$repo pr=$pr state=CLOSED (nothing to finalize)"; exit 2 ;;
  esac

  if [ "${pending:-0}" -eq 0 ]; then
    if [ "${failed:-0}" -gt 0 ]; then
      echo "rollup-terminal repo=$repo pr=$pr total=$total failed=$failed → CI RED"
      print_failures
      exit 3
    fi
    break   # green + terminal → fall through to the merge
  fi

  now="$(date +%s)"
  if [ $(( now - start )) -ge "$deadline_secs" ]; then
    echo "ci-wait-timeout repo=$repo pr=$pr pending=$pending total=$total after ${deadline_secs}s — STILL UNMERGED, re-enqueue"
    exit 4
  fi
  log "waiting: $repo#$pr pending=$pending/$total (elapsed $(( now - start ))s / ${deadline_secs}s)"
  sleep "$poll_secs"
  # Gentle backoff so a long wait isn't a tight poll, capped so we never miss a
  # transition by more than poll_max.
  poll_secs=$(( poll_secs + 15 )); [ "$poll_secs" -gt "$poll_max" ] && poll_secs="$poll_max"
done

# --- CI is green and terminal: carry the merge to completion IN THIS JOB -----
echo "rollup-terminal repo=$repo pr=$pr total=$total failed=0 → CI GREEN"
if [ "$do_merge" -eq 0 ]; then exit 0; fi

if ! merr="$("$GH" pr merge "$pr" -R "$repo" --merge --delete-branch 2>&1)"; then
  # Auto-merge fallback: if direct merge is momentarily blocked but the repo
  # supports queued auto-merge, queue it so GitHub completes on the now-green CI.
  log "direct --merge failed for $repo#$pr: $merr"
  if printf '%s' "$merr" | grep -qi 'auto-merge\|not mergeable\|required status'; then
    if "$GH" pr merge "$pr" -R "$repo" --auto --merge >/dev/null 2>&1; then
      state="$("$GH" pr view "$pr" -R "$repo" --json state,autoMergeRequest \
        --jq '.state + " auto=" + (.autoMergeRequest != null | tostring)' 2>/dev/null || echo '?')"
      echo "queued repo=$repo pr=$pr auto-merge ($state)"
      exit 0
    fi
  fi
  echo "merge-blocked repo=$repo pr=$pr: $merr"
  exit 1
fi

# Verify: state MUST be MERGED (or auto-merge queued) — never report a merge that
# did not happen.
verify="$("$GH" pr view "$pr" -R "$repo" --json state,autoMergeRequest \
  --jq '.state + "|" + ((.autoMergeRequest != null) | tostring)' 2>/dev/null || echo '|')"
IFS='|' read -r vstate vauto <<<"$verify"
if [ "$vstate" = MERGED ] || [ "$vauto" = true ]; then
  echo "merged repo=$repo pr=$pr state=$vstate auto=$vauto"
  exit 0
fi
echo "merge-unverified repo=$repo pr=$pr state=$vstate auto=$vauto — NOT merged"
exit 1
