---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Fix the § 4 app-compatibility key on kriscendobot/minion.town#147

Maintainer (kriskowal, 2026-10-04): "Go ahead and merge anything that is ready on the minion.town repository." This PR becomes merge-ready after one named fix (panel summary minion-town-pr147-panel-summary-20261004).

https://github.com/kriscendobot/minion.town/pull/147 (design: MCP resources + getting-started guide). Fix round 6 introduced a defect in § 4 "App compatibility": the rule checks git diff --quiet A R -- src/ with R = "the newest main commit that touched resources/" and claims a forward deploy-app.sh "has R = A and passes by construction". That is false whenever an app release changes src/ without touching resources/, so ordinary forward deploys would log a spurious skew warning. Key the check on the commit each copy was cut from (A for app deploys). One paragraph; one commit via safe-push-pr-head.sh. No new gauntlet. Do not touch the § 9 open questions (maintainer decisions). Report the commit; the merge waits on the maintainer approval.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-04T05:02:34Z
