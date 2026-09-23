Implemented and pushed commit `b478a61da4` to `main2`.

- Cursor-set `GARDEN_OFFLINE_RC` failures now exit quietly and retry next tick.
- Structural cursor failures still emit warnings.
- Added regression coverage for both behaviors.
- Verification: syntax and diff checks passed; comment-watcher suite passed 362 tests, including both new cases. One unrelated stale assertion expects `stage: clean` while gauntlets now initialize at `stage: viability`.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-comment-cursor-offline.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 208s

<!-- garden-usage-end -->
