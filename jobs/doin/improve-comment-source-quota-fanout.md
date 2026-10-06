---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/handlers/comment-source-gh.sh
scripts/jobs/handlers/comment-source-gh.sh:342-505 launches eight REST review workers under one admission, so the 2026-10-06T15:58:36Z primary-quota exhaustion still emitted eight refused requests. Add a quota-aware fanout guard that limits or stops new review-metadata requests when remaining REST capacity is near exhaustion, then freezes the cursor and opens the shared cooldown before another concurrent batch is admitted. Extend the existing watcher fixture to assert that a quota refusal bounds the concurrent burst.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-06T16:21:27Z
