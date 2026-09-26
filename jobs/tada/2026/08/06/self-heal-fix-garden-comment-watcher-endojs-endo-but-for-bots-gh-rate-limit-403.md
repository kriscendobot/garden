Implemented and pushed commit `584d3b516c` to `main2`.

- Primary GitHub quota exhaustion now fails after one attempt; secondary limits and HTTP 429 still retry.
- Comment enumeration short-circuits remaining surfaces on quota exhaustion, freezes the cursor, and returns rc 75.
- The watcher propagates rc 75 for clean self-heal normalization without advancing `last_seen`.
- Added regression coverage for retry counts, surface short-circuiting, frozen cursors, and non-attributable classification.

Verification:
- `gh-api-retry-test.sh`: 37 passed
- `comment-watcher-test.sh`: 292 passed
- `ci-watcher-test.sh`: 49 passed
- Bash syntax and `git diff --check`: passed

Self-improvement: nothing this time.
Follow-ups: none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-comment-watcher-endojs-endo-but-for-bots-gh-rate-limit-403.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 567s

<!-- garden-usage-end -->
