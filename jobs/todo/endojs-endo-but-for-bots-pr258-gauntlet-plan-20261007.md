---
tier: mentor
arc: endo-ocapn-background
---
<!-- garden-promoted-from-plan: gate=deferred priority=normal at=2026-10-08T08:12:34Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
PR: https://github.com/endojs/endo-but-for-bots/pull/258
Arc: endo-ocapn-background
Milestone: M4

On promotion, first verify that the PR is still OPEN and not draft. If it has merged, closed, or gone draft, complete this job as a no-op. Otherwise run:

`scripts/jobs/post-gauntlet.sh --arc endo-ocapn-background endojs-endo-but-for-bots-pr258-gauntlet-20261007 https://github.com/endojs/endo-but-for-bots/pull/258`
