#!/bin/bash
# ci-wait-merge.sh — block until a PR's CI reaches a terminal state, then CARRY
# THE MERGE TO COMPLETION in the same invocation. This is the deterministic spine
# of the conductor's "waiting for CI" step: a merge dispatch that finds CI pending
# must NOT end the job while waiting — it blocks here until CI settles and then
# merges on green (or reports on red), so a green-but-unmerged PR can never be left
# behind by a job that "completed while waiting" (the endo-but-for-bots #178 bug,
# which bit the same PR twice).
#
# Invoked as: ci-wait-merge.sh <owner/name> <pr-number>
#               [--merge|--no-merge|--dependabot-auto-merge]
#
# Behaviour:
#   * Polls the statusCheckRollup (the source of truth — check_run/check_suite
#     events do NOT appear on the events feed; see skills/pr-ci-watch) on a real
#     timeout/backoff cadence until every check has SETTLED (no QUEUED/IN_PROGRESS/
#     PENDING/WAITING left), or the overall deadline passes.
#   * On GREEN terminal (no failures) and --merge (default): first UNFREEZE the
#     base if it is a frozen snapshot (conductor step 2 — see below), then require
#     a current maintainer approval independently of branch protection, else
#     `"$GH" pr merge --merge --delete-branch`, then VERIFY state=MERGED. The one
#     narrow exception is the explicit `--dependabot-auto-merge` mode: it skips
#     only the approval requirement, and only after a live author read proves
#     `dependabot[bot]` and the repository is in the bot-owned merge scope. An
#     unreadable or different author, or a repository outside that scope, keeps
#     the ordinary approval gate. Issuing the merge in the same invocation as the
#     wait is the whole point — never "wait, exit, hope a later tick merges".
#   * STACKED-PR BRANCH RETENTION: `--delete-branch` is DROPPED when another
#     open PR uses this PR's head branch as its BASE. Deleting the ref through
#     the API makes GitHub AUTO-CLOSE such downstream PRs (base_ref_deleted)
#     instead of retargeting them — endo-but-for-bots #800 was closed six
#     seconds after the maintainer APPROVED it, when the #799 conductor's
#     merge deleted the branch #800 was based on. The guard fails RETAIN:
#     the branch is also kept when the downstream enumeration itself fails
#     (an unreadable answer is not license to perform the destructive act).
#   * UNFREEZE-TO-LIVE (conductor step 2): a fork-side PR opened under the
#     frozen-base-branch convention targets a snapshot named `<branch>-<sha>`
#     (e.g. `llm-65b0abe`) so a stacked PR's base does not move under it. Merging
#     onto the snapshot strands the content there — it never reaches the live
#     trunk (`llm`/`main`/`master`); endo-but-for-bots #510 merged onto
#     `llm-65b0abe` (186 commits behind live `llm`) and its content never landed.
#     Before merging, if the base matches the frozen pattern this spine re-points
#     the PR at the live trunk (`gh pr edit --base <branch>`) so the merge lands on
#     the trunk. SHARED-STACK SAFETY: if OTHER open PRs sit on the same frozen base
#     (a stack, e.g. #510/#521), re-pointing one alone would fork it off the shared
#     base — so the spine does NOT touch it; it alerts the maintainer with the
#     specific stack and stalls (exit 1) rather than silently stranding OR
#     force-forking. See roles/conductor/AGENT.md § Loop step 2 and
#     skills/frozen-base-branch § Unfreeze before merge.
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
#   1  hard error / merge blocked / not mergeable / frozen base shared by a
#      sibling stack / reviewDecision=CHANGES_REQUESTED (maintainer
#      alerted)                                      → stall, re-enqueue
#
# --no-merge makes it a pure block-until-CI-terminal probe (exit 0 = green,
# 3 = red, 4 = timeout) for callers that drive the merge themselves.
# --dependabot-auto-merge is the botanist MERGE-NOW opt-in. It still enforces CI,
# CHANGES_REQUESTED, unfreeze/shared-stack, branch-retention, and post-merge
# verification; only the current-maintainer APPROVED signature is omitted after
# both the author and bot-owned-repository checks succeed.
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

