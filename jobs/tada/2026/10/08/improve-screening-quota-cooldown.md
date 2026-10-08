Implemented and pushed commit `a2170c5e7fc` to `main2`.

- Routed all screener GitHub reads through a hardened, quota-aware interface.
- Added REST/GraphQL admission, retry, and host-wide cooldown handling.
- Live or newly exhausted primary quota now quietly defers the tick with no journal state changes.
- Malformed responses remain fatal.
- Added regression tests for live cooldown, quota exhaustion, and malformed JSON.
- Verified: API cooldown suite passed 32/32; screening suite passed 33/33; shell syntax, ShellCheck, and diff checks passed.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-screening-quota-cooldown.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 518s

<!-- garden-usage-end -->
