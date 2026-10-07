---
gate: deferred
priority: normal
arc: unallocated
posted_by: producer
posted_at: 2026-10-07T16:36:22Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
PR: https://github.com/kriscendobot/minion.town/pull/37
Arc: unallocated
Milestone: -

On promotion, first verify that the PR is still OPEN and not draft. If it has merged, closed, or gone draft, complete this job as a no-op. Otherwise run:

`scripts/jobs/post-gauntlet.sh --arc unallocated kriscendobot-minion.town-pr37-gauntlet-20261007 https://github.com/kriscendobot/minion.town/pull/37`
