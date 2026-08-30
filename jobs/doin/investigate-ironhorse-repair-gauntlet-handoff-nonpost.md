---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Investigate why the ironhorse fuzz repair handler declares a `-gauntlet` handoff without durably posting that successor. At least fourteen `ironhorse-fuzz-*-repair` jobs are currently live in `doin`; verify whether the gauntlet post is failing silently across the shared handler, fix the posting path, and add deterministic coverage.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-30T07:46:49Z
