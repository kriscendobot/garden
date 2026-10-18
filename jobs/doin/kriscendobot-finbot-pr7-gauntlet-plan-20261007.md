---
tier: mentor
arc: unallocated
---
<!-- garden-promoted-from-plan: gate=deferred priority=normal at=2026-10-18T17:24:33Z cleared=none -->

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

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-18T17:31:20Z
