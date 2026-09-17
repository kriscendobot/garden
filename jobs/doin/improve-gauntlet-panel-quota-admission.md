---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gauntlet.sh
Before posting a panel stage, deterministically check the configured panel-provider quota/admission state. Defer the stage until quota is usable rather than spending a panel attempt that aborts at a seat on weekly-quota exhaustion and produces no verdict.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-17T10:21:42Z
