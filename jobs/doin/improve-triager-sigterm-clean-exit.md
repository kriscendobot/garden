---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/triager.sh
Handle TERM/INT before fetch classification and exit with the corresponding clean signal status. A systemd stop produced fetch rc=143 with no diagnostic, which the script treated as a real fetch failure and logged as a warning despite being an expected interrupted tick.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-17T00:53:42Z
