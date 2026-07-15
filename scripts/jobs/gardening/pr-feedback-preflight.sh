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
#   exit 2 = NO-OP    — a peer's resolution citing THIS feedback is already on the
#                       PR. Stop without touching the branch.
# Any OTHER exit (a gh/network failure, an indeterminate fetch) is FAIL-OPEN —
# treated by the caller as PROCEED — so a transient never silently skips real work;
# at worst the push-time CAS catches the duplicate the way it did before this gate.
#
# A generic "Addressed @reviewer" is intentionally weaker than a direct reply or an
# id citation. It only counts when a post-feedback commit advances the reviewed head
# and names that exact reviewed SHA. An old or unrelated acknowledgement, including
# one in a PR comment, cannot resolve a newer review. This conservatism can permit
# duplicate work, but never silently discards feedback; the push CAS remains the
# backstop.
#
# The evidence hook emits one JSON object on stdout:
# {
#   "target": {"id", "created_at", "reviewed_head_sha"},
#   "head": {"sha"},
#   "commits": [{"sha", "timestamp", "message"}],
#   "comments": [{"id", "in_reply_to_id", "created_at", "body"}]
# }
# GARDEN_PREFLIGHT_EVIDENCE <repo> <pr> -> this object. The test substitutes
# fixtures; match logic remains here rather than in the hook.

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
# commit is normally at the newest tip, so a small window is plenty; overridable
# for a deterministic test.
: "${GARDEN_PREFLIGHT_COMMITS:=20}"
: "${GARDEN_PREFLIGHT_EVIDENCE:=}"

