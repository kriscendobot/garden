I applied part of the round-1 panel fixes on PR #1124 and pushed them, and CI is green. I deliberately did not apply the decomplector seat's must-fix and sent it to you as a design question.

**What changed.** One follow-up commit, `b20669cb4`, pushed to `kriscendobot:build/ocapn-nonce-locator-mechanism` (moving the head from `88ae06662`) with `safe-push-pr-head.sh`:
- **Must-fix (typist):** removed the inline `import()` type tags. In `packages/ocapn/index.js` the forwarded typedefs now use namespace `@import`s and keep their original names. In `src/client/index.js` I imported `SessionId` and use the bare name.
- **Must-fix (typist):** moved the `MakeSessionFormulaLocator` and `FormulaNonceLocator` types out of `formula-nonce-locator.js` into `packages/daemon/src/types.d.ts`. The `@returns` doc now says that `get` must be paired with `makeLocatorForSession`.
- **Breaker and assessor:** `prepareOcapn`'s `endSession` now ends only the session whose id matches its own `sessionId`. Before this, a late locator abort could tear down a replacement session the same peer had just opened.
- **Purist and locksmith:** the session context and `abortSession` are now hardened before they go to embedder code.
- **Spec-keeper:** the step that names a caught error's class for the log can no longer throw. Before, a hostile thrown value could make the lookup fail with an error the peer could tell apart from a normal miss, and the miss would not be counted. A new test covers this case.
- **Smaller fixes:**
  - `missBound` is checked with `Number.isInteger` instead of `Number.isSafeInteger`.
  - The endpoint test imports the public `@endo/daemon/formula-nonce-locator.js` path.
  - "is the seam" is reworded (thesaurus seat).
  - "engine-dependent" became "microtask" (spec-keeper).

**Verification.** The two daemon locator test files pass (20 tests), `@endo/ocapn` passes 559 tests, `tsc` is clean for both packages, and prettier is clean. ESLint shows no errors, only warnings that were already there. PR CI finished green: 33 checks, 0 failed (`ci-wait-merge` exit 0).

**Not done — decision needed from you:**
- **Decomplector must-fix, not applied:** it asks to remove the per-session miss bound and the `makeLocatorForSession` hook. Your messages say nothing about the bound, so it looks like the builder added it, and five earlier panel rounds hardened it. PR #1333 builds directly on that hook, so removing it is a scope decision. I asked you through the liaison whether incoming `bootstrap.fetch` should have a per-session miss bound at all. Panel-2 will probably raise it again until you decide.

**Should-fix items left open:**
- Regroup the commits into logical ones (integrator).
- Shorten the long JSDoc and the design blockquote (pruner).
- Add an allowlist that limits which formulas can be fetched over the network, and make wiring `get` alone as the incoming locator impossible rather than just documented (locksmith, purist).
- Add a regression test for the stale-abort/replacement-session race (breaker).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1124-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 88 tokens (4168932 cached reads)
- Output: 20477 tokens
- Cost: $2.1302544
- Wall-clock: 2063s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
