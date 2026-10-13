Implemented and pushed commit `db074604e17` to `main2`.

- Routed follow-up seen-cursor publication through the shared bounded retry/classification helper.
- Transient CAS failures now retry within the same tick.
- Deterministic remote rejections remain loud, preserve repair-alert diagnostics, and are not retried.
- Added regression coverage for successful retries, exhausted retries, next-tick recovery, and remote rejection diagnostics.
- Verification: 10/10 follow-up cursor tests and 65/65 cursor outage/classification tests passed.
- Self-improvement: nothing this time.
- Follow-ups: none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-follow-up-cursor-retry.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 280s

<!-- garden-usage-end -->
