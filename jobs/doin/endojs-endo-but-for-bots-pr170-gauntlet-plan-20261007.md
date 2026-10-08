---
tier: mentor
arc: endo-ocapn-background
---
<!-- garden-promoted-from-plan: gate=deferred priority=normal at=2026-10-08T07:38:15Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
PR: https://github.com/endojs/endo-but-for-bots/pull/170
Arc: endo-ocapn-background
Milestone: -

On promotion, first verify that the PR is still OPEN and not draft. If it has merged, closed, or gone draft, complete this job as a no-op. Otherwise run:

`scripts/jobs/post-gauntlet.sh --arc endo-ocapn-background endojs-endo-but-for-bots-pr170-gauntlet-20261007 https://github.com/endojs/endo-but-for-bots/pull/170`

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-08T07:38:23Z
