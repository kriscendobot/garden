---
tier: mentor
arc: unallocated
---
<!-- garden-promoted-from-plan: gate=deferred priority=normal at=2026-10-10T12:59:13Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
PR: https://github.com/endojs/endo-but-for-bots/pull/306
Arc: unallocated
Milestone: M10

On promotion, first verify that the PR is still OPEN and not draft. If it has merged, closed, or gone draft, complete this job as a no-op. Otherwise run:

`scripts/jobs/post-gauntlet.sh --arc unallocated endojs-endo-but-for-bots-pr306-gauntlet-20261007 https://github.com/endojs/endo-but-for-bots/pull/306`

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-10T13:02:19Z
