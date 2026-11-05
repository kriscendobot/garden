---
posted_at: 2026-11-05T04:52:11Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/review-docket-request.sh
`scripts/jobs/review-docket-request.sh:28` propagates rc=76 although `review-docket.sh:504,698` has already durably spooled the intake; this made the gauntlet-wait handler fail at 2026-11-05 04:31:42. Normalize the configured spooled rc to successful deferred intake with a log message, so callers complete while the scripted docket drains the durable spool.
