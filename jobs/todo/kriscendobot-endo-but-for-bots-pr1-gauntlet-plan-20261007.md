---
tier: mentor
arc: moonshots
---
<!-- garden-promoted-from-plan: gate=deferred priority=normal at=2026-10-08T12:34:16Z cleared=none -->

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
