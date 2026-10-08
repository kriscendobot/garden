---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/handlers/comment-source-gh.sh
scripts/jobs/handlers/comment-source-gh.sh:491 discards a failed `gh api rate_limit` probe, then permits a canary request that hit primary quota at 2026-10-08T08:55:04Z. Preserve and classify probe stderr under the existing admission lock; on primary exhaustion, latch the cooldown and freeze the cursor before any review-metadata request.
