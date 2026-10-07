---
gate: deferred
priority: normal
arc: minion-town-mcp-ocapn
posted_by: producer
posted_at: 2026-10-07T16:36:42Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
PR: https://github.com/kriscendobot/minion.town/pull/94
Arc: minion-town-mcp-ocapn
Milestone: -

On promotion, first verify that the PR is still OPEN and not draft. If it has merged, closed, or gone draft, complete this job as a no-op. Otherwise run:

`scripts/jobs/post-gauntlet.sh --arc minion-town-mcp-ocapn kriscendobot-minion.town-pr94-gauntlet-20261007 https://github.com/kriscendobot/minion.town/pull/94`
