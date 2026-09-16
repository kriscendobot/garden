---
tier: mentor
---
<!-- garden-promoted-from-plan: gate=deferred priority=normal at=2026-09-16T12:29:15Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Design/plan: migrate remaining agents to agentry; scuttle the lal providers

Maintainer directive bundled with the APPROVED review on
endojs/endo-but-for-bots PR #89 (kriskowal,
https://github.com/endojs/endo-but-for-bots/pull/89#pullrequestreview-5037708934):

> Post a planned job to migrate the remaining agents to use agentry and
> scuttle the lal providers.

Scope to work out when promoted:
- Inventory the agents in endojs/endo-but-for-bots that do NOT yet use
  @endo/agentry, and the "lal" providers still in use.
- Migrate each remaining agent onto agentry.
- Remove ("scuttle") the lal providers once nothing depends on them.

Repo: endojs/endo-but-for-bots @ `llm`. Parked pending maintainer promotion.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-16T12:29:24Z
