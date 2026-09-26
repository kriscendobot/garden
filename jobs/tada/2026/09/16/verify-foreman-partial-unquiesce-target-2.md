Verified the leader rollout using read-only host-filesystem inspection:

- Deployed descendant: `db3687f60de6ea784f625f22245835e881a6cfd2`
- Rendered unit: `Environment=GARDEN_FOREMAN_ACTIVE_TARGET=2`
- Pre-change: `2026-09-16T05:30:13Z inflight=4 target=0 guard=subscribed`
- First real promotion: `2026-09-16T10:04:13Z inflight=1 target=2 guard=promoted count=1 last=verify-foreman-partial-unquiesce-target-2`

No files changed and no follow-up is required.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/verify-foreman-partial-unquiesce-target-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 510s

<!-- garden-usage-end -->
