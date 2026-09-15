---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/common.sh
Harden `reap_stale_worker_cgroup` against detached Node descendants surviving worker restarts. The warnings show repeated leftovers across both cleric and monk units; reliably identify and terminate live residue (while handling zombies safely) before the next claim, and add regression coverage for the restart/race path.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-15T14:21:32Z
