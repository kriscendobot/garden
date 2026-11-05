---
posted_at: 2026-11-05T16:51:02Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/screen-delegated-prs.sh
`scripts/jobs/screen-delegated-prs.sh:65` logs a WARN on every post-threshold quota-deferred tick, producing warnings at 16:21–16:46 despite the shared cooldown already preventing requests. Make the warning edge-latched (with optional milestone reporting) while preserving the existing coalesced maintainer alert and recovery notice.
