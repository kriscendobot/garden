---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/fork-watch-provisioner.sh
`scripts/jobs/fork-watch-provisioner.sh:223-239` turns the shared temporary-unavailable rc=75 with no diagnostic into an `unclassified` WARN; at 2026-10-04T00:41:52Z this deferred all 15 forks. Recognize `${GARDEN_OFFLINE_RC}` explicitly as a quiet host-wide temporary outage/cooldown, preserving fail-open deferral without misleading unclassified escalation. Add a hermetic test for an rc=75 silent upstream probe and its quiet bounded retry behavior.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-04T00:51:25Z
