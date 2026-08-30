---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/common.sh
Route reclone_clone through the bounded, stderr-capturing clone path and classify transient SSH rc=255 diagnostics as EX_TEMPFAIL. The shared journal outage repeatedly made fresh clones and claims fatal across hermits, sysop, inbox readers, scaler, and watchers instead of cleanly skipping until connectivity recovered.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 4
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-30T05:56:52Z
