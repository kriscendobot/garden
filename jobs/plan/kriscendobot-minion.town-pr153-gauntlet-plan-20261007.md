---
gate: deferred
priority: normal
arc: garden-upkeep
posted_by: producer
posted_at: 2026-10-07T16:37:37Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
PR: https://github.com/kriscendobot/minion.town/pull/153
Arc: garden-upkeep
Milestone: -

On promotion, first verify that the PR is still OPEN and not draft. If it has merged, closed, or gone draft, complete this job as a no-op. Otherwise run:

`scripts/jobs/post-gauntlet.sh --arc garden-upkeep kriscendobot-minion.town-pr153-gauntlet-20261007 https://github.com/kriscendobot/minion.town/pull/153`