repo="${1:?usage: ci-wait-merge.sh <owner/name> <pr-number> [--merge|--no-merge|--dependabot-auto-merge]}"
pr="${2:?usage: ci-wait-merge.sh <owner/name> <pr-number> [--merge|--no-merge|--dependabot-auto-merge]}"
do_merge=1
dependabot_auto_merge=0
case "${3:-}" in
  --no-merge) do_merge=0 ;;
  --merge|"") do_merge=1 ;;
  --dependabot-auto-merge) do_merge=1; dependabot_auto_merge=1 ;;
  *) die "unknown flag: ${3:-} (expected --merge, --no-merge, or --dependabot-auto-merge)" ;;
esac

# Resolve the gh binary DURABLY for the whole (potentially 90-minute) CI-wait.
# Default: the PATH-resolved `gh`, which common.sh pins to the fleet wrapper
# (scripts/jobs/bin/gh) at the FRONT of PATH — a stable path on disk for the
# fleet's lifetime that also pins the bot identity. GARDEN_GH overrides it (tests
# inject a stub), but ONLY when it still resolves to a runnable command at the
# moment we check.
#
# The endo-but-for-bots #178 root cause: GARDEN_GH was honored blindly even when
# it pointed at a `mktemp -d` wrapper that had ALREADY been cleaned up by the time
# require_tools ran — so the missing-tool guard fired and the merge was silently
# DROPPED (twice on the same PR; the liaison merged it by hand). A stale temp
# override must never be fatal: if GARDEN_GH does not resolve, fall back to the
# durable PATH `gh` LOUDLY and carry the merge to completion anyway.
GH="gh"
if [ -n "${GARDEN_GH:-}" ]; then
  if [ -x "$GARDEN_GH" ] || command -v "$GARDEN_GH" >/dev/null 2>&1; then
    GH="$GARDEN_GH"
  else
    log "GARDEN_GH=$GARDEN_GH does not resolve (stale temp path?) — falling back to the durable PATH gh (fleet wrapper) so the merge is never dropped"
  fi
fi
require_tools jq
require_tools "$GH"

: "${GARDEN_DEPENDABOT_LOGIN:=dependabot[bot]}"

