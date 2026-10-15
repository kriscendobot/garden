---
role: conductor
handler-budget-role: conductor
dispatch: automatic
tier: mentor
fallback-tier: minion
---

Conduct https://github.com/endojs/endo-but-for-bots/pull/1460: the trusted maintainer approval at https://github.com/endojs/endo-but-for-bots/pull/1460#pullrequestreview-5527435260 explicitly says "please conduct". Un-draft the PR if it is still draft, then merge it after independently confirming the effective approval, mergeability, and green checks through the conductor spine. This is a bot repository; the authorization covers the lifecycle action. Do not complete while CI is pending; verify the final PR state.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-15T02:53:17Z
