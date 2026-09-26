Fixer work complete. My deliverable — the substantive E.js blocker — is fixed, verified locally against both checkers, and pushed; CI re-run is in flight and the base-drift items are handed to a weaver follow-up.

## Completion report

**Job:** fixer on endojs/endo-but-for-bots PR #438 (tsgo migration) — residual CI red after shepherd.

**What I did**

1. **Item #1 — E.js `@ts-expect-error` tsc-6/tsgo divergence (the substantive blocker): FIXED via option (a), the clean cast.** Replaced all three `// @ts-expect-error XXX typedef` directives over the `E` / `E.get` / `E.sendOnly` `new Proxy(...)` constructors in `packages/eventual-send/src/E.js` with explicit `/** @type {<declared-return>} */ ( /** @type {unknown} */ ( new Proxy(...) ) )` casts. The double cast (routed through `unknown`) is required because `Proxy<funcTarget|objTarget>` and the E proxy typedefs do not sufficiently overlap for a single cast. A cast satisfies both checkers where a directive cannot.

   **Verified locally** with the pinned `@typescript/native-preview@7.0.0-dev.20260612.1` and `typescript@6.0.3` (invoked via `node <store-path>` per the bin-shim sandbox constraint), all real runs with observed exit codes / error counts:
   - tsgo per-package `lint:types` on eventual-send: **exit 0, 0 errors**
   - tsgo whole-repo `typecheck-all` (`tsgo -p tsconfig.json`): **exit 0, 0 errors**
   - tsc-6 declaration emit on `tsconfig.build.json` (the `viable-release`→prepack path that raised TS2578): **exit 0, 0 errors**
   - eslint on `src/E.js`: **exit 0, clean**
   - Proved the divergence was real: `git stash` of the fix → tsc-6 decl emit raised exactly `TS2578` at lines 211/225/249; restored.

2. **Item #2 — remotable.js TS2322 (CI-only, did not reproduce): confirmed clean.** The whole-repo `typecheck-all` above includes `pass-style/src/remotable.js` and passed with 0 errors under the pinned lock — matching the shepherd's local finding. A fresh CI run should clear it.

3. **Item #3 — test-hermes / test-xs (base-drift):** left to a weaver as recommended. The frozen base `master-4a04d07` is **115 commits behind** live green master — genuine weaver-scope rebase, not fixer work.

**What changed / pushed**
- One commit `f75240084` on head branch `chore/tsgo-lint-types` (endojs/endo-but-for-bots), pushed as a CAS after confirming the remote had not moved. It is now the PR head; a fresh CI run (lint, viable-release, …) is pending.

**Follow-ups**
- Posted job **`endojs-endo-but-for-bots-pr438-weaver`**: rebase the head onto current master to clear the test-hermes/test-xs base-drift red, then chain to a shepherd to confirm green and an un-draft. Body records everything verified here.
- No PR comment posted (this fixer job carried no per-action external-repo comment authorization, same as the shepherd).

**Not claimed:** CI is still pending, so I have not observed CI-green; the "verified" claims above are all local real-execution evidence for the types portion only.
