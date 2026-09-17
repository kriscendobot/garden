---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/assert-followup-posted.sh
Recognize a completed gauntlet panel report whose sole follow-up is the deterministic driver-owned fix-loop transition (including a `gauntlet-stage-result: panel=must-fix` marker). The current gate treats it as an unposted successor and repeatedly fails an otherwise successful panel stage.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-17T04:21:31Z
