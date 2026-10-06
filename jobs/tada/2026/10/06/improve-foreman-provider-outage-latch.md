Implemented and pushed commit `b636de6b1a9` to `main2`.

- Added a persistent, bounded all-provider outage cooldown keyed by provider order and quota state.
- Cooldown ticks skip inference and return EX_TEMPFAIL; `foreman.sh` normalizes this to a healthy timer exit without repeated FATAL alerts.
- Provider-order/quota changes invalidate the latch; expiry triggers an immediate re-probe.
- Added regression coverage: provider tests 43/43 passed; foreman decision tests 11/11 passed.
- Full suite reached unrelated existing failures in gardener-scaler logging and bulletin deferred-plan rendering.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-foreman-provider-outage-latch.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 897s

<!-- garden-usage-end -->
