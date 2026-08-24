---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/journal-entry.sh
Derive the role from canonical claimed-job context when available, preserving an explicit `GARDEN_ROLE` override and the gardener fallback. This removes the agent’s obligation to remember role export, prevents misattributed scholar results, and restores duplicate suppression across equivalent reports.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-24T19:21:17Z
