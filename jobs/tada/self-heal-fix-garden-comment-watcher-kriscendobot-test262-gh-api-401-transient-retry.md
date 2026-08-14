Implemented and pushed commit 43827ce31a to main2.

- Added narrow `HTTP 401|Bad credentials` matching to the gh-api transient retry set only.
- Documented persistent-credential safety, bounded backoff cost, and loud failure semantics.
- Preserved the watcher’s dedicated authentication classification.
- Added recovery and persistent-401 regression cases.

Verified:
- `gh-api-retry-test.sh`: 41 passed, 0 failed.
- `comment-watcher-test.sh`: 306 passed, 0 failed.
- Bash syntax and `git diff --check` passed.

Self-improvement: nothing this time.
Follow-ups: none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-comment-watcher-kriscendobot-test262-gh-api-401-transient-retry.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 291s

<!-- garden-usage-end -->
