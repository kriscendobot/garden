---
gate: deferred
priority: normal
arc: minion-town-ui
posted_by: producer
posted_at: 2026-10-07T16:37:18Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
PR: https://github.com/kriscendobot/minion.town/pull/143
Arc: minion-town-ui
Milestone: -

On promotion, first verify that the PR is still OPEN and not draft. If it has merged, closed, or gone draft, complete this job as a no-op. Otherwise run:

`scripts/jobs/post-gauntlet.sh --arc minion-town-ui kriscendobot-minion.town-pr143-gauntlet-20261007 https://github.com/kriscendobot/minion.town/pull/143`
