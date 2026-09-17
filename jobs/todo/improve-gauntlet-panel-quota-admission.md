---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gauntlet.sh
Before posting a panel stage, deterministically check the configured panel-provider quota/admission state. Defer the stage until quota is usable rather than spending a panel attempt that aborts at a seat on weekly-quota exhaustion and produces no verdict.
