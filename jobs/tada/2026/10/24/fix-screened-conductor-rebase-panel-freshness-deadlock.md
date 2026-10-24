Implemented and pushed commit `03fb3fa40f2` to `main2`.

- Rebase-equivalent heads now receive one deterministic, single-round exact-head panel before any conductor is posted.
- Legacy rebase attestations no longer trigger doomed `-rN` conductor retries.
- Updated conductor documentation and screening design/operations guidance.
- Added regression coverage for re-panel deduplication, exact-head progression, and legacy attestations.
- Verified: 35 screening tests, 17 merge-spine tests, shellcheck, and all 13 repository check suites passed.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-screened-conductor-rebase-panel-freshness-deadlock.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 410s

<!-- garden-usage-end -->
