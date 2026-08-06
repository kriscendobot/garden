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
# secondary throttle / DNS-TLS-reset) is ridden out under full-jitter backoff before
# the call gives up. GitHub PRIMARY quota exhaustion instead fails after one attempt,
# so a single GitHub flake no longer blanks an endpoint — and, on the structural
# calls below, no longer produces the empty self-heal blob. A DEFINITIVE error
# (404 / auth) is NOT retried; it fails through to the same degrade paths as before —
# except a definitive REPO-level 404, which deactivates the watch (see the REPO-GONE
# degrade at the tail) rather than failing every tick against a repo that is gone.
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

# --- the LOST-FETCH invariant: a partial enumeration must FAIL the tick ---------
# The watcher advances its durable cursor over the comments THIS source emits, so a
# surface that silently returns a SUBSET (a transient/rate-limit blip degraded with
# `|| true`) let the cursor slide PAST comments it never enumerated — they then sit
# below the new cursor and are never re-polled. Concrete drop: maintainer inline
# review comment r3566529028 on #678 vanished when the `pulls/comments` surface
# blipped while the issue-comment surface succeeded and drove the cursor forward.
# The fix extends the watcher's "a lost PUSH must re-poll, never drop" invariant to a
# lost FETCH: if ANY surface fails to enumerate for the window, we set fetch_failed
# and EXIT NONZERO at the tail. The watcher discards a nonzero-rc source's output and
# either skips the tick (transient signature → cursor frozen) or dies loud
# (structural) — either way the cursor never advances past the un-enumerated comments,
# so the next healthy tick re-polls them. gh_api_retry already rides out a genuine
# blip under full-jitter backoff, so this fires only on a PERSISTENT failure.
#
# EXCEPTION — a DEFINITIVE repo-level 404 is not a lost fetch, it is a GONE repo.
# See repo_is_definitively_gone() and the tail block below: freezing the cursor and
# exiting nonzero can only ever be re-tried against a repo that no longer exists,
# which is a permanent systemd failure loop, not a recoverable enumeration gap.
fetch_failed=""
fetch_primary_quota=""
note_fetch_failure() {  # note_fetch_failure <label> <errfile>
  fetch_failed=1
  if is_gh_primary_rate_limit_text "$(cat "$2" 2>/dev/null || true)"; then
    fetch_primary_quota=1
  fi
  # Echo the captured gh stderr (carrying gh_api_retry's WARN with the underlying
  # 5xx/rate-limit/network signature) to fd 2 so the watcher can classify the tick
  # failure as transient (skip) vs structural (die). The FETCH-FAIL prefix keeps the
  # incomplete-enumeration reason diagnosable in the journal.
  { printf 'FETCH-FAIL: surface %s failed to enumerate — freezing cursor\n' "$1"
    cat "$2" 2>/dev/null || true; } >&2
}

