---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/comment-watcher.sh
`scripts/jobs/comment-watcher.sh:1862` treats an EX_TEMPFAIL refusal from an already-live transient cooldown as primary quota because its synthetic diagnostic includes “API rate limit,” as shown at 2026-10-07T22:50:52 when a 300s Pages network latch became a 3600s comment quota latch. Check the existing cooldown before classifying source stderr, preserving the cursor and exiting quietly as collateral failure. Add a regression case for a transient-owner admission refusal to ensure it does not promote the latch to primary quota.
