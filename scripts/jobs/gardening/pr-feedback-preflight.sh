#!/bin/bash
# pr-feedback-preflight.sh — deterministic "is this PR-feedback already resolved?"
# gate a PR-feedback consumer runs BEFORE making any edit.
#
# Usage: pr-feedback-preflight.sh <repo> <pr> <comment-id> [<reviewer-login>]
#   <repo>           owner/name (e.g. endojs/endo-but-for-bots)
#   <pr>             the pull-request number
#   <comment-id>     the triggering review/inline comment id (or review id) this
#                    feedback job was minted from
#   <reviewer-login> (optional) the reviewer/author whose feedback this is
#
# Exit code is the no-op signal:
#   exit 0 = PROCEED  — no peer resolution found; do the work.
#   exit 2 = NO-OP    — a peer's resolution citing THIS comment is already on the
#                       PR (a reply on the same thread, a commit/reply that cites
#                       the comment id, or an "Addressed @<reviewer>" / "@<reviewer>'s
#                       review" note). The edit was already made by a racing peer;
#                       stop without touching the branch.
# Any OTHER exit (a gh/network failure, an indeterminate fetch) is FAIL-OPEN —
# treated by the caller as PROCEED — so a transient never silently skips real work;
# at worst the push-time CAS catches the duplicate the way it did before this gate.
#
# Why this exists: the responsibility to "re-check the live thread before pushing
# queued feedback work" used to live only as an agent self-improvement note
# (feedback_recheck_thread_before_pushing_queued_infra, generalized to the read
# side). A note an agent must REMEMBER is unreliable under a racing fleet — two
# gardeners claim two jobs minted from the same review and both edit + push, the
# loser discovering the duplicate only at the push CAS (or not at all, having
# already opened a redundant PR comment; the #548 duplicate-fold). This moves that
# re-check into plain code that runs EVERY time, BEFORE the edit, so a peer's
# already-landed resolution is detected up front and the job no-ops cleanly.
#
# The evidence corpus — recent commit messages on the PR branch HEAD plus the PR's
# inline review-comment replies — is gathered through an overridable hook so a test
# can stand in a deterministic fixture; the MATCH LOGIC (the unit under test) lives
# HERE rather than in the hook:
#   GARDEN_PREFLIGHT_EVIDENCE <repo> <pr>  -> the text corpus on stdout
# The default hook uses gh against the live PR.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"
GARDEN_TAG="pr-feedback-preflight"

repo="${1:?usage: pr-feedback-preflight.sh <repo> <pr> <comment-id> [<reviewer-login>]}"
pr="${2:?usage: pr-feedback-preflight.sh <repo> <pr> <comment-id> [<reviewer-login>]}"
cid="${3:?usage: pr-feedback-preflight.sh <repo> <pr> <comment-id> [<reviewer-login>]}"
reviewer="${4:-}"

# How many recent commits on the PR branch HEAD to inspect. A peer's resolution
# commit is the newest tip, so a small window is plenty; overridable for the test.
: "${GARDEN_PREFLIGHT_COMMITS:=20}"
# Overridable evidence hook (the default uses gh; the test substitutes a fixture).
: "${GARDEN_PREFLIGHT_EVIDENCE:=}"

# --- gather the evidence corpus ---------------------------------------------
# Emits, on stdout, the text a peer's resolution would appear in:
#   * recent commit messages on the PR branch HEAD (a follow-up commit that cites
#     the comment id or says "Addressed @<reviewer>"), and
#   * every inline review-comment body, each PREFIXED with `in_reply_to=<id>` so a
#     reply posted on the SAME thread as the triggering comment is greppable as
#     `in_reply_to=<cid>` (the strongest "a peer already answered this" signal).
# The default uses gh; on ANY gh failure it prints nothing and returns non-zero so
# the caller fails OPEN (PROCEED) rather than no-oping on a transient.
gather_evidence() {  # gather_evidence -> corpus on stdout
  if [ -n "$GARDEN_PREFLIGHT_EVIDENCE" ]; then
    "$GARDEN_PREFLIGHT_EVIDENCE" "$repo" "$pr"
    return
  fi
  require_tools gh jq
  local head_sha
  head_sha="$(gh api "repos/$repo/pulls/$pr" --jq '.head.sha' 2>/dev/null || true)"
  [ -n "$head_sha" ] && [ "$head_sha" != null ] || return 1
  # Recent commit messages on the PR branch HEAD.
  gh api "repos/$repo/commits?sha=$head_sha&per_page=$GARDEN_PREFLIGHT_COMMITS" \
    --jq '.[].commit.message' 2>/dev/null || return 1
  # Inline review-comment replies, each carrying its in_reply_to_id so a same-thread
  # reply is greppable. Single-line each body so the corpus stays line-oriented.
  gh api --paginate "repos/$repo/pulls/$pr/comments" \
    --jq '.[] | "in_reply_to=\(.in_reply_to_id // "none") \(.body | gsub("[\r\n]+";" "))"' 2>/dev/null \
    || return 1
}

corpus="$(gather_evidence || true)"
if [ -z "$corpus" ]; then
  # No evidence (empty PR, or a fetch failure) — fail OPEN: there is nothing to
  # prove a peer already resolved this, so PROCEED. The push CAS remains the backstop.
  log "no evidence corpus for $repo#$pr (cid=$cid); proceeding (fail-open)"
  exit 0
fi

# --- the resolution signals (deterministic; the unit under test) -------------
# A peer's resolution citing THIS comment is present when the corpus contains ANY:
#   1. in_reply_to=<cid>            — a peer replied on the SAME inline thread, or
#   2. the comment id <cid> as a word — a commit/reply cites the comment (id or URL), or
#   3. Addressed @<reviewer> / @<reviewer>'s review — the conventional follow-up
#      acknowledgment (only when a reviewer login was supplied).
# Numeric matches use word boundaries so a 10-digit GitHub id can never collide as a
# substring of a larger number. The grep is case-insensitive for the prose patterns.
matched=""
if printf '%s\n' "$corpus" | grep -qE "in_reply_to=${cid}([^0-9]|\$)"; then
  matched="reply on the same inline thread (in_reply_to=$cid)"
elif printf '%s\n' "$corpus" | grep -qE "(^|[^0-9])${cid}([^0-9]|\$)"; then
  matched="a commit/reply citing comment id $cid"
elif [ -n "$reviewer" ] && printf '%s\n' "$corpus" \
       | grep -qiE "(addressed[[:space:]]+@${reviewer}([^a-z0-9]|\$)|@${reviewer}'?s[[:space:]]+review)"; then
  matched="an 'Addressed @${reviewer}' / @${reviewer}'s review acknowledgment"
fi

if [ -n "$matched" ]; then
  log "NO-OP: a peer's resolution is already present on $repo#$pr — $matched; skipping the edit (cid=$cid)"
  exit 2
fi

log "PROCEED: no peer resolution found on $repo#$pr for cid=$cid${reviewer:+ (reviewer @$reviewer)}; do the work"
exit 0
