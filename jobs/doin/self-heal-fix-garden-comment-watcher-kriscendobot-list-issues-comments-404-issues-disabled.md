---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/handlers/comment-source-gh.sh

A definitive 404 on `repos/<repo>/issues/comments` is not a lost fetch when the repo has Issues DISABLED — it is a surface that cannot exist, and today it crash-loops the watcher forever while silently hiding every PR conversation comment.

Failure signature (garden-comment-watcher@kriscendobot-list, 2026-08-17 13:31:18, exit 1):
```
FETCH-FAIL: surface issues/comments failed to enumerate — freezing cursor
WARN: gh api repos/kriscendobot/list/issues/comments?since=... failed (definitive, rc=1); not retrying: gh: Not Found (HTTP 404)
FATAL: comment source failed for kriscendobot/list (rc=1)
```
Verified: `gh api repos/kriscendobot/list` returns 200 with `"fork": true, "has_issues": false` (fork of publicsuffix/list; GitHub disables Issues on forks by default and 404s the whole repo-level issues namespace). The tail's `repo_is_definitively_gone()` correctly declines to deactivate — the repo is alive — so the source exits 1 on every tick in perpetuity. 12 of the 17 armed comment-repos have `has_issues: false` and hit this as soon as they see activity.

Two changes:

(a) In section 1's failure branch (~line 167), before `note_fetch_failure "issues/comments"`, probe ONCE on the already-failed path only (the `repo_is_definitively_gone()` pattern — a healthy tick pays nothing): if the stderr is a definitive 404 AND `gh_api_retry "repos/$repo" --jq '.has_issues'` reports `false`, do NOT set `fetch_failed`. Log it at most once per tick and continue. A transient signature must still fall through to `note_fetch_failure` unchanged — "we could not ask" is never "the surface is absent".

(b) Do NOT just skip the surface — re-route it, or the fix trades a crash loop for silent blindness. That endpoint is the ONLY source of PR conversation comments, and `kriscendobot/list` has 9 of them right now that the fleet cannot see. Verified reachable on the same repo despite `has_issues: false`: `repos/<repo>/issues/<n>/comments` returns 200 with the real comments (and `repos/<repo>/pulls/comments` works too). When the surface is absent, enumerate PR conversation comments per-open-PR inside section 3's existing paginated open-PR walk (already sorted `updated&direction=desc` and bounded by the cursor `since`), emitting the same `pr-comment` TSV lines section 1 produces — same `.html_url` / `.id` / issue-number / login / body fields, same `created_at >= $since` and `!= $bot` filters. A failure of that per-PR call MUST still `note_fetch_failure` so LOST-FETCH holds. `issue-comment` (true-issue) lines are correctly absent for such a repo: it has no issues.

Also fix the second, independent misclassification in the same tick — `scripts/jobs/common.sh` line 3163: add `unexpected end of JSON input` to `GARDEN_TRANSIENT_GH_API_SIGNATURES`. Verified with `gh api ... -i`: `repos/kriscendobot/list/pulls/1/reviews` returns `HTTP/2.0 500` with `Content-Length: 0`, and gh's Go decoder surfaces only `unexpected end of JSON input` — the status never reaches stderr, so the existing `HTTP 5[0-9][0-9]` alternative cannot match and a plain 5xx is logged `(definitive, rc=1); not retrying`. This is the third instance of the shape the block comment above that line already documents (the `invalid character '<'` HTML-body case and the http2 `stream error` case); extend that comment with this one. Retrying an empty-body 5xx is exactly as safe as the 5xx already retried, and a persistent one still fails loud after `GARDEN_GH_API_ATTEMPTS`. This signature set is shared with the watcher's `is_transient_gh_source_error` (comment-watcher.sh:1481), so the same one-line change also converts that tick from `die` to WARN-and-skip.

Regression coverage in `scripts/jobs/test/comment-watcher-test.sh` using the existing `GARDEN_GH` stub seam: (1) a repo whose `issues/comments` 404s and whose `repos/<repo>` reports `has_issues:false` → source exits 0, emits the `pr-comment` lines gathered per-PR, cursor advances; (2) same 404 but `has_issues:true` → still a lost fetch, exit 1, cursor frozen (no regression to the LOST-FETCH invariant); (3) `unexpected end of JSON input` on a surface → retried, then classified transient rather than fatal.

<!-- garden-reap-now -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-17T13:36:42Z
