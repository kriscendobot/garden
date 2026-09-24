---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/comment-latency-watch.sh
Honor the shared REST API cooldown before collecting sources; when a source reports GitHub primary-quota exhaustion, latch the primary-quota-duration cooldown, stop the remaining source sweep, write a cooldown heartbeat, and exit cleanly. This prevents the observed per-repository 403 storm and repeated systemd failures while the quota cannot recover.
