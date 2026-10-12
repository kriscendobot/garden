Implemented and pushed commit `9614edcb9bd` to `main2`.

- Added deterministic detection of overdue host operations lacking matching `sysop-log` records.
- Added deduplicated maintainer alerts and recovery notices.
- Hosts with stale sysop bridges are marked control-plane unavailable, derotated, and restored only after both heartbeat and sysop recovery.
- Added regression coverage; `worker-derotate-test.sh` passes 21/21.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-sysop-control-plane-liveness.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 328s

<!-- garden-usage-end -->
