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
#
# Exit 2 is a HINT the caller must CORROBORATE, never an authority to close. This
# script matches text; it cannot know what the directive asked for, so it can prove
# only that correlated text exists — never that the ask was SATISFIED. A caller that
# closes on exit 2 must first name the artifact resolving each ask (a commit, a
# reply, a board job) and, when the deliverable is a board artifact, read the board.
# endojs/endo-but-for-bots#721 is the cautionary case: a pre-correlation exit 2
# matched an unrelated commit ("Addresses @kriskowal's review on #678", two days
# OLDER than the review) and a maintainer directive sat unactioned for two weeks
# behind a report that asserted a peer had done the work.
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
#   "comments": [{"id", "in_reply_to_id", "review_id", "created_at", "body"}]
# }
# "review_id" is the enclosing review a comment was left under (GitHub's
# pull_request_review_id, "" when absent). It is what lets a REVIEW-keyed feedback
# job see a peer's reply: replies thread to the INLINE COMMENT id, never to the
# review id, so without it `in_reply_to_id == <review id>` can never match.
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

gather_evidence() {  # gather_evidence <reason_file> -> JSON evidence on stdout
  # Emits the evidence JSON object on stdout on success. On ANY tool/transport
  # failure it writes a human-readable reason — INCLUDING the failing command's
  # captured stderr — to <reason_file> and returns nonzero, so the caller can tell
  # a gather FAILURE (infrastructure) apart from a validly-gathered but empty
  # corpus (a finding). A genuinely empty corpus is NOT a failure: it returns a
  # valid document whose arrays are empty.
  local reason_file="$1"
  local errf; errf="$(mktemp)"
  local -a tmps=("$errf")
  # shellcheck disable=SC2064
  trap 'rm -f "${tmps[@]}"' RETURN
  _fail() {  # _fail <what> — record the reason (+ any captured stderr); returns 0
    { printf 'evidence gathering failed: %s\n' "$1"
      if [ -s "$errf" ]; then printf '%s\n' '--- captured stderr ---'; cat "$errf"; fi
    } >"$reason_file" 2>/dev/null || true
    return 0
  }

  if [ -n "$GARDEN_PREFLIGHT_EVIDENCE" ]; then
    if ! "$GARDEN_PREFLIGHT_EVIDENCE" "$repo" "$pr" 2>"$errf"; then
      _fail "evidence hook $GARDEN_PREFLIGHT_EVIDENCE exited nonzero"; return 1
    fi
    return 0
  fi
  require_tools gh jq

  local target kind pull head_sha commits comments
  # A feedback job may be keyed by either the enclosing review id or an inline
  # comment id. Resolve the target first: without its time and reviewed head, a
  # generic acknowledgement is deliberately unusable.
  if target="$(gh api "repos/$repo/pulls/$pr/reviews/$cid" 2>"$errf")"; then
    kind=review
  elif target="$(gh api "repos/$repo/pulls/comments/$cid" 2>>"$errf")"; then
    kind=comment
  else
    _fail "could not resolve feedback target id $cid on $repo#$pr (neither a review nor an inline comment)"; return 1
  fi
  if ! pull="$(gh api "repos/$repo/pulls/$pr" 2>"$errf")"; then
    _fail "could not fetch pull $repo#$pr"; return 1
  fi
  if ! head_sha="$(jq -er '.head.sha | strings | select(length > 0)' <<<"$pull" 2>"$errf")"; then
    _fail "pull $repo#$pr has no usable head.sha"; return 1
  fi
  if ! commits="$(gh api "repos/$repo/commits?sha=$head_sha&per_page=$GARDEN_PREFLIGHT_COMMITS" 2>"$errf")"; then
    _fail "could not fetch commits for $repo#$pr at $head_sha"; return 1
  fi
  if ! comments="$(gh api --paginate "repos/$repo/pulls/$pr/comments?per_page=100" 2>"$errf" | jq -s 'add // []' 2>>"$errf")"; then
    _fail "could not fetch review comments for $repo#$pr"; return 1
  fi

  # Feed every unbounded payload (the target, the commit list, and above all the
  # review-comment corpus) to jq through temp files via --slurpfile, NEVER as
  # --argjson argv values. A busy PR's comment payload routinely exceeds
  # MAX_ARG_STRLEN (131072 B) — the per-argument execve cap that is SEPARATE from
  # the multi-megabyte ARG_MAX total — so an argv value there fails execve E2BIG on
  # exactly the PRs that carry the most feedback. printf is a bash builtin, so
  # writing a payload to a file does not itself pass through execve. --slurpfile
  # binds each file's single top-level value as element [0] of an array.
  local tf_target tf_commits tf_comments
  tf_target="$(mktemp)"; tf_commits="$(mktemp)"; tf_comments="$(mktemp)"
  tmps+=("$tf_target" "$tf_commits" "$tf_comments")
  printf '%s' "$target"   >"$tf_target"
  printf '%s' "$commits"  >"$tf_commits"
  printf '%s' "$comments" >"$tf_comments"

  if [ "$kind" = review ]; then
    jq -cn --arg head "$head_sha" \
      --slurpfile target "$tf_target" \
      --slurpfile commits "$tf_commits" \
      --slurpfile comments "$tf_comments" '
      {
        target: {
          id: ($target[0].id | tostring),
          created_at: $target[0].submitted_at,
          reviewed_head_sha: $target[0].commit_id
        },
        head: {sha: $head},
        commits: [
          ($commits[0] // [])[] | {
            sha,
            timestamp: (.commit.committer.date // .commit.author.date),
            message: .commit.message
          }
        ],
        comments: [
          ($comments[0] // [])[] | {
            id: (.id | tostring),
            in_reply_to_id: ((.in_reply_to_id // "") | tostring),
            review_id: ((.pull_request_review_id // "") | tostring),
            created_at,
            body: (.body // "")
          }
        ]
      }' 2>"$errf" || { _fail "jq failed assembling the review evidence document"; return 1; }
  else
    jq -cn --arg head "$head_sha" \
      --slurpfile target "$tf_target" \
      --slurpfile commits "$tf_commits" \
      --slurpfile comments "$tf_comments" '
      {
        target: {
          id: ($target[0].id | tostring),
          created_at: $target[0].created_at,
          reviewed_head_sha: ($target[0].commit_id // $target[0].original_commit_id)
        },
        head: {sha: $head},
        commits: [
          ($commits[0] // [])[] | {
            sha,
            timestamp: (.commit.committer.date // .commit.author.date),
            message: .commit.message
          }
        ],
        comments: [
          ($comments[0] // [])[] | {
            id: (.id | tostring),
            in_reply_to_id: ((.in_reply_to_id // "") | tostring),
            review_id: ((.pull_request_review_id // "") | tostring),
            created_at,
            body: (.body // "")
          }
        ]
      }' 2>"$errf" || { _fail "jq failed assembling the inline-comment evidence document"; return 1; }
  fi
}

# Gather, distinguishing a FAILURE to gather (infrastructure/tool/transport) from a
# validly-gathered but empty corpus (a finding). The two are DIFFERENT facts and
# must not share a log line or a code path: a swallowed execve/network error read
# as "no evidence" is exactly the silent fail-open that misfired on PR #671.
reason_file="$(mktemp)"; trap 'rm -f "$reason_file"' EXIT
if evidence="$(gather_evidence "$reason_file")" && [ -n "$evidence" ] \
   && jq -e . >/dev/null 2>&1 <<<"$evidence"; then
  :  # a valid evidence document was gathered (its corpus may legitimately be empty)
else
  reason="$(cat "$reason_file" 2>/dev/null || true)"
  [ -n "$reason" ] || reason="evidence gathering produced empty or non-JSON output"
  # Still fail open — proceeding beats no-oping real work off an uncorrelated
  # partial corpus — but say so at a level the operator sees, and name it as an
  # infrastructure failure, NOT the finding "this PR carries no resolving
  # evidence". A STRUCTURAL failure additionally files a throttled, auditable
  # maintainer alert; a transient network blip stays WARN-only (it self-heals).
  # The full reason — including the failing command's CAPTURED stderr — goes to the
  # log unconditionally, so the cause is never swallowed even for a transient
  # failure that files no maintainer alert (the #671 failure only surfaced because
  # jq's message happened to escape a 2>/dev/null).
  log "WARN: evidence gathering FAILED for $repo#$pr (cid=$cid); proceeding (fail-open) — this is an infrastructure/tool failure, NOT an empty-evidence finding.
$reason"
  if ! is_transient_net_error "$reason"; then
    alert_maintainer "preflight-gather-fail-${repo//\//-}" \
      "pr-feedback-preflight could not gather evidence for $repo#$pr (cid=$cid) and failed open.
This is a tool/transport failure, not a no-evidence finding — real feedback may
have been processed WITHOUT the peer-resolution recheck. Reason:
$reason"
  fi
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
# A REVIEW-keyed job carries its asks in the review's inline comments, and a peer's
# reply threads to the INLINE COMMENT id — never to the review id — so the check
# above is structurally unable to see it. Recognise the review's own threads
# instead, and only when EVERY one of them has a post-review reply: the unit of
# work is the whole review, so one answered thread out of three is not a
# resolution. (endojs/endo-but-for-bots#683: a peer answered the review's single
# inline comment, yet this gate said PROCEED and a second gardener was dispatched.)
elif jq -e --arg cid "$cid" --arg target_at "$target_at" '
  (.comments // []) as $cs
  | [$cs[]? | select(.review_id == $cid) | .id] as $threads
  | ($threads | length > 0)
    and all($threads[];
      . as $t
      | any($cs[]?;
          (.in_reply_to_id == $t)
          and (.created_at | type == "string" and . >= $target_at)))
' >/dev/null <<<"$evidence"; then
  matched="a post-review reply on every inline thread of review $cid"
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
  log "NO-OP (HINT — corroborate before closing): a peer's resolution appears present on $repo#$pr: $matched; name the artifact resolving each ask before completing as a no-op (cid=$cid)"
  exit 2
fi

log "PROCEED: no correlated peer resolution found on $repo#$pr for cid=$cid${reviewer:+ (reviewer @$reviewer)}; do the work"
exit 0
