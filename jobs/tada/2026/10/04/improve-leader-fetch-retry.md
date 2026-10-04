Implemented and pushed commit `71bfbb3dca3` to `main2`.

- Routed leader-marker fetches through `journal_fetch` bounded retries before stale-cache fallback.
- Added regression coverage proving a transient first fetch failure recovers without warning or retry marker.
- Verified `main-host-test.sh`: 53 passed, 0 failed.
- Verified `fetch-timeout-test.sh`: 28 passed, 0 failed.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-leader-fetch-retry.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 200s

<!-- garden-usage-end -->
