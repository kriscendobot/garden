Implemented and pushed `93c1678728` to `main2`.

- Proxy now uses journal claim→tada commit span, falling back to `duration_secs`.
- Removed capped earlier-attempt approximation.
- Extended regression test for 25s total span vs 19s final attempt.
- Verified: `auction-reputation-test.sh` — 67 passed.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-wallclock-cost-proxy-for-censored-arms-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 1 host(s) (1 unmetered)
- Input: 220 tokens (15684540 cached reads)
- Output: 99306 tokens
- Cost: $13.688661 (1 engagement(s) unpriced)
- Wall-clock: 2097s

<!-- garden-usage-end -->
