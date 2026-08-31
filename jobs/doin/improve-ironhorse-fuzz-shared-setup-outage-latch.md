---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/ironhorse-fuzz.sh
Persist consecutive shared-runner rc=2 failures and make the warning edge-triggered, with one recovery summary. The provisioning outage recurred after the fixed retry window; retain bounded retries but avoid repeating routine warning noise while preserving outage duration and diagnostics.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-31T07:23:37Z
