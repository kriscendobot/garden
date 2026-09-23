#!/bin/bash
# pr-mergeable-gh.sh — default "is this PR ready for the conductor to merge?" probe
# for comment-watcher.sh's APPROVAL → finalization path.
#
# Invoked as: pr-mergeable-gh.sh <owner/name> <pr-number>
#
# Exit code IS the answer (no stdout contract — the watcher reads only $?):
#   0  OPEN + MERGEABLE + checks green + effective maintainer approval
#                                            → ready; mint the conductor (un-draft+merge)
#   2  already MERGED or CLOSED          → nothing to finalize (idempotent no-op)
#   1  OPEN but not mergeable / not green → escalate to the shepherd, do NOT force
#   3  UNREADABLE (the gh read failed)    → readiness unknown; the caller decides
#                                            (never a fabricated "ready")
#
# A draft PR that is otherwise mergeable+green returns 0: the conductor un-drafts
# THEN merges, so draft status is not a blocker here (it is the conductor's job).
#
# Silent-failure discipline (the 2026-06-24 jq-outage lesson): require_tools fails
# LOUD on a missing binary, and a failed gh call returns rc 3 (unreadable, never
# masquerade as "ready") rather than being swallowed into a false green. A GraphQL
# primary-quota refusal also arms the host's GraphQL-scoped gh-api latch (common.sh)
# so sibling GraphQL readers skip their doomed calls.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"
GARDEN_TAG="pr-mergeable"

repo="${1:?usage: pr-mergeable-gh.sh <owner/name> <pr-number>}"
pr="${2:?usage: pr-mergeable-gh.sh <owner/name> <pr-number>}"

require_tools gh jq

# One read. Do NOT swallow the call's failure into emptiness: a failed lookup must
# surface as rc 3 (unreadable), never as a fabricated "ready to merge".
errf="$(mktemp)"
if ! json="$(gh pr view "$pr" -R "$repo" --json state,mergeable,statusCheckRollup 2>"$errf")"; then
  err="$(cat "$errf" 2>/dev/null || true)"; rm -f "$errf"
  if is_gh_primary_rate_limit_text "$err"; then
    start_api_cooldown "pr-mergeable:$repo" "$(api_primary_quota_secs)" graphql || true
  fi
  log "gh pr view $repo#$pr failed — readiness unreadable (rc 3, never force): ${err:-<no stderr>}"
  exit 3
fi
rm -f "$errf"
[ -n "$json" ] || { log "empty PR state for $repo#$pr — readiness unreadable"; exit 3; }

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

# This is intentionally independent of GitHub branch protection. A clean PR is
# not ready to conduct unless a journal maintainer's review is effectively APPROVED
# (still standing, not dismissed and not superseded by a later CHANGES_REQUESTED).
# The approval need not be on the current head — see pr-maintainer-approval-gh.sh.
"$HERE/pr-maintainer-approval-gh.sh" "$repo" "$pr" >/dev/null || exit 1

exit 0
