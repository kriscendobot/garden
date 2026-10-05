Implemented and pushed commit `da1f562a9dd` to `origin/main2`.

- Transient deploy fetch failures now return `GARDEN_OFFLINE_RC`.
- Rolling deploys retry unchanged SHAs next tick without recording rejection markers.
- Deterministic failures retain existing rejection backoff.
- Added regression coverage and refreshed stale worker-kind assertions.
- Verified: rolling-deploy tests passed 109/109; deploy-garden tests passed 179/179; syntax and diff checks passed.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-transient-deploy-fetch.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 427s

<!-- garden-usage-end -->
