---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gauntlet.sh
Add a CAS-safe resume-from-stage primitive so a halted staged gauntlet can resume at a specified stage (such as FIX) without a gardener performing a one-off journal transaction.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-17T01:23:07Z
