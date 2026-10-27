---
posted_at: 2026-10-27T14:20:49Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gardener.sh
scripts/jobs/gardener.sh:131-140 promises a handler cannot exceed its budget plus 60s, but the 2026-10-27T14:04:07Z progress entry records a 7,200s-budget handler lasting 10,265s. Harden the watchdog fail-closed path so an overdue handler that remains live cannot leave the parent blocked; terminate the complete handler cgroup/tree and record watchdog evidence with the failure. Add a regression fixture that holds a descendant past TERM and asserts the gardener returns within the configured wall bound.

<!-- garden-deadline-overrun: 1 -->
<!-- garden-reap-now -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-27T14:21:04Z
