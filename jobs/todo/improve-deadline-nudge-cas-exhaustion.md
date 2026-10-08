---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/deadline-nudge.sh
scripts/jobs/deadline-nudge.sh:542 returns failure after only classified CAS contention, producing three warnings at 2026-10-08T19:26:26 despite the courtesy timer already deferring delivery. Treat exhausted lost-race retries as a clean, edge-suppressed deferral and add a regression test for continuous CAS contention.
