---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/handlers/mirror-pr-state-gh.sh
Avoid emitting a FATAL “no usable PR state” after GitHub primary-quota exhaustion. Preserve the nonzero no-state contract for mirror-closer’s circuit breaker, but let the closer’s aggregate degraded warning be the sole quota report; retain loud failures for definitive malformed or unavailable state responses.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-20T11:52:44Z
