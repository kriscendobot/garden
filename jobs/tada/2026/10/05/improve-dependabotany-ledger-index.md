Implemented and pushed commit `7500a8f07d3` to `main2`.

- Added deterministic, journal-HEAD-keyed TSV snapshots of normalized active Dependabot embargo rows.
- Rechecks consume matching snapshots and fall back to the case-insensitive full ledger scan when unavailable, malformed, or stale.
- Added drain-generation, normalization, HEAD-keying, determinism, and fallback coverage.
- Targeted suite: 34 passed, 0 failed.
- Full suite exposed unrelated scaler and plan-queue assertion failures.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-dependabotany-ledger-index.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 682s

<!-- garden-usage-end -->
