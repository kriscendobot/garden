Implemented and pushed commit `a70c8251b2b` to `main2`.

- Added a persistent per-pool budget-sensor outage timer with a configurable 300-second grace period.
- Brief unreadable-meter events remain fail-open; sustained outages stop new claims and issue a stable-key, deduplicated maintainer alert.
- Readable sensor results clear the outage episode.
- Added integration coverage for grace, fail-closed admission, alert deduplication, and recovery reset.
- Checks: `bash -n`, `git diff --check`, and `decision-ledger-test.sh` passed (17/17). All three new live-budget assertions passed; that suite retains four unrelated failures also reproduced on the original `main2`.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-budget-sensor-outage-admission.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 269s

<!-- garden-usage-end -->
