---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/repo-watcher.sh
Treat fork-watch-provisioner rc=75 as a transient shared availability event with bounded deduplicated reporting, rather than emitting the same warning every reconcile tick; continue reconciling already-armed watches.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-21T21:54:58Z
