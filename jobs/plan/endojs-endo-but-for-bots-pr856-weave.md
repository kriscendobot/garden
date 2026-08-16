---
gate: go-ahead
priority: normal
tier: minion
token-budget: 100000
doomed: true
doom_signature: requeue-exhausted
doom_count: 1
requeue_cycles: 5
deadline_overruns: 0
elapsed_constancy_confirmations: 0
doomed_at: 2026-08-16T07:33:03Z
doomed_on: endolin-garden2-5bcdff64
posted_by: reaper:endolin-garden2-5bcdff64
posted_at: 2026-08-16T07:33:03Z
---

---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
Weave (rebase) https://github.com/endojs/endo-but-for-bots/pull/856 (fix(endor): run ambiguous import-bearing .js entries as ESM) onto current llm.

State verified 2026-08-16: OPEN, non-draft, mergeStateStatus DIRTY, head ca0b6c023, untouched since 2026-07-28 though its own CI was 24/24 green. A re-review is requested from kriskowal but is not worth acting on until the conflict is resolved. Four separate maintainer-inbox messages asked for re-approval on a stale head; the rebase is the actual blocker.

After the rebase lands and CI is green, hand off for maintainer review.
