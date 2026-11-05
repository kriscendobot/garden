---
posted_at: 2026-11-05T05:22:47Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gauntlet.sh
scripts/jobs/gauntlet.sh:1 lacks a bounded deterministic status-probe mode, leaving gauntlet wait jobs to hold an agent session; the 2026-11-05T05:14:51Z waiter failed after its review-docket work spooled. Add a single-tick probe that reads the gauntlet record, emits durable terminal status, and re-posts a short deferred check while it remains active. Have the job machinery use that probe instead of foreground agent polling so drains and provider loss cannot strand a long-lived waiter.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-11-05T05:23:09Z
