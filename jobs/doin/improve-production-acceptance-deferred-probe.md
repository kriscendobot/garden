---
posted_at: 2026-11-07T13:51:46Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/auto-gauntlet-handoff.sh
scripts/jobs/auto-gauntlet-handoff.sh:136-158 only re-stages review after a successor completes, while this successor requires merge and deployment first, producing a waiting-agent treadmill. Reconcile an `orchestrated-slice` successor against PR merge and deployment/probe state, and release its production-verification job only after those deterministic prerequisites succeed. Evidence: 2026-11-07T13:24:09Z and 13:24:24Z show the same job exiting without completion at 41/44s before requeue exhaustion. This moves external-state waiting out of an agent claim and into a durable script-driven gate.

<!-- garden-transient-elapsed: kind=exit0 through=0 values=45 -->
<!-- garden-reap-now -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 4
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-07T13:51:55Z
