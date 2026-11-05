---
posted_at: 2026-11-05T03:21:31Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gardener.sh
scripts/jobs/gardener.sh:1088-1121 and :1166-1197 treat review-docket rc=76 as a handler failure even though review-docket.sh durably spooled the request. At 2026-11-05T03:10:14Z, the stale-panel upsert was spooled and rc=76 caused the completed gauntlet job to be escalated as failed. Accept rc=76 like the fixer re-entry path at :1039-1042, record the deferred disposition, and complete the job; retain retries for non-spooled errors.
