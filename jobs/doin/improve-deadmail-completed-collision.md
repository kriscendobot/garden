---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/deadmail.sh
scripts/jobs/deadmail.sh:234 treats post-job rc=79 as retryable, causing the same seven dead-mail entries to warn every five minutes (2026-10-24T11:00–11:20). Recognize GARDEN_COMPLETED_COLLISION_RC as a terminal idempotent promotion: verify the job is reachable in todo/doin/tada, then retire the dead-mail entry using the existing CAS loop. Preserve retry behavior when verification cannot establish the completed job remotely.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-24T11:20:38Z
