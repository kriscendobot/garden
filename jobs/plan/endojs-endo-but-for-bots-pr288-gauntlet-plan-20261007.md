---
gate: deferred
priority: normal
arc: endo-ocapn-background
posted_by: producer
posted_at: 2026-10-07T16:15:03Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
PR: https://github.com/endojs/endo-but-for-bots/pull/288
Arc: endo-ocapn-background
Milestone: M4

On promotion, first verify that the PR is still OPEN and not draft. If it has merged, closed, or gone draft, complete this job as a no-op. Otherwise run:

`scripts/jobs/post-gauntlet.sh --arc endo-ocapn-background endojs-endo-but-for-bots-pr288-gauntlet-20261007 https://github.com/endojs/endo-but-for-bots/pull/288`
