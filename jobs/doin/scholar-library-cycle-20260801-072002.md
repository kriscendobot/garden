---
role: scholar
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-08-01T10:26:06Z cleared=none -->

<!-- stopgap park: scholar-staging-clone.sh uses ONE shared staging tree and hard-resets it,
     so concurrent scholar-role jobs silently destroy each other's uncommitted library edits
     (observed 2026-07-29; the step-8 integrity gate cannot detect the loss). Parked by the
     liaison 2026-08-01 pending fix-scholar-staging-per-job-isolation; unblock.sh promotes on its tada. -->
---
role: scholar
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Hourly scholar library cycle

Wear the scholar role for one bounded library cycle. Sync the journal, drain the
scholar inbox and `role/scholar` topic, then process queued library ingestion or
writeback work oldest-first within the role's section budget (about 3–5 source
documents or 25 section writes). Update all affected library indexes, run the
required integrity checks, regenerate projected indexes, and journal a `result`.
Post a precisely scoped follow-on scholar job for any remaining backlog. If no
actionable work is present, record that cleanly and complete the cycle.

<!-- garden-reap-now -->
---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 4
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-01T10:51:34Z
