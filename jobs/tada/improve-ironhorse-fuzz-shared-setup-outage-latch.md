Implemented and pushed commit `93c0b60d85` to `main2`.

- Persisted shared-runner outage start time, latest failure, consecutive rc=2 count, retry deadline, failed target, and diagnostic location.
- Made outage warnings edge-triggered; retries now emit quiet continuation status.
- Retained one bounded diagnostic snapshot across recovery.
- Added a single recovery summary with outage duration and failure count.
- Expanded regression coverage; `ironhorse-fuzz-test.sh` passes all 45 tests.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-ironhorse-fuzz-shared-setup-outage-latch.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 220s

<!-- garden-usage-end -->
