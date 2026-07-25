In `kriscendobot/test262` on branch `proposal-compartments`, fix the fixture-path defect: rewrite `./fixtures/` → `../fixtures/` in the affected imports (the `consolidate-`/test262 front) so the jsc/xs/endor fronts don't each rediscover it.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: hermit
  claimed_at: 2026-07-25T19:08:30Z
