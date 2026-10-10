Implemented and pushed commit `61a16d250ef` to `main2`.

- Rechecks quota before every post-canary review-metadata batch.
- Runs each batch leader synchronously and serializes batches when quota freshness is uncertain.
- Publishes the shared cooldown before peers can issue doomed calls.
- Added regression coverage proving one refusal per post-canary exhaustion episode.
- Verified with `scripts/jobs/test/comment-watcher-test.sh`: 480 passed, 0 failed.
- Self-improvement: nothing this time.
- Follow-ups: none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-quota-safe-review-fanout.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1228s

<!-- garden-usage-end -->
