---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/cursor-get.sh
Harden the shared cursor-read path so a correlated rc=1 failure is classified and latched as a single temporary journal outage, with a bounded retry/recovery path. One shared failure produced warnings and skipped ticks across comment watchers, triagers, and issue inbox instead of the intended quiet host-wide suppression.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-19T20:52:56Z
