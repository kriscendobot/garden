---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/ensure-project-worktree.sh
Resolve requested branches from the garden fork when absent upstream, and verify the ref before checkout. Repeated ironhorse repair handlers fail because `ironhorse-fuzz-findings` exists on `kriscendobot` but the script fetches only `endojs`.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-30T08:23:14Z
