---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/triager.sh
Add a shared, short cooldown/readiness gate for the nonessential pacing-journal refresh so concurrent per-repo triager ticks do not repeatedly contend on one clone lock and emit warnings. Keep normal event triage and fixed timer cadence running; allow one later tick to retry pacing after the gate expires.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-22T12:21:19Z
