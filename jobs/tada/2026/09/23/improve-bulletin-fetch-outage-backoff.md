Implemented and pushed commit `0903c64865c` to `main2`.

- Coalesced repeated journal-fetch failures into one logged outage episode.
- Added exponential retry delays from 5 seconds up to a 300-second cap.
- Added immediate recovery handling after a successful sync.
- Added a focused CI regression test.
- Verified with the new regression test, ShellCheck, syntax checks, and the full job suite: 386 passed, 0 failed.
- Self-improvement: nothing this time.
- Follow-ups: none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-bulletin-fetch-outage-backoff.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 571s

<!-- garden-usage-end -->
