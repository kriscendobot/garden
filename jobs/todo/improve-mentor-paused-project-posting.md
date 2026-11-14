---
posted_at: 2026-11-14T05:51:20Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/handlers/mentor-claude.sh
Defect: lines 405-413 let a paused-project refusal from `post-job.sh` abort the handler, producing mentor FATALs at 04:51:33 and 05:21:39. Classify `GARDEN_PAUSED_RC` as a routine skipped improvement, log it once, continue remaining blocks, and return success so the same digest cannot retrigger self-heal indefinitely.
