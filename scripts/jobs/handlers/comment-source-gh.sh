#!/bin/bash
# comment-source-gh.sh — default comment source for comment-watcher.sh.
#
# Invoked as: comment-source-gh.sh <owner/name> <since-iso> <bot-login>
#
# Emits one TSV line per PR/issue comment, review comment, and review body the
# repo produced at or after <since-iso>, newest position last (ascending). The
# watcher classifies and acts; this handler only fetches.
#
# Self-authored rows are DROPPED at the source: every surface filters out comments
# and reviews whose author is <bot-login>. The bot reacting to its OWN comments is
# a feedback loop with no legitimate case, and the verb classifier keys on phrasing,
# so the bot's own status notes generate spurious directives. Observed on endo-but-
# for-bots #57: the bot's "I've parked the restage of this PR pending #475 ... I'm
# holding until #475 settles" comment (whose intent is NOT to rebase) was classified
# as a `rebase` directive and spawned a premature rebase job onto a still-moving
# base. Trusted EXTERNAL senders are still gated downstream by the watcher; only the
# bot's own login is dropped here. Translates the v1
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
#   created_at  surface  comment_id  pr_number  author  html_url  body  [review_id]
# surface ∈ issue-comment | pr-comment | pr-review-comment
#         | pr-review-comment-subsumed | pr-review-body
#
# The TRAILING review_id column is emitted ONLY on the inline review-comment surfaces
# (pr-review-comment / pr-review-comment-subsumed): every inline comment carries a
# pull_request_review_id, and surfacing it lets the watcher key the comment's job on
# the SAME review id its parent review-body uses, so one review can never mint two
# differently-keyed jobs (the #548 duplicate-fold). It is appended LAST so the
# watcher's positional `IFS=$'\t' read` is unaffected for the other surfaces (which
# carry no 8th column).
#
# pr-review-comment-subsumed marks an inline review-comment whose parent review is
# ALSO surfaced this poll as an inline-bearing pr-review-body: that review's single
# `review` job already enumerates every inline comment tied to it, so the standalone
# comment is suppressed downstream (the watcher logs it and slides the cursor) to
# avoid double-working the same inline comment.
#
# The issues/comments endpoint folds BOTH true-issue conversation comments AND a
# PR's own conversation comments into one stream (GitHub models a PR as an issue).
# We split them by the comment's html_url path segment — `/pull/<n>#…` for a PR's
# conversation, `/issues/<n>#…` for a true issue — costing NO extra API call. The
# distinction matters because a repo may ALSO be watched by the issue-inbox, which
# OWNS true-issue comments (config/garden-repo); the comment-watcher then runs
# PR-only and skips surface=issue-comment to avoid a duplicate dispatch, while
# surface=pr-comment (a PR's conversation comment) stays the comment-watcher's
# UNIQUE surface and is never dropped. On a repo with no issue-inbox the watcher
# treats both surfaces identically, so the split is invisible there.
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

# Every `gh api` here is `gh_api_retry` (common.sh): a TRANSIENT blip (5xx / 429 /
# DNS-TLS-reset) is ridden out under full-jitter backoff before the call gives up,
# so a single GitHub flake no longer blanks an endpoint — and, on the structural
# calls below, no longer produces the empty self-heal blob. A DEFINITIVE error
# (404 / auth) is NOT retried; it fails through to the same degrade paths as before.
#
# Stderr policy below: gh's `2>/dev/null` suppresses EXPECTED-empty noise (404 on
# an endpoint, an idle window) AND gh_api_retry's own retry/WARN lines on the
# per-endpoint fetches. jq carries NO `2>/dev/null`: a jq parse error is a real
# fault that must surface, not be swallowed. The `|| true` tolerates a transient gh
# failure on one endpoint without aborting the others; a truly missing jq can no
# longer reach here (require_tools above dies first).
#
# EXCEPTION — section 3's STRUCTURAL gh calls (the paginated open-PR list and the
# `rids=` review-id call) do NOT use `2>/dev/null`. Unlike the per-endpoint fetches
# in 1–2, a failure here aborts the open-PR walk; blinding it (a rate-limit / network
# / auth blip) produced an EMPTY self-heal blob — one FATAL line, no `  source:`
# context (blob d65a4f0a). With gh_api_retry a transient blip is now absorbed before
# it ever reaches that failure; if it persists past the retries, gh_api_retry's WARN
# (carrying the captured gh stderr) is captured to a buffer that is echoed to fd 2
# ONLY on failure (so a genuine fault still reaches the watcher's ERRF), and the
# failure is then degraded with `|| true` / `|| rids=""` so it can't kill the source —
# matching the graceful-degrade intent of sections 1–2.

