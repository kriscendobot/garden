---
gate: deferred
priority: normal
arc: unallocated
posted_by: producer
posted_at: 2026-10-07T16:36:02Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
PR: https://github.com/kriscendobot/finbot/pull/7
Arc: unallocated
Milestone: -

On promotion, first verify that the PR is still OPEN and not draft. If it has merged, closed, or gone draft, complete this job as a no-op. Otherwise run:

`scripts/jobs/post-gauntlet.sh --arc unallocated kriscendobot-finbot-pr7-gauntlet-20261007 https://github.com/kriscendobot/finbot/pull/7`
