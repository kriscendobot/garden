---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/inbox-read.sh
Retry a transient initial journal-clone failure with bounded backoff before giving up. A failed inbox clone currently makes the gardener silently skip its one inbox drain (`|| true`), risking an in-flight job missing its directed message entirely.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-14T06:20:58Z
