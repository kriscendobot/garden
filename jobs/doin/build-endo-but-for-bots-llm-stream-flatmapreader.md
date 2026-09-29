---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Port `flatMapReader` (@endo/stream) onto llm (endojs/endo-but-for-bots)

Found in gap analysis by `endojs-endo-but-for-bots-sync-llm-master-20260929`. endojs/endo-but-for-bots#545, "feat(stream): add flatMapReader for 1-to-many reader transforms", merged into the fork's `master` lineage as `843f2f8f1`, followed by `4d7267685` and `44dc6b5ae`. It never reached `llm`, which has no `flatMapReader` in `packages/stream`, or upstream. A reconstruction on `master-1bb6e7f`, endojs/endo-but-for-bots#758, has sat open as a draft since 2026-09-01.

Task: first check whether an llm consumer needs `flatMapReader`, and whether #758 is still the intended upstream vehicle. If llm should carry it, port the three commits onto current `llm` and open a DRAFT PR against a frozen `llm-<sha>` base per `skills/pr-creation-flow/SKILL.md`, stopping at draft. If llm should not carry it, complete with a short report saying why. Do not touch #758.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-29T02:07:23Z
