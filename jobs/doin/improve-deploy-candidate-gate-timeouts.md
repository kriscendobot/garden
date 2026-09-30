---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/deploy-garden.sh
Defect: `scripts/jobs/deploy-garden.sh:389` applies the same 60-second cap on both attempts, and the 2026-09-30T16:42:12Z gate timed out both integration suites with rc=124. On an attempt-1 timeout, retry each affected suite once with a bounded increased per-suite allowance that still fits `GARDEN_DEPLOY_TEST_TOTAL_TIMEOUT`, while retaining both diagnostics. Keep syntax, missing-suite, and total-wall-clock failures fail-closed as at `scripts/jobs/deploy-garden.sh:433-447`, and add a regression fixture for the escalation and its total-budget refusal.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-30T17:40:19Z
