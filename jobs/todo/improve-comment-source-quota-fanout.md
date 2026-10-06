---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/handlers/comment-source-gh.sh
scripts/jobs/handlers/comment-source-gh.sh:342-505 launches eight REST review workers under one admission, so the 2026-10-06T15:58:36Z primary-quota exhaustion still emitted eight refused requests. Add a quota-aware fanout guard that limits or stops new review-metadata requests when remaining REST capacity is near exhaustion, then freezes the cursor and opens the shared cooldown before another concurrent batch is admitted. Extend the existing watcher fixture to assert that a quota refusal bounds the concurrent burst.
