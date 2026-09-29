---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/set-schedule-once.sh
scripts/jobs/set-schedule-once.sh:47-50 relies solely on the shared producer clone, which was corrupt and livelocked on a stale index.lock at 2026-09-29T17:17Z. Add a bounded isolated-CAS fallback that writes the schedule through a fresh temporary clone when shared-clone sync cannot recover, so deferral does not depend on agent-run plumbing recovery.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-29T19:33:17Z
