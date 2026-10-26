---
handler-timeout: 7200
tier: mentor
fallback-tier: minion
dispatch: automatic
---

In the garden's own repo (kriscendobot/garden, `main2`), harden `scripts/jobs/ci-wait-merge.sh`. It reported GREEN on endojs/endo-but-for-bots PR https://github.com/endojs/endo-but-for-bots/pull/1559 while a workflow run was still queued and not yet attached to the head SHA's checks. Add a guard that waits for every workflow run on the head SHA to attach before declaring green. First check whether the recent head-gate commit daaa3d299a4 already covers this, and add a regression test if it doesn't.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-26T02:09:04Z