# 1) issue/PR conversation comments. Classify by html_url: a PR's conversation
#    comment's html_url is .../pull/<n>#issuecomment-…, a true issue's is
#    .../issues/<n>#issuecomment-… — so `test("/pull/")` separates a PR-conversation
#    comment (surface pr-comment) from a true-issue comment (surface issue-comment)
#    with no extra API call. The watcher skips issue-comment in PR-only mode but
#    always keeps pr-comment. Guarded: a fetch failure is DETECTED (fetch_failed),
#    not swallowed by `|| true` into a silent partial subset.
s1_err="$(mktemp)"
if _raw="$(gh_api_retry --paginate "repos/$repo/issues/comments?since=$since&per_page=100" 2>"$s1_err")"; then
  printf '%s' "$_raw" | jq -r --arg s "$since" --arg bot "$bot" "
      .[] | select(.created_at >= \$s)
      | select((.user.login // \"\") != \$bot)
      | [ .created_at,
          (if ((.html_url // \"\") | test(\"/pull/\")) then \"pr-comment\" else \"issue-comment\" end),
          (.id|tostring),
          ((.issue_url // \"\") | capture(\"/(?<n>[0-9]+)\$\").n // \"\"),
          .user.login, .html_url, ($oneline) ] | @tsv"
else
  note_fetch_failure "issues/comments" "$s1_err"
fi
rm -f "$s1_err"

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
prlist_err="$(mktemp)"; rids_err="$(mktemp)"; rev_err="$(mktemp)"; s3out="$(mktemp)"
# A FAILED open-PR list is NOT an empty list: degrading it to open_prs="" (the prior
# behavior) silently dropped EVERY review surface while the cursor still advanced off
# the successful issue-comment surface. Mark it a fetch failure so the tick is frozen.
if [ -n "$fetch_primary_quota" ]; then
  open_prs=""
else
  open_prs="$(gh_api_retry --paginate \
      "repos/$repo/pulls?state=open&sort=updated&direction=desc&per_page=100" \
      2>"$prlist_err" \
      | jq -r '.[] | [(.number|tostring), (.updated_at // "")] | @tsv')" \
    || { note_fetch_failure "pulls?state=open (open-PR list)" "$prlist_err"; open_prs=""; }
fi

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
  # rids feeds the inline-bearing membership test. A FAILED fetch is NOT "this PR has
  # no inline comments": rids="" would silently demote an inline-only review out of
  # the review-body surface (the r3566529028 drop class). Mark it a fetch failure.
  : >"$rids_err"
  rids="$(gh_api_retry --paginate "repos/$repo/pulls/$n/comments?per_page=100" 2>"$rids_err" \
          | jq -r '.[] | (.pull_request_review_id // empty) | tostring' \
          | sort -u | tr '\n' ' ')" || { rids=""; note_fetch_failure "pulls/$n/comments (review-id map)" "$rids_err"; }
  # A primary quota refusal applies to every remaining surface for this identity.
  # Stop the PR walk immediately instead of multiplying doomed requests by every
  # active PR and its review surfaces.
  [ -n "$fetch_primary_quota" ] && break
  # Guard the reviews fetch too: a swallowed failure here dropped that PR's entire
  # review-body surface while the cursor advanced. Capture-then-emit so a gh failure
  # is DETECTED (fetch_failed), not lost to `| jq … || true`.
  : >"$rev_err"
  if _revs="$(gh_api_retry --paginate "repos/$repo/pulls/$n/reviews?per_page=100" 2>"$rev_err")"; then
    printf '%s' "$_revs" | jq -r --arg s "$since" --arg n "$n" --arg rids " $rids " --arg bot "$bot" '
        .[] | select((.submitted_at // "") >= $s)
        | select((.user.login // "") != $bot)
        | (.id|tostring) as $rid
        | ($rids | contains(" " + $rid + " ")) as $inline
        | select(((.body // "") != "") or $inline or (.state=="APPROVED"))
        | [ .submitted_at, "pr-review-body", $rid, $n, .user.login, .html_url,
            ( (if $inline then "[INLINE-REVIEW] " else "" end)
            + (if .state=="CHANGES_REQUESTED" then "[CHANGES_REQUESTED] " else "" end)
            + (if .state=="APPROVED" then "[APPROVED] " else "" end)
            + ((.body // "") | gsub("[\t\r\n]+"; " ")) ) ] | @tsv' >> "$s3out"
  else
    note_fetch_failure "pulls/$n/reviews" "$rev_err"
  fi
  [ -n "$fetch_primary_quota" ] && break
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
# Guarded like the others: this is the surface that carries the r3566529028-class
# inline review comment, so a swallowed blip here was the exact silent drop. Capture
# the fetch and mark a failure rather than emitting a partial subset.
s2_err="$(mktemp)"
if [ -z "$fetch_primary_quota" ]; then
  if _inline="$(gh_api_retry --paginate "repos/$repo/pulls/comments?since=$since&per_page=100" 2>"$s2_err")"; then
    printf '%s' "$_inline" | jq -r --arg s "$since" --arg rids " $surfaced_inline_rids " --arg bot "$bot" "
        .[] | select(.created_at >= \$s)
        | select((.user.login // \"\") != \$bot)
        | ((.pull_request_review_id // \"\") | tostring) as \$rid
        | (if (\$rid != \"\") and (\$rids | contains(\" \" + \$rid + \" \"))
           then \"pr-review-comment-subsumed\" else \"pr-review-comment\" end) as \$surface
        | [ .created_at, \$surface, (.id|tostring),
            ((.pull_request_url // \"\") | capture(\"/(?<n>[0-9]+)\$\").n // \"\"),
            .user.login, .html_url, ($oneline), \$rid ] | @tsv"
  else
    note_fetch_failure "pulls/comments (inline review comments)" "$s2_err"
  fi
fi
rm -f "$s2_err"

rm -f "$prlist_err" "$rids_err" "$rev_err" "$s3out"

# --- the REPO-GONE degrade (a 404 repo must DEACTIVATE, never crash-loop) -----
# The LOST-FETCH invariant below is built for a RECOVERABLE gap: freeze the cursor,
# fail the tick, re-poll when the surface comes back. A repo that no longer exists
# (deleted, renamed, transferred, or access revoked) has no "comes back": EVERY
# surface 404s, so fetch_failed is set on every tick forever, the source exits 1, the
# watcher's structural branch dies loud, and the unit fails on a timer in perpetuity
# — a permanent restart loop that pages nobody and fixes nothing. Observed on
# kriscendobot/garden, whose stale bare clone auto-armed a comment watcher against a
# repo that did not exist.
#
# So before honoring the invariant we ask ONE authoritative question — does the repo
# itself still exist? — and treat a DEFINITIVE 404/403 on `repos/<repo>` as a
# deactivation signal: log it, alert the maintainer ONCE (throttled per-slug, the
# triager.sh dead-upstream shape), and exit 0. Exit 0 is correct: with no comments
# emitted the watcher slides nothing and simply goes quiet, so the unit stays clean
# while the maintainer's inbox carries the one actionable message (drop the arming
# record, add the watch-optout tombstone). We deliberately do NOT auto-write the
# journal tombstone from a watcher tick: watch-optout/<slug> only suppresses
# fork-watch-provisioner AUTO-arming, so it would not stop a hand-armed watcher, and
# a CAS push from a per-minute timer is a far heavier act than an alert.
#
# The probe runs ONLY on the already-failed path, so a healthy tick pays nothing.
# It fires only on a DEFINITIVE verdict: a transient signature means "we could not
# ask", not "it is gone", and falls through to the unchanged freeze-and-retry below.
REPO_GONE_REASON=""
repo_is_definitively_gone() {
  local errf stderr
  errf="$(mktemp 2>/dev/null || printf '%s' "${TMPDIR:-/tmp}/comment-source-repo-probe.$$")"
  if gh_api_retry "repos/$repo" --jq '.full_name' >/dev/null 2>"$errf"; then
    rm -f "$errf"; return 1                      # the repo answers — a real lost fetch
  fi
  stderr="$(cat "$errf" 2>/dev/null || true)"
  rm -f "$errf"
  # "Could not ask" is never "gone" (never guess a state).
  _gh_api_stderr_is_transient "$stderr" && return 1
  case "$stderr" in
    *"Not Found"*|*"HTTP 404"*|*'"status":"404"'*|*"HTTP 403"*|*"Must have admin rights"*)
      REPO_GONE_REASON="$stderr"; return 0 ;;
  esac
  return 1                                       # definitive but not repo-level — freeze
}

# The LOST-FETCH invariant (see fetch_failed above): if ANY surface failed to
# enumerate this window, FAIL the tick so the watcher does NOT advance its cursor
# past comments we never saw. The next healthy tick re-polls them; re-posting an
# already-handled directive is an idempotent no-op (verify_posted + identity dedup).
if [ -n "$fetch_failed" ]; then
  if [ -n "$fetch_primary_quota" ]; then
    log "RATE LIMITED: GitHub primary API quota exhausted while enumerating $repo — freezing the cursor and ending this tick without further surface requests"
    exit "${GARDEN_TRANSIENT_RC:-75}"
  fi
  if repo_is_definitively_gone; then
    slug="${repo//\//-}"
    log "REPO GONE: $repo returns a definitive repo-level error (${REPO_GONE_REASON:-<no stderr>}) — the repo does not exist or is no longer readable. Deactivating this watch gracefully (exit 0) instead of failing the tick forever."
    alert_maintainer "comment-watch-repo-gone-${slug//[^A-Za-z0-9._-]/_}" \
      "comment-watcher: $repo no longer exists (or is unreadable) on GitHub — gh api repos/$repo returns a definitive error: ${REPO_GONE_REASON:-<no stderr>}. The watcher is armed by journal comment-repos/$slug, so every tick would otherwise fail forever; it now exits 0 and watches nothing. To close this out: delete journal comment-repos/$slug (and any repos/$slug / ci-repos/$slug siblings), add a journal watch-optout/$slug tombstone so fork-watch-provisioner.sh never re-arms it, and remove the stale bare clone worktrees/$slug.git that likely triggered the arming. If instead the repo was RENAMED or TRANSFERRED, re-key the arming record to the new <owner>-<name> slug rather than dropping the watch."
    exit 0
  fi
  log "FETCH INCOMPLETE for $repo: one or more comment surfaces failed to enumerate — exiting nonzero so the watcher freezes the cursor and re-polls (never advance past un-enumerated comments)"
  exit 1
fi
