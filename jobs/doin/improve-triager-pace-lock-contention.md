---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/triager.sh
Make the optional shared pacing-clone refresh fail fast under live lock contention, using a short bounded acquisition and the existing fail-open warning latch. The current three 60-second waits produce recurring FATAL noise and delay many otherwise-complete triager ticks merely to calculate a nonessential next wake.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-22T10:21:15Z
