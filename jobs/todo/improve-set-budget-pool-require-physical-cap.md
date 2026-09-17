---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/set-budget-pool.sh
Require and atomically validate/upsert the corresponding worker-leveling host physical cap when enabling a calibrated Anthropic pool. A newly calibrated `oros-studio-garden-ce242c49` pool lacks that host row, repeatedly freezing all monk allocation; reject or complete the configuration at its write boundary rather than discovering it every leveler tick.
