---
posted_at: 2026-11-08T12:21:33Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/scheduler.sh
`scripts/jobs/scheduler.sh:515` dispatches the controller health watch as an LLM job despite `schedules/oros-health-watch.md:19` defining a deterministic paired-check completion gate; it twice exited unsignaled in 31s and was parked at 2026-11-08T12:03:17Z. Add a deterministic controller-mode health-watch path that reads paired completion, fleet, roll, and sysop records, writes a bounded disposition, and defers only genuinely judgmental or attested repairs. Test that routine controller cycles close without consuming a worker or requeueing.
