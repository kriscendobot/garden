---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/budget-level.sh
scripts/jobs/budget-level.sh:42-49 logs every remote-snapshot failure, so the stale snapshot at 2026-09-29T06:05:06 can repeat each leveling tick. Add a persistent edge latch keyed by pool, host, operation, and reason: warn once, count suppressed repeats, and emit a recovery summary when a valid snapshot returns. Cover stale-snapshot and other remote-spend failures with a deterministic test.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-29T06:27:40Z
