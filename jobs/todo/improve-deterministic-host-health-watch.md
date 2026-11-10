---
posted_at: 2026-11-10T10:51:40Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/host-health-watch.sh
`scripts/jobs/check-mechanic-role.sh:69-70` delegates the deterministic controller confirmation to a mentor; at 2026-11-10T10:44:05Z it exhausted its retry after an exit-0-unsatisfying 22s run.
Implement the confirmation as a leader-only script that reads the target’s current host-health record and local-checkup freshness, exits quietly when healthy, and posts a mechanic repair job only for stale or unhealthy evidence.
