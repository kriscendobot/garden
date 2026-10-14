Implemented and pushed commit `53b54cb07a1` to `main2`.

- Added stable `deadline-nudge` soft-lock cooldown key across clone stages.
- Repeated ticks now skip quietly during the cooldown and retry after expiry.
- Added regression coverage for latching, quiet skipping, and expiry.
- Verified: `deadline-nudge-test.sh` passed 67/67; syntax and diff checks passed.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-deadline-nudge-lock-cooldown.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1284s

<!-- garden-usage-end -->
