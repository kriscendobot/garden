---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/mentor.sh
Persist and rate-limit repeated identical transient-provider outages: retain retry behavior, but suppress duplicate warnings with bounded exponential backoff and emit a single recovery notice. The current every-tick WARN loop violates silent-until-error and repeatedly reprocesses the same digest.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-24T00:51:09Z
