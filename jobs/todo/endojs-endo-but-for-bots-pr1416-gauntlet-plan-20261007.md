---
tier: mentor
arc: minion-town-mcp-ocapn
---
<!-- garden-promoted-from-plan: gate=deferred priority=normal at=2026-10-07T19:09:28Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
PR: https://github.com/endojs/endo-but-for-bots/pull/1416
Arc: minion-town-mcp-ocapn
Milestone: -

On promotion, first verify that the PR is still OPEN and not draft. If it has merged, closed, or gone draft, complete this job as a no-op. Otherwise run:

`scripts/jobs/post-gauntlet.sh --arc minion-town-mcp-ocapn endojs-endo-but-for-bots-pr1416-gauntlet-20261007 https://github.com/endojs/endo-but-for-bots/pull/1416`
