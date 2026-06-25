#!/bin/bash
# mirror-close-gh.sh — default close-with-comment handler for mirror-closer.sh.
#
# Invoked as: mirror-close-gh.sh <owner/repo> <pr-number> <comment-body-file>
# Posts the comment FIRST (so the reason is on the thread even if the close races
# or fails), then closes the PR. Bot identity via the fleet `gh` wrapper
# (scripts/jobs/bin/gh pins kriscendobot); the closer never touches the kriskowal
# override — closing a garden-side mirror is a bot action by construction.
#
# Fails LOUD on a missing tool or a failed call: a half-done close (comment posted,
# close failed) must surface, not be swallowed, so the next tick can complete it
# (re-running is safe — gh pr close on an already-closed PR is a no-op success and
# the comment is only posted on the open→closed transition by the caller).

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"
GARDEN_TAG="mirror-close"

repo="${1:?usage: mirror-close-gh.sh <owner/repo> <pr-number> <comment-file>}"
num="${2:?usage: mirror-close-gh.sh <owner/repo> <pr-number> <comment-file>}"
body="${3:?usage: mirror-close-gh.sh <owner/repo> <pr-number> <comment-file>}"
[ -f "$body" ] || die "comment body file '$body' not found"

require_tools gh

gh pr comment "$num" -R "$repo" --body-file "$body" \
  || die "gh pr comment on $repo#$num failed (mirror not closed; will retry next tick)"
gh pr close "$num" -R "$repo" \
  || die "gh pr close on $repo#$num failed (comment posted; will retry next tick)"
log "closed $repo#$num with comment"
