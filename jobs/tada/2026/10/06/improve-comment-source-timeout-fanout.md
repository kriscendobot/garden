Implemented and pushed commit `d28d7f4b9f3` to `main2`.

- Added bounded concurrent per-PR review metadata fetching, defaulting to 8 workers.
- Preserved complete pagination, deterministic output, primary-quota handling, and fail-closed cursor behavior.
- Added a 20-active-PR deadline regression covering full surface enumeration, concurrency bounds, and worker failure handling.
- Verified `comment-watcher-test.sh`: 465 passed, 0 failed.
- No follow-ups required.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-comment-source-timeout-fanout.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1115s

<!-- garden-usage-end -->
