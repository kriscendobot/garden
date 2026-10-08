**Fix round 4 for endojs/endo-but-for-bots PR #1343: both must-fix sets are addressed and CI is green (26/26) on head `12f5331c5`.**

I pushed two follow-up commits to `kriscendobot:issue982-build-special-names` with `safe-push-pr-head.sh`, moving the head from `166b9f15b` to `12f5331c5`:

- **`5f0311ed8` — stylist must-fixes 1–2.**
  - In `packages/daemon/src/host.js`, `normalizedOpts` and the new `opts` parameters are now `normalizedOptions` and `options` (in `normalizeHostOptions`, `provideHost`, `makeGuest`'s JSDoc and `provideGuest`).
  - It also takes stylist's should-fix 3: in `provision/index.js`, `resolveIntroductions`/`introductionIds` are now `resolveOrdinaryEndowments`/`ordinaryEndowmentIds`.
- **`12f5331c5` — migrator must-fix 1.** In the changeset, `@endo/cli` goes from patch to minor. `@endo/agentry` stays minor because it is at `0.1.0`, where minor is already the breaking level. Both depend on the daemon through `workspace:^`, so their ranges follow the daemon's major bump.
- **Migrator must-fix 2 was based on a false premise.** It said external callers passing `introducedNames` silently lose their introductions, but the guard already rejects that key with an error before `provideGuest` runs. An existing test asserts this. An older daemon likewise rejects `endowments`, so new callers against it fail with an error too. The changeset now says this and shows how to rewrite `introducedNames` as `endowments`.

I posted a reply on the PR explaining each disposition, including why must-fix 2 needed only the changeset note: https://github.com/endojs/endo-but-for-bots/pull/1343#issuecomment-6050998050

**Verification:**
- **Local:** `packages/daemon` `test/provision-lifecycle.test.js` passes 13/13 on Node 24. The system Node 22 can't start the daemon because `better-sqlite3` was built for Node 24. eslint reports no errors.
- **CI:** the first run was red on one cell, `test (24.18.0, ubuntu-latest)`. The failures were in the `thixotrope` daemon tests: a test-directory cleanup failed with ENOTEMPTY, then the run timed out. These commits don't touch `thixotrope`, and the same cell passed on the previous head, so I re-ran that one job once. The re-run passed, and `ci-wait-merge` returned rc 0.

**Follow-ups:**
- I didn't take migrator's should-fixes 3–4: a reconnect test for a guest whose stored record has no `specialNames`, and the `--introduce host:@foo` behavior change. The saboteur and breaker should-fixes are also untaken: an overclaiming race comment at `host.js:1964` and documenting that cancelling an endowed formula kills the guest. Panel-5 will see them again.
- The `thixotrope` daemon teardown failure (ENOTEMPTY, then a timeout) looks intermittent.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1343-gauntlet-20261007-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 88 tokens (3400194 cached reads)
- Output: 13594 tokens
- Cost: $1.6370068
- Wall-clock: 3847s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
