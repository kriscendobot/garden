---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Fix a broken-pipe misclassification in the shared gh-stderr transient classifier that turns an absorbable GitHub rate limit into a fatal watcher crash.

Failure signature (garden-comment-watcher@endojs-endo-but-for-bots, 2026-08-06 14:29:17, exit 1):
  /home/kris/garden2/scripts/jobs/common.sh: line 2968: printf: write error: Broken pipe
  <3> FATAL: comment source failed for endojs/endo-but-for-bots (rc=1)
preceded by ~69 lines of `gh: API rate limit exceeded for user ID 279080640 ... (HTTP 403)`.

Root cause — `_gh_api_stderr_is_transient()` at scripts/jobs/common.sh:2967-2969:
    printf '%s' "$1" | grep -qiE "$GARDEN_TRANSIENT_GH_API_SIGNATURES"
`grep -q` exits on the first match, closing the read end; `printf` then gets EPIPE writing the rest of a large blob and returns nonzero. Every caller runs under `set -euo pipefail`, so the pipeline status becomes printf's failure and the function returns FALSE — a matching transient signature is reported as DEFINITIVE. Reproduced in isolation: a blob whose first line is `gh: API rate limit exceeded ... (HTTP 403)` followed by a large tail classifies DEFINITIVE with the pipe and transient with a here-string.

Consequences observed / latent:
- comment-watcher.sh:1352 `is_transient_gh_source_error` returned false, so the intended "WARN + exit 0, skip the tick" path was skipped and line 1356 `die` ran instead — a systemd failure + restart storm on a condition the code explicitly means to absorb.
- comment-source-gh.sh:340 `repo_is_definitively_gone()` uses the same classifier to veto a `case` that matches `*"HTTP 403"*`. A misclassification there makes a rate limit indistinguishable from a deleted repo: the watcher would `alert_maintainer` "repo no longer exists", exit 0, and silently deactivate a live watch. Fix this before it fires.

Required change (scripts/jobs/common.sh):
1. Make `_gh_api_stderr_is_transient` immune to EPIPE and pipefail — feed grep without a pipe, e.g. `grep -qiE "$GARDEN_TRANSIENT_GH_API_SIGNATURES" <<<"$1"` (the scripts are already bash-only: `set -euo pipefail`, `${var//}` expansions). Keep the return contract identical (0 = transient, 1 = definitive) and note in the comment WHY the pipe was removed, so it is not reintroduced.
2. Add a regression case to scripts/jobs/test/gh-api-retry-test.sh SUBTEST 1: a stderr blob whose FIRST line carries a transient signature followed by a multi-megabyte tail must still classify transient, asserted with `set -o pipefail` active. The current short-string cases cannot catch this.

Second, bounded change (retry amplification against an exhausted quota) — scripts/jobs/handlers/comment-source-gh.sh:
GitHub's primary per-user limit resets on the hour, so retrying it under sub-second full-jitter backoff cannot succeed. This tick burned ~76 doomed calls (9 PRs x 2 surfaces x 4 attempts in 20 s) and produced the oversized stderr that tripped the bug above. Add a rate-limit circuit breaker mirroring the precedent at ci-watcher.sh:424 (`aborted` / "consecutive rollup reads unreadable — aborting tick"): once a surface fails with `API rate limit exceeded` / `x-ratelimit-remaining: 0`, stop enumerating further surfaces for the tick immediately and emit ONE loud WARN instead of repeating it per surface. Preserve the LOST-FETCH invariant exactly — `fetch_failed` must still be set and the cursor still frozen, so the next healthy tick re-polls; only the doomed call volume and the log volume shrink. Do NOT remove `rate limit` from GARDEN_TRANSIENT_GH_API_SIGNATURES — other callers depend on absorbing secondary-rate limits in band.

Verification: run scripts/jobs/test/gh-api-retry-test.sh and scripts/jobs/test/comment-watcher-test.sh; confirm a simulated rate-limited source now yields the watcher's "transient gh-api blip — skipping tick" WARN with exit 0, not FATAL exit 1.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-06T14:31:59Z
