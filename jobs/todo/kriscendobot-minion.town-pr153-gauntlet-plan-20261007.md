---
tier: mentor
arc: garden-upkeep
---
<!-- garden-promoted-from-plan: gate=deferred priority=normal at=2026-10-08T15:52:12Z cleared=none -->

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
