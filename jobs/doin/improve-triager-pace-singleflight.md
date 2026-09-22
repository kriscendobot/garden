---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/triager.sh
Coordinate the optional host-wide pacing projection with a nonblocking singleflight/cache so concurrent per-repo triagers reuse one refresh or quietly retain timer cadence; the shared clone lock currently emits dozens of expected contention warnings.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-22T12:51:42Z
