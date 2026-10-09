Fix round 6 for kriscendobot/minion.town#166 is pushed and CI is green. I fixed both must-fix items from the round-6 panel; the should-fix items are still open.

**Must-fix**
1. **decomplector (fixed):** I removed the hand-written header checker from `deploy/probe/prod-objectives.mjs`. That deletes `parseCsp`, `ISOLATION_FLOOR`, `TIGHTENING_DIRECTIVES`, `NARROW_SOURCES`, `CASE_INSENSITIVE_HEADERS`, `sourceSet`, `cacheDirectives`, `HARD_CACHE_MAX_AGE` and the `default-src` throw that ran on import.
   - `isolationViolations` now checks that each response header exactly equals its value in `ISOLATION_HEADERS`. It still flags a cookie or an `Access-Control-Allow-Origin` header.
   - `hardCacheViolations` now requires `cache-control === IMMUTABLE_CACHE` and `etag === "<sha>"`.
2. **wire-watcher (fixed by item 1):** the CSP parser that mishandled U+00A0 is gone, so that bug no longer exists.

**Tests:** in `prod-objectives.test.mjs` I dropped the tests for the tolerances the old checker allowed. The new tests cover:
- the exact headers pass;
- a missing header, a changed value, or a value with a leading U+00A0 each fail;
- a second CSP added downstream fails;
- a cookie or CORS header fails;
- an ETag or Cache-Control that differs from the expected value fails.

All 16 tests pass with `node --test`.

**Push and CI:** commit `1f84e58` went to the PR head with `safe-push-pr-head.sh`, moving it from `4353d0b`. `ci-wait-merge.sh --no-merge` returned 0 with 3 checks and none failed. I didn't confirm those checks ran against `1f84e58` itself, and 3 is a small number.

**Not done in this round:**
- **Prettier:** it reports formatting issues in both probe files. The file was already failing that check before my change, and CI is green.
- **locksmith:** the probe's client secret should move into a GitHub Environment that only the default branch can use, with `environment:` added to the probe job.
- **pruner:** the documentation cuts it listed.
- **saboteur:** the uncredentialed probe run cited as evidence needs re-running at the current head before merge.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr166-gauntlet-20261008-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (577604 cached reads)
- Output: 5804 tokens
- Cost: $0.6906648
- Wall-clock: 64s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
