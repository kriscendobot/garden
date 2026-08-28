---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gauntlet.sh
Increase the panel-stage handler timeout with safe claim-TTL headroom: panel round 2 deterministically exceeded the 7200s budget. Keep panel rounds claim-sized rather than letting one predictable wall hit doom the stage.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-28T00:52:04Z
