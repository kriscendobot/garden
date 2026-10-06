Implemented and pushed commit `c3b3c458adb` to `main2`.

- Persisted failed follow-up seen-cursor publications locally.
- Retries pending publication on every subsequent tick, including no-op ticks.
- Clears the marker only after `cursor-set.sh` succeeds.
- Added regression coverage for failure, persistence, no-op retry, and cleanup.
- Verification: `follow-up-seen-cursor-test.sh` passed all 8 tests; syntax and diff checks passed.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-follow-up-seen-cursor-retry.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 236s

<!-- garden-usage-end -->
