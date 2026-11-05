---
posted_at: 2026-11-05T04:51:59Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/issue-inbox-watcher.sh
`scripts/jobs/issue-inbox-watcher.sh:688-755` lets its own source timeout (rc=124) fall through to FATAL; 2026-11-05 04:50:04 recorded exactly that while four comment sources also timed out. Classify rc=124/137 as a transient timeout, preserve the cursor, and apply the existing shared-cooldown/local-warning policy instead of failing the unit.