gather_evidence() {  # gather_evidence -> JSON evidence on stdout
  if [ -n "$GARDEN_PREFLIGHT_EVIDENCE" ]; then
    "$GARDEN_PREFLIGHT_EVIDENCE" "$repo" "$pr"
    return
  fi
  require_tools gh jq

  local target kind pull head_sha commits comments
  # A feedback job may be keyed by either the enclosing review id or an inline
  # comment id. Resolve the target first: without its time and reviewed head, a
  # generic acknowledgement is deliberately unusable.
  if target="$(gh api "repos/$repo/pulls/$pr/reviews/$cid" 2>/dev/null)"; then
    kind=review
  elif target="$(gh api "repos/$repo/pulls/comments/$cid" 2>/dev/null)"; then
    kind=comment
  else
    return 1
  fi
  pull="$(gh api "repos/$repo/pulls/$pr" 2>/dev/null)" || return 1
  head_sha="$(jq -er '.head.sha | strings | select(length > 0)' <<<"$pull")" || return 1
  commits="$(gh api "repos/$repo/commits?sha=$head_sha&per_page=$GARDEN_PREFLIGHT_COMMITS" 2>/dev/null)" || return 1
  comments="$(gh api --paginate "repos/$repo/pulls/$pr/comments?per_page=100" 2>/dev/null | jq -s 'add // []')" || return 1

  if [ "$kind" = review ]; then
    jq -cn --argjson target "$target" --arg head "$head_sha" \
      --argjson commits "$commits" --argjson comments "$comments" '
      {
        target: {
          id: ($target.id | tostring),
          created_at: $target.submitted_at,
          reviewed_head_sha: $target.commit_id
        },
        head: {sha: $head},
        commits: [
          $commits[] | {
            sha,
            timestamp: (.commit.committer.date // .commit.author.date),
            message: .commit.message
          }
        ],
        comments: [
          $comments[] | {
            id: (.id | tostring),
            in_reply_to_id: ((.in_reply_to_id // "") | tostring),
            created_at,
            body: (.body // "")
          }
        ]
      }'
  else
    jq -cn --argjson target "$target" --arg head "$head_sha" \
      --argjson commits "$commits" --argjson comments "$comments" '
      {
        target: {
          id: ($target.id | tostring),
          created_at: $target.created_at,
          reviewed_head_sha: ($target.commit_id // $target.original_commit_id)
        },
        head: {sha: $head},
        commits: [
          $commits[] | {
            sha,
            timestamp: (.commit.committer.date // .commit.author.date),
            message: .commit.message
          }
        ],
        comments: [
          $comments[] | {
            id: (.id | tostring),
            in_reply_to_id: ((.in_reply_to_id // "") | tostring),
            created_at,
            body: (.body // "")
          }
        ]
      }'
  fi
}

evidence="$(gather_evidence || true)"
if [ -z "$evidence" ] || ! jq -e . >/dev/null 2>&1 <<<"$evidence"; then
  log "no usable evidence for $repo#$pr (cid=$cid); proceeding (fail-open)"
  exit 0
fi

# Target metadata is required even for the strong signals. That makes an incomplete
# live fetch fail open rather than making a no-op decision from an uncorrelated
# partial corpus. ISO-8601 UTC values sort lexically, which keeps comparisons in
# plain deterministic jq.
if ! jq -e --arg cid "$cid" '
  (.target.id == $cid)
  and (.target.created_at | type == "string" and test("^[0-9]{4}-[0-9]{2}-[0-9]{2}T"))
  and (.target.reviewed_head_sha | type == "string" and length > 0)
  and (.head.sha | type == "string" and length > 0)
  and (.commits | type == "array")
  and (.comments | type == "array")
' >/dev/null <<<"$evidence"; then
  log "incomplete correlation evidence for $repo#$pr (cid=$cid); proceeding (fail-open)"
  exit 0
fi

target_at="$(jq -r '.target.created_at' <<<"$evidence")"
reviewed_head="$(jq -r '.target.reviewed_head_sha' <<<"$evidence")"
current_head="$(jq -r '.head.sha' <<<"$evidence")"
matched=""

# Strong, correlation-specific evidence. A direct same-thread reply or an exact id
# citation is sufficient, but it still must post after the triggering feedback.
if jq -e --arg cid "$cid" --arg target_at "$target_at" '
  any(.comments[]?;
    (.in_reply_to_id == $cid)
    and (.created_at | type == "string" and . >= $target_at))
' >/dev/null <<<"$evidence"; then
  matched="reply on the same inline thread after the feedback (in_reply_to=$cid)"
else
  cited="$({
    jq -r --arg target_at "$target_at" '
      (.commits[]? | select(.timestamp | type == "string" and . >= $target_at) | .message),
      (.comments[]? | select(.created_at | type == "string" and . >= $target_at) | .body)
    ' <<<"$evidence"
  } || true)"
  if printf '%s\n' "$cited" | grep -qE "(^|[^0-9])${cid}([^0-9]|\$)"; then
    matched="a post-feedback commit/reply citing feedback id $cid"
  # A generic acknowledgement is only evidence when a post-feedback commit both
  # advances and explicitly names the exact head the feedback reviewed. Do not
  # inspect PR comment acknowledgements here: they have no durable reviewed-head
  # correlation. The SHA requirement is deliberately strict: otherwise a later
  # "Addressed @reviewer" for a different request could swallow this feedback.
  elif [ -n "$reviewer" ] && [ "$current_head" != "$reviewed_head" ] \
       && jq -r --arg target_at "$target_at" --arg reviewed_head "$reviewed_head" '
            .commits[]?
            | select(.timestamp | type == "string" and . >= $target_at)
            | select(.message | type == "string" and contains($reviewed_head))
            | .message
          ' <<<"$evidence" \
          | grep -qiE "(addressed[[:space:]]+@${reviewer}([^a-z0-9]|\$)|@${reviewer}'?s[[:space:]]+review)"; then
    matched="a post-feedback commit acknowledging @$reviewer after advancing reviewed head $reviewed_head"
  fi
fi

if [ -n "$matched" ]; then
  log "NO-OP: a peer's resolution is already present on $repo#$pr: $matched; skipping the edit (cid=$cid)"
  exit 2
fi

log "PROCEED: no correlated peer resolution found on $repo#$pr for cid=$cid${reviewer:+ (reviewer @$reviewer)}; do the work"
exit 0
