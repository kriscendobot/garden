#!/bin/bash
# unblock.sh — the deterministic unblock trigger for parked `gate: blocked` plans.
#
# Usage: unblock.sh
#
# The proxy parks a blocked job as a `gate: blocked` plan carrying a `blocked_on:`
# artifact (a PR URL or a blocking job's basename — see scripts/jobs/proxy.sh
# § park_blocked_jobs). This timer-driven oneshot is the trigger that promotes such
# a plan back to todo/ when its blocker COMPLETES. It is deterministic and uses NO
# `claude -p`.
#
# The plan file's `blocked_on:` field is the SINGLE SOURCE OF TRUTH for the
# dependency edge; this watcher scans the plan dir, reads each blocked plan's
# blocker, and:
#   - blocker is a JOB basename → if that job is in jobs/tada/ (completed), promote
#     plan/<base> → todo/.
#   - blocker is a PR (URL or owner/repo#n) → read its state via the PR-state
#     handler (default: the gh/jq reader shared with mirror-closer); if the PR is
#     merged OR closed, promote plan/<base> → todo/.
#   - otherwise leave it parked.
# Promotion reuses promote-plan.sh, which strips the blocked frontmatter so the
# todo job is the clean work body a gardener claims — the edge record is cleaned up
# by construction (the plan file, the only record, ceases to exist).
#
# Part of the garden's autonomous posture: SILENT until an error; only promotions
# and the watcher's own failures surface.
#
# Pluggable for tests:
#   GARDEN_UNBLOCK_CLONE       this service's journal clone.
#   GARDEN_UNBLOCK_PR_STATE    PR-state reader; invoked "<owner/repo> <num>",
#                              prints "<state>\t<merged>" (state ∈ open|closed).
#                              Default: handlers/mirror-pr-state-gh.sh.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="unblock"
: "${GARDEN_UNBLOCK_PR_STATE:=$HERE/handlers/mirror-pr-state-gh.sh}"

require_tools git

fleet_draining && exit 0

DIR="${GARDEN_UNBLOCK_CLONE:-$GARDEN_STATE/unblock/journal}"
ensure_clone "$DIR"
sync_clone "$DIR"

# A blocker's PR is "done" (merge or plain close both unblock) when its state is
# closed. Returns 0 if the PR-state handler says closed, 1 if open, 2 if the read
# failed (so we leave the plan parked rather than guess — the silent-jq lesson).
pr_is_done() {
  local repo="$1" num="$2" out state
  if out="$("$GARDEN_UNBLOCK_PR_STATE" "$repo" "$num" 2>/dev/null)"; then
    state="$(printf '%s' "$out" | cut -f1)"
    [ "$state" = "closed" ] && return 0
    return 1
  fi
  return 2
}

promoted=0
# while-read, not `for j in $(…)`: an unquoted expansion word-splits, so a plan
# basename containing whitespace (postable — the basename guards reject only
# -*/./slash/empty) would be scanned as fragments and silently never unblocked.
while IFS= read -r j; do
  case "$j" in *.md) ;; *) continue;; esac
  f="$DIR/jobs/plan/$j"; [ -f "$f" ] || continue
  [ "$(plan_gate "$f")" = "blocked" ] || continue
  base="${j%.md}"
  artifact="$(plan_blocked_on "$f")"
  if [ -z "$artifact" ]; then
    log "blocked plan '$base' has no blocked_on artifact; leaving parked (malformed edge)"
    continue
  fi

  do_promote=no
  if pr="$(parse_pr_ref "$artifact")"; then
    # PR blocker: the PR-state handler reads merge/close state. The DEFAULT handler
    # (handlers/mirror-pr-state-gh.sh) `require_tools gh jq` and fails LOUD on a
    # missing binary or failed call — the silent-jq-outage discipline — so a
    # swallowed error never masquerades as "open" and strands a parked job. (A
    # stubbed handler in tests bypasses gh/jq, exactly like mirror-closer.)
    repo="$(printf '%s' "$pr" | cut -f1)"; num="$(printf '%s' "$pr" | cut -f2)"
    set +e; pr_is_done "$repo" "$num"; st=$?; set -e
    case "$st" in
      0) do_promote=yes ;;
      1) : ;;  # PR still open → stay parked
      2) log "could not read PR state for '$artifact' (blocker of '$base'); leaving parked" ;;
    esac
  elif is_job_basename "$artifact"; then
    # Job blocker: completed iff it is in tada/.
    [ -f "$DIR/jobs/tada/$artifact.md" ] && do_promote=yes
  else
    log "blocked plan '$base' has an unrecognized blocked_on artifact '$artifact'; leaving parked"
    continue
  fi

  if [ "$do_promote" = yes ]; then
    if "$HERE/promote-plan.sh" "$base" >/dev/null 2>&1; then
      log "unblocked '$base' (blocker '$artifact' completed); promoted plan→todo"
      promoted=$((promoted+1))
    else
      log "promotion of unblocked '$base' failed; will retry next tick"
    fi
  fi
done < <(list_jobs "$DIR" jobs/plan)

[ "$promoted" -gt 0 ] && log "promoted $promoted unblocked plan job(s) to todo"
exit 0
