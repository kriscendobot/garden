---
gate: deferred
priority: normal
arc: moonshots
posted_by: producer
posted_at: 2026-10-07T16:34:39Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
PR: https://github.com/kriscendobot/endo-but-for-bots/pull/1
Arc: moonshots
Milestone: M3

On promotion, first verify that the PR is still OPEN and not draft. If it has merged, closed, or gone draft, complete this job as a no-op. Otherwise run:

`scripts/jobs/post-gauntlet.sh --arc moonshots kriscendobot-endo-but-for-bots-pr1-gauntlet-20261007 https://github.com/kriscendobot/endo-but-for-bots/pull/1`
