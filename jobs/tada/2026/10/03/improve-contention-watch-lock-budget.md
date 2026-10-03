Implemented and pushed commit `42d6e593580` to `main2`.

- Added a two-second bounded shared-lock attempt for clone inspection.
- Busy producer clones are deferred to the next tick without partial statistics.
- Heartbeats and deferred-clone ordering remain intact.
- Added regression coverage for lock contention and heartbeat preservation.
- Tests passed: `journal-contention-watch-test.sh`, `repo-locks-test.sh`, and `fetch-timeout-test.sh`.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-contention-watch-lock-budget.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 383s

<!-- garden-usage-end -->
