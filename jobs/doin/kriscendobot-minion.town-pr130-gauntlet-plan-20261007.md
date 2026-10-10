---
tier: mentor
arc: minion-town-mcp-ocapn
---
<!-- garden-promoted-from-plan: gate=deferred priority=normal at=2026-10-10T03:45:40Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
PR: https://github.com/kriscendobot/minion.town/pull/130
Arc: minion-town-mcp-ocapn
Milestone: -

On promotion, first verify that the PR is still OPEN and not draft. If it has merged, closed, or gone draft, complete this job as a no-op. Otherwise run:

`scripts/jobs/post-gauntlet.sh --arc minion-town-mcp-ocapn kriscendobot-minion.town-pr130-gauntlet-20261007 https://github.com/kriscendobot/minion.town/pull/130`

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-10T04:17:13Z
