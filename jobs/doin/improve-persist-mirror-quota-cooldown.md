---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/mirror-closer.sh
scripts/jobs/mirror-closer.sh:323 discards a failed `start_api_cooldown`, yet line 324 claims the 3600s latch was armed; after that claim at 13:23:39, quota failures recurred at 13:35:38. Require the latch write to succeed, logging and failing the tick if it cannot, so self-healing diagnoses the unavailable cooldown state instead of repeatedly issuing quota-doomed requests.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-06T13:53:09Z
