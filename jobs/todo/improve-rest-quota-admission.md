---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/common.sh
scripts/jobs/common.sh:6343 serializes REST calls but only cools after GitHub refuses one; the comment watcher exhausted primary quota at 2026-10-24 14:27:38. Add a host-wide, reset-aware REST admission budget that periodically records core remaining/reset and accounts for admitted calls, deferring low-priority watcher reads before exhaustion. Keep the existing refusal latch as the fallback when quota metadata is unavailable, and leave GraphQL independently metered.
