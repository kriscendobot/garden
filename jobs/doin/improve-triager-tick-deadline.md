---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/triager.sh
Add an internal bounded tick deadline and clean fail-open exit before systemd’s 900-second wall. The minion.town triager reached the unit timeout, so slow nested journal/fetch/pace work must defer to the next tick rather than be SIGTERM-killed.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-22T09:22:13Z
