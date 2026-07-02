# fixer on endojs/endo-but-for-bots PR #438 (tsgo migration) — residual CI red after shepherd

A shepherd (job endojs-endo-but-for-bots-pr438-shepherd) drove what it could to green and
escalated the rest. PR: https://github.com/endojs/endo-but-for-bots/pull/438
Head branch: chore/tsgo-lint-types. Base: frozen master-4a04d07 (live master is green).

## Already fixed by the shepherd (pushed to head, commit 368e9974e)
- **test / cover** (`test (22.x|24.x, ubuntu|macos)`, `cover`): evade-censor snapshot
  mismatch. Root cause: the tsgo sweep changed the evasive-transform test-location-unmapper
  fixtures' JSDoc `import('node:fs').constants.F_OK` -> `typeof import(...).F_OK`, which
  evadeCensor snapshots. Regenerated the snapshots (delta is only the benign
  `import`->`typeof import` censor text; all 32 tests pass). No further action needed here.

## Escalated — needs a fixer's judgment

### 1. E.js `@ts-expect-error` — irreconcilable tsc-6 vs tsgo divergence (blocks `lint`, `viable-release`)
`packages/eventual-send/src/E.js` lines 211/225/249 carry `// @ts-expect-error XXX typedef`
over the three `new Proxy(...)` E-proxy constructors.
- **tsgo REQUIRES them**: removing all three makes `tsgo` (per-package lint:types AND the
  unified typecheck-all) raise 3x TS2322 `Type 'object' is not assignable to type
  'ECallableOrMethods<RemoteFunctions<T>>'` (verified by removal experiment with the exact
  pinned `@typescript/native-preview@7.0.0-dev.20260612.1`).
- **tsc-6 REJECTS them as unused**: the prepack declaration-emit path run by
  `viable-release` (`yarn smoketest:publish`) raises `TS2578 Unused '@ts-expect-error'
  directive` at the same three lines. (The PR's harden/isPrimitive type-predicate fixes
  cascaded into E.js's Proxy inference so tsc-6 no longer errors there, leaving the
  directives unused under tsc while tsgo still needs them.)
- The directive cannot satisfy both checkers. Reconciliation options, each a design call:
  (a) Replace each `@ts-expect-error` with an explicit `/** @type {ECallableOrMethods<...>} */`
      cast on the `new Proxy(...)` expression (may need to route through `unknown`/`any`);
      a cast is accepted by both and is not "unused". This is the likely-cleanest fix but is
      genuine type-surgery on the public E proxy typedef (the long-standing `XXX typedef` gap)
      and must be verified against BOTH tsc-6 prepack AND tsgo, at all three sites, without
      regressing downstream inference.
  (b) `@ts-ignore` (does not warn when unused) — satisfies both but broadens the suppression.
  (c) Exclude E.js from one checker path.
  A shepherd should not unilaterally broaden suppression or exclude files; picking among
  (a)/(b)/(c) is the maintainer's routing decision that this DRAFT PR was opened to surface.

### 2. remotable.js TS2322 (reported by CI `lint`, did NOT reproduce locally)
CI `lint` reported `packages/pass-style/src/remotable.js` 221/223 TS2322 (`undefined`/`string`
not assignable to `T`). With the pinned tsgo, pass-style per-package AND typecheck-all pass
CLEAN locally (0 errors). Likely nightly-drift between the 06-24 CI run and the pinned lock,
or resolved by a sibling commit. Re-run CI after the E.js fix and confirm; if it recurs,
tighten `getInterfaceOf`'s generic return typing.

### 3. test-hermes / test-xs — runtime failures, likely BASE-DRIFT (recommend a weaver rebase first)
- `test-hermes`: `Uncaught TypeError: Cannot read property 'defineProperty' of undefined`.
- `test-xs`: `@endo/module-source` `ReferenceError: get Object: not initialized yet`.
These are RUNTIME failures on a types-only PR whose source deltas are inert JSDoc (the only
module-source change is an added `@this {{...}}` comment, which cannot affect runtime). Live
master is green on both; the PR's base is the frozen `master-4a04d07`. Strong signal these are
base-drift. **Recommend rebasing the branch onto current master (weaver) and re-running CI
before spending fixer effort here**; if they persist post-rebase, investigate the ses/hermes
bundle and the module-source XS init order.

## Suggested order
weaver (rebase onto current green master; may clear test-hermes/test-xs and remotable) →
fixer (E.js `@ts-expect-error` reconciliation; the substantive blocker) → shepherd (verify green).

Note: no PR comment was posted (the shepherd job carried no per-action external-repo comment
authorization).
