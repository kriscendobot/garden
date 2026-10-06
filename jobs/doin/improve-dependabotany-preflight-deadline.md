---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/dependabotany-preflight.sh
scripts/jobs/dependabotany-preflight.sh:78 permits a 180s PR-source call although scheduler.sh:587 kills the entire gate at 120s, producing the 03:12:25Z timeout and fail-open dispatch. Give the preflight one scheduler-compatible total deadline, clip each external stage to its remaining budget, and return EX_TEMPFAIL before expiry when no verdict is possible; add coverage for the clipped path.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-06T03:22:47Z
