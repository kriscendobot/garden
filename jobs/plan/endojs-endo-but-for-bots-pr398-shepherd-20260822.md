---
gate: orchestrated
orchestrated_by: endojs-endo-but-for-bots-pr398-shepherd-conduct-20260822
priority: urgent
role: shepherd
posted_by: gardener
posted_at: 2026-08-22T01:05:04Z
---

---
role: shepherd
tier: mentor
dispatch: automatic
fallback-tier: minion
---

# Shepherd endojs/endo-but-for-bots PR #398

Carry endojs/endo-but-for-bots PR #398 to terminal green CI before the conductor runs.
Re-fetch the live PR and follow the shepherd role. The maintainer explicitly requested this
ordered step at https://github.com/endojs/endo-but-for-bots/pull/398#issuecomment-5376587229.

At routing time, head `fdc01f30d6bf803456505c2529534d860b6d7fd7` was mergeable and all
reported checks had settled successfully except `sandbox-drivers`, which was cancelled.
Determine whether that cancelled check is required or indicates work to do. Pursue terminal
green or surface a genuine impasse with the required `next: <role>` classification.

The next orchestration child is the conductor, so do not merge in this job.
