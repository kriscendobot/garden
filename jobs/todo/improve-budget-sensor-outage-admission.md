---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/claim-job.sh
`scripts/jobs/claim-job.sh:258` leaves claims fail-open whenever the budget pool is unreadable; this recurred at 2026-10-16T03:51:06Z, 03:52:32Z, and 03:55:38Z. Persist an outage timer per pool and automatically stop new claims with one deduplicated alert after a bounded grace period, while retaining fail-open only for brief sensor blips.
