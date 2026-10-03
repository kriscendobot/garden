Implemented and pushed `d8c3e4ba9ad` to `main2`.

- Added deterministic post-rejection fetch verification.
- Reconciles exact remote cursor content as success.
- Retries safely when the remote branch moved.
- Preserves stationary rejection diagnostics and raises an edge-deduplicated repair alert.
- Added regression coverage for landed-but-reported-rejected, moved-remote, classified/unclassified stationary rejection, and alert deduplication.
- Verification: cursor recovery suite passed 65/65; cursor concurrency suite passed 8/8. The broader suite stopped on three unrelated existing scaler/plan-queue assertions.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-cursor-push-recovery.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 690s

<!-- garden-usage-end -->
