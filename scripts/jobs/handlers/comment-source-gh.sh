#!/bin/bash
# comment-source-gh.sh — default comment source for comment-watcher.sh.
#
# Invoked as: comment-source-gh.sh <owner/name> <since-iso> <bot-login>
#
# Emits one TSV line per PR/issue comment, review comment, and review body the
# repo produced at or after <since-iso>, newest position last (ascending). The
# watcher classifies and acts; this handler only fetches. Translates the v1
# polling skills (github-activity-poll, activity-feed-watcher,
# at-mention-surveillance) onto the typed comment endpoints:
#
#   issues/comments  → PR-level conversation comments + standalone issue comments
#   pulls/comments   → inline PR review-comments (enumerates ALL comments tied to
#                      a review, not just the latest event-surfaced one)
#   pulls/<n>/reviews→ formal review BODIES (CHANGES_REQUESTED / COMMENTED asks),
#                      which carry no since= filter, so iterate open PRs
#
# TSV columns (tab-separated, body single-lined):
#   created_at  surface  comment_id  pr_number  author  html_url  body
# surface ∈ issue-comment | pr-review-comment | pr-review-body
#
# Monitoring safety: only call this for repos gated against untrusted
# contributors (see comment-watcher.sh header). The bodies returned here reach
# `claude -p` downstream.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"
GARDEN_TAG="comment-source"

repo="${1:?owner/name}"; since="${2:-}"; bot="${3:-kriscendobot}"

# Hard dependencies. ROOT-CAUSE fix for the 2026-06-24 outage: this handler pipes
# `gh api | jq` to EXTERNAL jq, so a missing jq used to yield silent empty output
# ("no new comments") for ~16h. require_tools fails LOUDLY (and alerts the
# maintainer) instead of letting a missing binary masquerade as "no comments".
# Must run BEFORE the jq pipelines below.
require_tools gh jq

# Bound the query window: never look back more than 24h, and on a cold start
# (empty cursor) seed a modest 1h retroactive window. This keeps `since=` from
# growing without bound on a long-idle watcher while still catching a directive
# the maintainer left in the last hour.
floor="$(date -u -d '-24 hours' +%FT%TZ 2>/dev/null || echo "$since")"
cold="$(date -u -d '-1 hour'   +%FT%TZ 2>/dev/null || echo "")"
if [ -z "$since" ]; then since="$cold"; fi
# effective since = max(since, floor)
if [ -n "$floor" ] && [ "$since" \< "$floor" ]; then since="$floor"; fi

oneline='(.body // "") | gsub("[\t\r\n]+"; " ")'

# Stderr policy below: gh's `2>/dev/null` suppresses EXPECTED-empty noise (404 on
# an endpoint, an idle window). jq carries NO `2>/dev/null`: a jq parse error is a
# real fault that must surface, not be swallowed. The `|| true` tolerates a
# transient gh failure on one endpoint without aborting the others; a truly missing
# jq can no longer reach here (require_tools above dies first).

# 1) issue/PR conversation comments
gh api --paginate "repos/$repo/issues/comments?since=$since&per_page=100" 2>/dev/null \
  | jq -r --arg s "$since" "
      .[] | select(.created_at >= \$s)
      | [ .created_at, \"issue-comment\", (.id|tostring),
          ((.issue_url // \"\") | capture(\"/(?<n>[0-9]+)\$\").n // \"\"),
          .user.login, .html_url, ($oneline) ] | @tsv" || true

# 2) inline PR review-comments (all comments tied to a review)
gh api --paginate "repos/$repo/pulls/comments?since=$since&per_page=100" 2>/dev/null \
  | jq -r --arg s "$since" "
      .[] | select(.created_at >= \$s)
      | [ .created_at, \"pr-review-comment\", (.id|tostring),
          ((.pull_request_url // \"\") | capture(\"/(?<n>[0-9]+)\$\").n // \"\"),
          .user.login, .html_url, ($oneline) ] | @tsv" || true

# 3) formal review bodies AND inline-only reviews (no since= filter; iterate open
#    PRs, filter by submitted_at).
#    A review whose top-level body is EMPTY but that carries one or more inline
#    comments (the substance lives entirely in the inline threads) used to be
#    dropped here by `select((.body // "") != "")`, silently losing an entire
#    maintainer review — observed on endo-but-for-bots #503/#96 and kriskowal/
#    garden #4 (reviews 4573331488 + 4573434772, neither acted on). The presence
#    of a trusted maintainer's inline review comments IS the directive, so such a
#    review must be surfaced regardless of body/verb/phrasing. For each open PR we
#    compute the set of review ids that carry >=1 inline comment and surface a
#    review-body line when the body is non-empty OR the review is inline-bearing.
#    Inline-bearing reviews are prefixed [INLINE-REVIEW] so the watcher's
#    classifier can treat a trusted sender's review as actionable and enumerate
#    ALL its inline comments. CHANGES_REQUESTED keeps its own prefix too.
gh pr list -R "$repo" --state open --json number --jq '.[].number' 2>/dev/null \
  | while read -r n; do
      [ -n "$n" ] || continue
      # Review ids that carry at least one inline comment on this PR. A
      # space-delimited string so the reviews jq below can membership-test it.
      rids="$(gh api --paginate "repos/$repo/pulls/$n/comments?per_page=100" 2>/dev/null \
              | jq -r '.[] | (.pull_request_review_id // empty) | tostring' \
              | sort -u | tr '\n' ' ')"
      gh api "repos/$repo/pulls/$n/reviews" 2>/dev/null \
        | jq -r --arg s "$since" --arg n "$n" --arg rids " $rids " '
            .[] | select((.submitted_at // "") >= $s)
            | (.id|tostring) as $rid
            | ($rids | contains(" " + $rid + " ")) as $inline
            | select(((.body // "") != "") or $inline)
            | [ .submitted_at, "pr-review-body", $rid, $n, .user.login, .html_url,
                ( (if $inline then "[INLINE-REVIEW] " else "" end)
                + (if .state=="CHANGES_REQUESTED" then "[CHANGES_REQUESTED] " else "" end)
                + ((.body // "") | gsub("[\t\r\n]+"; " ")) ) ] | @tsv' || true
    done
