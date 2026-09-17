---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/set-budget-pool.sh
Require and atomically validate/upsert the corresponding worker-leveling host physical cap when enabling a calibrated Anthropic pool. A newly calibrated `oros-studio-garden-ce242c49` pool lacks that host row, repeatedly freezing all monk allocation; reject or complete the configuration at its write boundary rather than discovering it every leveler tick.

---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-17T05:22:57Z
