#!/bin/bash
# pr-mergeable-gh.sh — default "is this PR ready for the conductor to merge?" probe
# for comment-watcher.sh's APPROVAL → finalization path.
#
# Invoked as: pr-mergeable-gh.sh <owner/name> <pr-number>
#
# Exit code IS the answer (no stdout contract — the watcher reads only $?):
#   0  OPEN + MERGEABLE + checks green   → ready; mint the conductor (un-draft+merge)
#   2  already MERGED or CLOSED          → nothing to finalize (idempotent no-op)
#   1  OPEN but not mergeable / not green → escalate to the shepherd, do NOT force
#
# A draft PR that is otherwise mergeable+green returns 0: the conductor un-drafts
# THEN merges, so draft status is not a blocker here (it is the conductor's job).
#
# Silent-failure discipline (the 2026-06-24 jq-outage lesson): require_tools fails
# LOUD on a missing binary, and a failed gh call returns rc 1 (escalate, never
# masquerade as "ready") rather than being swallowed into a false green.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"
GARDEN_TAG="pr-mergeable"

repo="${1:?usage: pr-mergeable-gh.sh <owner/name> <pr-number>}"
pr="${2:?usage: pr-mergeable-gh.sh <owner/name> <pr-number>}"

require_tools gh jq

# One read. Do NOT 2>/dev/null the call's failure into emptiness: a failed lookup
# must surface as rc 1 (escalate), never as a fabricated "ready to merge".
json="$(gh pr view "$pr" -R "$repo" --json state,mergeable,statusCheckRollup 2>/dev/null)" \
  || { log "gh pr view $repo#$pr failed — treating as not-ready (escalate, never force)"; exit 1; }
[ -n "$json" ] || { log "empty PR state for $repo#$pr — not-ready"; exit 1; }

state="$(printf '%s' "$json" | jq -r '.state // ""')"
case "$state" in
  MERGED|CLOSED) exit 2 ;;       # already finalized / abandoned → nothing to do
  OPEN) : ;;
  *) exit 1 ;;                   # unknown state → escalate, don't force
esac

mergeable="$(printf '%s' "$json" | jq -r '.mergeable // ""')"
[ "$mergeable" = MERGEABLE ] || exit 1   # CONFLICTING / UNKNOWN → not ready

# Checks green: no failed/cancelled/timed-out/action-required check, and nothing
# still queued or in progress. statusCheckRollup mixes CheckRun (.status/.conclusion)
# and StatusContext (.state) shapes; coalesce both.
bad="$(printf '%s' "$json" | jq -r '
  [ .statusCheckRollup[]?
    | ((.conclusion // .state // "") | ascii_upcase) as $c
    | select($c=="FAILURE" or $c=="ERROR" or $c=="CANCELLED"
             or $c=="TIMED_OUT" or $c=="ACTION_REQUIRED" or $c=="STARTUP_FAILURE") ]
  | length')"
[ "${bad:-0}" = 0 ] || exit 1

pending="$(printf '%s' "$json" | jq -r '
  [ .statusCheckRollup[]?
    | ((.status // .state // "") | ascii_upcase) as $s
    | select($s=="QUEUED" or $s=="IN_PROGRESS" or $s=="PENDING" or $s=="WAITING"
             or $s=="EXPECTED") ]
  | length')"
[ "${pending:-0}" = 0 ] || exit 1

exit 0
