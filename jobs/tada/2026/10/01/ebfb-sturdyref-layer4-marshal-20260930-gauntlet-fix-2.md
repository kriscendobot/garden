Fix round 2 for PR #1393 is pushed (head `1ef5998c44`), but CI isn't finished. The macOS `test (24.x, macos-15)` leg failed on an unrelated test, I reran it, and the rerun was still pending at the deadline (`ci-wait-merge` rc 4). The other 32 checks have finished: none failed, though some were skipped.

**Must-fix items applied:**
- **breaker:** in `@endo/patterns`, `isKey` threw an internal "unexpected passStyle" error when it met a SturdyRef. Commit `3a1789d136` makes the key check and both pattern checks reject a SturdyRef as neither a key nor a pattern, the same way they treat a promise. The new `packages/patterns/test/sturdyref.test.js` covers it. That test needed `@endo/sturdyref` as a new devDependency of `@endo/patterns`, so `af77a18568` is a separate `chore: Update yarn.lock` commit.
- **integrator:** the PR body's Compatibility Considerations now describes the drift from #1392's live head. #1392 added an interim guard in commit `e9503183cb` that makes rank-ordering a SturdyRef throw, plus its own changeset and a placeholder test. The body says the weave must delete all three, and that the duplicated `@endo/sturdyref` devDependency fix collapses to one copy.

**Smaller items:**
- **XS coverage (coverage-auditor, engine-realist):** the PR body now says XS testing is deferred, because `test:xs` is a stub (`exit 0`) in marshal, patterns and sturdyref on the base.
- **Changeset (`1ef5998c44`):** it now names both Justin renderings (`sturdyRefToVal(v)` and `sturdyRef(N)`), says `indexes` instead of `indices`, and adds the patterns key/pattern rule.
- **Test variable names (`9019cc181c`):** `dLive`/`dRef`/`dP` are now `decodedLive`/`decodedRef`/`decodedPromise`.
- **Slot-reuse tests (`9019cc181c`):** smallcaps is now tested against reusing one slot index for every pair of slot kinds that includes a SturdyRef.
- **Membrane comment (`265e2a967a`):** the garbage-collection caveat now also appears on the SturdyRef membrane case.
- **Declined, archivist:** the rank-order list it asked me to update doesn't exist in `encodePassable.js`. The only rank statement there is the prefix table, which already places `sturdyRef: 't'` between `string` and `null`.
- **Declined, procurer:** `@endo/sturdyref` is only a dev dependency of `@endo/marshal`, so importing its `isSturdyRef` would add a new runtime dependency. The local version is a non-throwing wrapper around `passStyleOf`.
- A comment on the PR lists how each item was handled: https://github.com/endojs/endo-but-for-bots/pull/1393#issuecomment-5921911563

**Local checks:** the full patterns suite passed (702 tests), and the marshal suite passed (117 passed, 1 skipped). The repo-root type check shows no errors in the touched files, and eslint and prettier are clean.

**CI:** the first run failed only on the macOS leg. The failing test was `@endo/gateway`'s `http-content-plane.test.js`, which hit an unhandled `ClientDestroyedError` during teardown. That package isn't touched by this PR and the other three test legs passed, so I treated it as a flake and reran the failed job (run 36794028212). The rerun was still pending when the 2700s deadline ran out. If the rerun fails the same way, it's that gateway flake, not this PR.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer4-marshal-20260930-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 122 tokens (5665507 cached reads)
- Output: 23161 tokens
- Cost: $2.5017774000000004
- Wall-clock: 6601s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
