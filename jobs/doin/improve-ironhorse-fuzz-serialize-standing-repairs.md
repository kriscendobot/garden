---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/ironhorse-fuzz.sh
Serialize repair jobs for each standing fuzz PR generation: retain every durable finding, but release only one repair onto the board at a time and release the next only after its predecessor completes. The current per-tick fan-out produced many concurrent builders amending the same branch, with repeated failed/requeued repairs.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-30T07:55:30Z
