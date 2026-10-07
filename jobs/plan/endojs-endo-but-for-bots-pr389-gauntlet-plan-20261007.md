---
gate: deferred
priority: normal
arc: unallocated
posted_by: producer
posted_at: 2026-10-07T16:24:14Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
PR: https://github.com/endojs/endo-but-for-bots/pull/389
Arc: unallocated
Milestone: M3

On promotion, first verify that the PR is still OPEN and not draft. If it has merged, closed, or gone draft, complete this job as a no-op. Otherwise run:

`scripts/jobs/post-gauntlet.sh --arc unallocated endojs-endo-but-for-bots-pr389-gauntlet-20261007 https://github.com/endojs/endo-but-for-bots/pull/389`