# 1) issue/PR conversation comments. Classify by html_url: a PR's conversation
#    comment's html_url is .../pull/<n>#issuecomment-…, a true issue's is
#    .../issues/<n>#issuecomment-… — so `test("/pull/")` separates a PR-conversation
#    comment (surface pr-comment) from a true-issue comment (surface issue-comment)
#    with no extra API call. The watcher skips issue-comment in PR-only mode but
#    always keeps pr-comment.
gh_api_retry --paginate "repos/$repo/issues/comments?since=$since&per_page=100" 2>/dev/null \
  | jq -r --arg s "$since" --arg bot "$bot" "
      .[] | select(.created_at >= \$s)
      | select((.user.login // \"\") != \$bot)
      | [ .created_at,
          (if ((.html_url // \"\") | test(\"/pull/\")) then \"pr-comment\" else \"issue-comment\" end),
          (.id|tostring),
          ((.issue_url // \"\") | capture(\"/(?<n>[0-9]+)\$\").n // \"\"),
          .user.login, .html_url, ($oneline) ] | @tsv" || true

# 2) inline PR review-comments — emitted LAST, AFTER the review walk in section 3,
#    so the set of review ids this poll surfaces as inline-bearing pr-review-body
#    jobs ($surfaced_inline_rids) is known. A comment tied to one of those reviews
#    is SUBSUMED by that review's single `review` job and is suppressed there (the
#    dedup fix); see the section-2 block immediately below section 3.

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
#    An APPROVED review is ALSO always surfaced — even with an empty body and no
#    inline comments — prefixed [APPROVED], so the watcher can NOTICE a clean
#    maintainer approval and dispatch the finalization-to-merge (the gap behind
#    endo-but-for-bots #528: APPROVED + MERGEABLE + asks done, but left DRAFT
#    because nothing surfaced the approval).
# Enumerate ALL open PRs, not gh's default page. `gh pr list` (no --limit) returns
# only the 30 most-recent-by-number open PRs (via the search API), so a review-only
# directive on an OLDER open PR is never polled — the #284 blindness: kriskowal's
# COMMENTED "Please refresh." review on endo-but-for-bots #284 slid past unseen
# because #284 sat below the 30-PR cutoff (the repo had 169 open PRs down to #57).
# The authoritative paginated REST list returns every open PR. We request it sorted
# by most-recent activity (sort=updated&direction=desc) and STOP once a PR's
# updated_at is older than the cursor `since`: a PR with a review/comment submitted
# since the cursor necessarily has a fresh updated_at, so every PR that could carry
# new work sits at the top of the list. This bounds per-tick work to recently-active
# PRs while still catching every PR with new activity (incl. the #284 case, whose
# updated_at jumped when the review landed) — no silent default-page truncation.
#
# The list is captured to a variable FIRST (rather than piped straight into the
# while-loop) so the activity-bound early-stop is a plain bash `break` and never
# SIGPIPEs the paginating gh, which would otherwise trip pipefail and spuriously
# echo the structural-call stderr buffer on a clean early-stop.
#
# Capture buffers for the structural gh calls' stderr (see Stderr policy EXCEPTION
# above): echoed to fd 2 only when the call fails, so a real fault reaches ERRF
# while a clean run stays quiet.
prlist_err="$(mktemp)"; rids_err="$(mktemp)"; s3out="$(mktemp)"
open_prs="$(gh_api_retry --paginate \
    "repos/$repo/pulls?state=open&sort=updated&direction=desc&per_page=100" \
    2>"$prlist_err" \
    | jq -r '.[] | [(.number|tostring), (.updated_at // "")] | @tsv')" \
  || { cat "$prlist_err" >&2; open_prs=""; }

scanned=0; total=0
while IFS=$'\t' read -r n updated; do
  [ -n "$n" ] || continue
  total=$((total+1))
  # Activity bound: the list is newest-activity-first, so once a PR's updated_at
  # predates the cursor, every remaining PR is older too and none can carry a
  # review/comment submitted since `since`. Stop scanning here.
  if [ -n "$updated" ] && [ "$updated" \< "$since" ]; then break; fi
  scanned=$((scanned+1))
  # Review ids that carry at least one inline comment on this PR. A
  # space-delimited string so the reviews jq below can membership-test it.
  : >"$rids_err"
  rids="$(gh_api_retry --paginate "repos/$repo/pulls/$n/comments?per_page=100" 2>"$rids_err" \
          | jq -r '.[] | (.pull_request_review_id // empty) | tostring' \
          | sort -u | tr '\n' ' ')" || { rids=""; cat "$rids_err" >&2; }
  gh_api_retry --paginate "repos/$repo/pulls/$n/reviews?per_page=100" 2>/dev/null \
    | jq -r --arg s "$since" --arg n "$n" --arg rids " $rids " --arg bot "$bot" '
        .[] | select((.submitted_at // "") >= $s)
        | select((.user.login // "") != $bot)
        | (.id|tostring) as $rid
        | ($rids | contains(" " + $rid + " ")) as $inline
        | select(((.body // "") != "") or $inline or (.state=="APPROVED"))
        | [ .submitted_at, "pr-review-body", $rid, $n, .user.login, .html_url,
            ( (if $inline then "[INLINE-REVIEW] " else "" end)
            + (if .state=="CHANGES_REQUESTED" then "[CHANGES_REQUESTED] " else "" end)
            + (if .state=="APPROVED" then "[APPROVED] " else "" end)
            + ((.body // "") | gsub("[\t\r\n]+"; " ")) ) ] | @tsv' >> "$s3out" || true
done <<< "$open_prs"
# No silent caps: record how many open PRs were polled vs how many the activity
# bound skipped (info-level stderr; the watcher ignores a 0-exit source's stderr).
log "polled $scanned of $total open PR(s) on $repo (activity-bounded at since=$since)"

# The set of review ids this poll SURFACED as inline-bearing pr-review-body jobs.
# A pr-review-comment whose parent review is in this set is SUBSUMED by that review's
# single keyed `review` job — which already enumerates and resolves EVERY inline
# comment tied to the review — so it must NOT also mint a standalone comment job. This
# is the dedup fix for the SIX-jobs-for-three-inline-comments race on
# endo-but-for-bots #548. The set is extracted from section 3's OWN emitted output
# (field 3 = review id, field 7 = body) so it can never diverge from what was actually
# surfaced. Now emit section 3's review-body lines (order is irrelevant; the watcher
# re-sorts by created_at).
surfaced_inline_rids="$(awk -F'\t' '$2=="pr-review-body" && $7 ~ /\[INLINE-REVIEW\]/ {print $3}' "$s3out" 2>/dev/null | sort -u | tr '\n' ' ' || true)"
cat "$s3out"

# 2) inline PR review-comments (all comments tied to a review). A comment whose parent
#    review WAS surfaced this poll as an inline-bearing pr-review-body (review id in
#    $surfaced_inline_rids) is marked surface=pr-review-comment-subsumed: downstream the
#    watcher logs it and slides the cursor past it WITHOUT minting a second job, because
#    that review's `review` job already enumerates every inline comment tied to it. A
#    comment whose review was NOT inline-surfaced (parent review untrusted/dropped, on a
#    closed or out-of-activity-bound PR, or a standalone PR-line comment with no formal
#    review) keeps the actionable pr-review-comment surface so it is never lost.
gh_api_retry --paginate "repos/$repo/pulls/comments?since=$since&per_page=100" 2>/dev/null \
  | jq -r --arg s "$since" --arg rids " $surfaced_inline_rids " --arg bot "$bot" "
      .[] | select(.created_at >= \$s)
      | select((.user.login // \"\") != \$bot)
      | ((.pull_request_review_id // \"\") | tostring) as \$rid
      | (if (\$rid != \"\") and (\$rids | contains(\" \" + \$rid + \" \"))
         then \"pr-review-comment-subsumed\" else \"pr-review-comment\" end) as \$surface
      | [ .created_at, \$surface, (.id|tostring),
          ((.pull_request_url // \"\") | capture(\"/(?<n>[0-9]+)\$\").n // \"\"),
          .user.login, .html_url, ($oneline), \$rid ] | @tsv" || true

rm -f "$prlist_err" "$rids_err" "$s3out"
