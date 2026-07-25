In `kriscendobot/test262` on branch `proposal-compartments`, fix the fixture-path defect: rewrite `./fixtures/` → `../fixtures/` in the affected imports (the `consolidate-`/test262 front) so the jsc/xs/endor fronts don't each rediscover it.

<!-- garden-reaped: 1 -->
