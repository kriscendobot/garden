---
tier: mentor
arc: unallocated
---
<!-- garden-promoted-from-plan: gate=deferred priority=normal at=2026-10-17T11:14:09Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
PR: https://github.com/endojs/endo-but-for-bots/pull/508
Arc: unallocated
Milestone: -

On promotion, first verify that the PR is still OPEN and not draft. If it has merged, closed, or gone draft, complete this job as a no-op. Otherwise run:

`scripts/jobs/post-gauntlet.sh --arc unallocated endojs-endo-but-for-bots-pr508-gauntlet-20261007 https://github.com/endojs/endo-but-for-bots/pull/508`
