---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gardener-scaler.sh
Latch repeated live-budget-snapshot publication failures: report the first failure, suppress routine repeats during the outage, and emit a recovery summary. Publication is explicitly fail-open, so minute-scale WARN repetition adds noise without changing reconciliation behavior.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-30T06:04:29Z