# This is the same deny-by-default autonomous repository boundary used by the CI
# watcher and approval reconciler. The garden's own repository is denied before
# the bot-owner arm because garden development pushes directly to main2.
is_bot_owned_merge_repo() {  # is_bot_owned_merge_repo <owner/name>
  local candidate="$1" production_repo
  for production_repo in "$GARDEN_PRODUCTION_JOURNAL_REPO" $GARDEN_PRODUCTION_JOURNAL_REPO_ALIASES; do
    [ "$candidate" = "$production_repo" ] && return 1
  done
  case "$candidate" in
    agoric/agoric-sdk|endojs/endo) return 1 ;;
    endojs/endo-but-for-bots)      return 0 ;;
    "$GARDEN_BOT_LOGIN"/*)         return 0 ;;
    *)                             return 1 ;;
  esac
}

# Resolve the explicit dependabot opt-in before unfreezing so a mis-scoped call
# cannot mutate a human PR's base. Failure does not abort an otherwise ordinary
# conductor merge: it leaves the maintainer-approval gate in force.
dependabot_approval_bypass=0
if [ "$dependabot_auto_merge" -eq 1 ]; then
  if ! is_bot_owned_merge_repo "$repo"; then
    log "dependabot auto-merge bypass denied: $repo is outside the bot-owned merge scope; keeping maintainer approval"
  elif author_meta="$("$GH" pr view "$pr" -R "$repo" --json author 2>/dev/null)" \
       && printf '%s' "$author_meta" | jq -e . >/dev/null 2>&1; then
    author_login="$(printf '%s' "$author_meta" | jq -r '.author.login // ""')"
    if [ -n "$author_login" ] \
       && [ "$(printf '%s' "$author_login" | tr '[:upper:]' '[:lower:]')" = "$(printf '%s' "$GARDEN_DEPENDABOT_LOGIN" | tr '[:upper:]' '[:lower:]')" ]; then
      dependabot_approval_bypass=1
    else
      log "dependabot auto-merge bypass denied: live author for $repo#$pr is ${author_login:-unreadable}, not $GARDEN_DEPENDABOT_LOGIN; keeping maintainer approval"
    fi
  else
    log "dependabot auto-merge bypass denied: live author for $repo#$pr is unreadable; keeping maintainer approval"
  fi
fi

deadline_secs="${GARDEN_CI_DEADLINE_SECS:-5400}"
poll_secs="${GARDEN_CI_POLL_SECS:-60}"
poll_max="${GARDEN_CI_POLL_MAX_SECS:-60}"
start="$(date +%s)"

# One rollup read. Echoes "<state>|<pending>|<failed>|<total>|<reviewDecision>"
# on stdout, or returns non-zero (never a fabricated green) when the read itself
# fails. reviewDecision is GitHub's review rollup (CHANGES_REQUESTED / APPROVED /
# REVIEW_REQUIRED / ""); the green-and-terminal block below refuses to merge over
# a CHANGES_REQUESTED so a maintainer review landing mid-wait is never merged over.
read_rollup() {
  local json state pending failed total review
  json="$("$GH" pr view "$pr" -R "$repo" --json state,mergeable,statusCheckRollup,reviewDecision 2>/dev/null)" \
    || { log "gh pr view $repo#$pr failed — aborting this tick (never fabricate green)"; return 1; }
  [ -n "$json" ] || { log "empty PR state for $repo#$pr"; return 1; }
  # Validate the payload IS json before extracting: a jq parse failure on
  # non-JSON stdout leaves state/pending/failed empty, and the ${pending:-0}
  # defaults below would convert that into a fabricated green (this function's
  # own contract forbids exactly that).
  printf '%s' "$json" | jq -e . >/dev/null 2>&1 \
    || { log "unparseable PR state for $repo#$pr (not JSON); aborting this tick (never fabricate green)"; return 1; }
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
  review="$(printf '%s' "$json" | jq -r '.reviewDecision // ""')"
  printf '%s|%s|%s|%s|%s\n' "$state" "${pending:-0}" "${failed:-0}" "${total:-0}" "$review"
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

# --- conductor step 2: unfreeze a frozen-base snapshot to the live trunk ------
# A fork-side PR opened under the frozen-base-branch convention targets a snapshot
# named `<branch>-<sha>`. Merging onto the snapshot strands the content there; the
# live trunk never absorbs it (the #510 → llm-65b0abe bug). Before merging,
# re-point the PR at the live trunk so the merge lands on the trunk — UNLESS other
# open PRs share the same frozen base (a stack), in which case re-pointing this one
# alone would fork the stack off the shared base; then alert the maintainer with
# the specific stack and refuse to merge (neither strand nor force-fork).
#
# Returns:
#   0  base is already live, or it was successfully unfrozen → proceed to merge
#   10 frozen base shared by a sibling stack → maintainer alerted; do NOT merge
unfreeze_base_if_frozen() {
  local meta state base live count nums
  meta="$("$GH" pr view "$pr" -R "$repo" --json state,baseRefName 2>/dev/null)" \
    || { log "gh pr view (baseRefName) $repo#$pr failed — skipping unfreeze check"; return 0; }
  [ -n "$meta" ] || return 0
  state="$(printf '%s' "$meta" | jq -r '.state // ""')"
  base="$(printf '%s' "$meta" | jq -r '.baseRefName // ""')"
  # Only an OPEN PR can be unfrozen; the wait loop handles terminal states.
  [ "$state" = OPEN ] || return 0
  # Frozen-base pattern: <live-branch>-<4..40 hex>. A live trunk (no -<sha>) skips.
  [[ "$base" =~ ^(llm|main|master)-[0-9a-f]{4,40}$ ]] || return 0
  live="${base%-*}"   # llm-65b0abe → llm; master-c49fb04 → master
  # Shared-stack safety: count OPEN PRs sitting on this frozen base (incl. self).
  count="$("$GH" pr list -R "$repo" --search "base:$base is:open" --json number --jq 'length' 2>/dev/null || echo 1)"
  case "$count" in ''|*[!0-9]*) count=1 ;; esac
  if [ "$count" -gt 1 ]; then
    nums="$("$GH" pr list -R "$repo" --search "base:$base is:open" --json number --jq '[.[].number]|join(", #")' 2>/dev/null || echo '?')"
    alert_maintainer "shared-frozen-base-${repo//\//_}-$base" \
      "conductor unfreeze BLOCKED for $repo#$pr: frozen base '$base' is shared by open PRs (#$nums). Forwarding #$pr to live '$live' alone would fork the stack off the shared base. Weave the stack forward together, or merge them in dependency order — do not let me do it unilaterally. (#$pr left on the snapshot: not stranded silently, not force-forked.)"
    echo "unfreeze-blocked repo=$repo pr=$pr base=$base shared-with=#$nums → alerted maintainer, NOT merging"
    return 10
  fi
  if "$GH" pr edit "$pr" -R "$repo" --base "$live" >/dev/null 2>&1; then
    echo "unfroze repo=$repo pr=$pr base=$base → $live (live trunk) before merge"
    return 0
  fi
  log "gh pr edit --base $live failed for $repo#$pr — proceeding; the merge will block if the base is wrong rather than strand"
  return 0
}

# --- conductor step 2: unfreeze before the wait/merge -----------------------
# Re-point a frozen-base PR at the live trunk now, so any base-change-triggered CI
# is awaited by the loop below and the eventual merge lands on the trunk. Skipped
# for --no-merge probes (they do not merge, so they must not mutate the PR's base).
if [ "$do_merge" -eq 1 ]; then
  unfreeze_base_if_frozen || { rc=$?; [ "$rc" -eq 10 ] && exit 1; }
fi

# --- block until CI is terminal (or the deadline passes) --------------------
while :; do
  if ! rollup="$(read_rollup)"; then
    if past_deadline; then
      echo "ci-wait-timeout repo=$repo pr=$pr (gh read kept failing) after ${deadline_secs}s — STILL UNMERGED, re-enqueue"
      exit 4
    fi
    sleep "$poll_secs"; continue
  fi
  IFS='|' read -r state pending failed total review <<<"$rollup"

  case "$state" in
    MERGED) echo "terminal repo=$repo pr=$pr state=MERGED (already merged)"; exit 0 ;;
    CLOSED) echo "terminal repo=$repo pr=$pr state=CLOSED (nothing to finalize)"; exit 2 ;;
  esac

  # An EMPTY rollup is NOT green: in the window right after a push (before any
  # check attaches) statusCheckRollup is [] for up to ~a minute, and pending=0 ∧
  # failed=0 used to break straight to the merge — merging a PR whose CI never
  # started. Treat total=0 like pending: keep polling; the deadline's exit 4
  # (re-enqueue) covers a repo that never attaches checks. A genuinely
  # checkless repo opts in via GARDEN_CI_ALLOW_NO_CHECKS=1.
  if [ "${total:-0}" -eq 0 ] && [ "${GARDEN_CI_ALLOW_NO_CHECKS:-0}" != 1 ]; then
    now="$(date +%s)"
    if [ $(( now - start )) -ge "$deadline_secs" ]; then
      echo "ci-wait-timeout repo=$repo pr=$pr rollup stayed EMPTY after ${deadline_secs}s — STILL UNMERGED, re-enqueue (set GARDEN_CI_ALLOW_NO_CHECKS=1 for a checkless repo)"
      exit 4
    fi
    log "waiting: $repo#$pr rollup empty (checks not attached yet; elapsed $(( now - start ))s / ${deadline_secs}s)"
    sleep "$poll_secs"; continue
  fi

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

# --- deterministic review gate: never merge over a CHANGES_REQUESTED review ---
# reviewDecision is GitHub's review rollup. On a repo WITHOUT branch protection
# requiring approval (a checkless / own-fork repo), GitHub still reports the PR
# `mergeable`, so a maintainer's CHANGES_REQUESTED review landing during the CI
# wait would otherwise be merged straight over — kriscendobot/minion.town#7: a
# CHANGES_REQUESTED landed ~2.5 min before the merge and the branch was merged
# and closed with two inline directives unaddressed. Refuse HERE, in the
# deterministic spine, rather than relying on the conductor agent to notice a
# review that arrived mid-wait; that closes the race for every checkless/own-fork
# repo. Key off reviewDecision (not the presence of some stale review): it clears
# to APPROVED / REVIEW_REQUIRED once the CHANGES_REQUESTED review is dismissed or
# superseded, so a later re-enqueued tick merges cleanly once the feedback is
# resolved. Exit 1 (stall) leaves the merge job claimable, not completed-merged.
# Read it again at the final merge point. The CI rollup read may be seconds old,
# and the dependabot path no longer calls the approval helper that used to supply
# a second reviewDecision read. An unreadable final decision fails closed because
# it is not evidence that the veto is absent.
final_review_meta="$("$GH" pr view "$pr" -R "$repo" --json reviewDecision 2>/dev/null)" \
  || { echo "review-blocked repo=$repo pr=$pr reviewDecision=UNREADABLE → NOT merging"; exit 1; }
printf '%s' "$final_review_meta" | jq -e . >/dev/null 2>&1 \
  || { echo "review-blocked repo=$repo pr=$pr reviewDecision=UNREADABLE → NOT merging"; exit 1; }
review="$(printf '%s' "$final_review_meta" | jq -r '.reviewDecision // ""')"
if [ "$review" = CHANGES_REQUESTED ]; then
  alert_maintainer "changes-requested-${repo//\//_}-$pr" \
    "conductor merge BLOCKED for $repo#$pr: reviewDecision=CHANGES_REQUESTED. A reviewer requested changes; I will NOT merge over it even though GitHub reports the PR mergeable (no branch protection requiring approval). Address the review feedback (or dismiss/supersede the review) and the next tick merges cleanly. (#$pr left claimable: not merged, not stranded.)"
  echo "review-blocked repo=$repo pr=$pr reviewDecision=CHANGES_REQUESTED → alerted maintainer, NOT merging"
  exit 1
fi

# `reviewDecision=APPROVED` alone is not enough on a repository without branch
# protection. Ordinary conductor calls require a current APPROVED review by a
# journal maintainer here, at the final merge point. The explicit botanist path
# omits only that signature after the live dependabot-author and bot-owned-repo
# checks above. CHANGES_REQUESTED remains the independent absolute veto above.
if [ "$dependabot_approval_bypass" -eq 1 ]; then
  echo "approval-bypass repo=$repo pr=$pr author=$GARDEN_DEPENDABOT_LOGIN mode=dependabot-auto-merge"
elif ! "$HERE/../handlers/pr-maintainer-approval-gh.sh" "$repo" "$pr"; then
  echo "merge blocked: no maintainer approval repo=$repo pr=$pr"
  exit 1
fi

# --- stacked-PR branch-retention guard: never delete a head branch that is ---
# the BASE of another open PR (see the header note; the #800 auto-close).
delete_flag="--delete-branch"
head_ref="$("$GH" pr view "$pr" -R "$repo" --json headRefName --jq '.headRefName // ""' 2>/dev/null || echo "")"
if [ -z "$head_ref" ]; then
  log "could not read head branch for $repo#$pr — retaining the branch after merge (fail-retain)"
  delete_flag=""
elif downstream="$("$GH" pr list -R "$repo" --base "$head_ref" --state open --json number --jq '[.[].number|tostring]|join(", #")' 2>/dev/null)"; then
  if [ -n "$downstream" ]; then
    echo "retain-branch repo=$repo pr=$pr head=$head_ref: open PR(s) #$downstream use it as base — merging WITHOUT --delete-branch"
    delete_flag=""
  fi
else
  log "could not enumerate open PRs based on $head_ref — retaining the branch after merge (fail-retain)"
  delete_flag=""
fi

if ! merr="$("$GH" pr merge "$pr" -R "$repo" --merge ${delete_flag:+"$delete_flag"} 2>&1)"; then
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
