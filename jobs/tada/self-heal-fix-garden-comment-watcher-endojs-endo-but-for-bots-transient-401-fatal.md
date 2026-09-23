Implemented and pushed commit `532946f5a2` to `main2`.

- Added retry-once handling for transient HTTP 401 authentication rotations.
- Preserved timeout process-group cleanup and LOST-FETCH cursor freezing.
- Added successful-retry and persistent-401 regression coverage.
- Verified `comment-watcher-test.sh`: 306 passed, 0 failed.
- Verified `gh-api-retry-test.sh`: 39 passed, 0 failed.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-comment-watcher-endojs-endo-but-for-bots-transient-401-fatal.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 260s

<!-- garden-usage-end -->
