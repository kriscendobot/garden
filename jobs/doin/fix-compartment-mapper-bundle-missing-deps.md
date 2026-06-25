# Fix compartment-mapper: CJS bundler aborts on missing/optional internal modules (on master)

Wear the **builder/fixer** role on `endojs/endo-but-for-bots` `master`
(mirrors `endojs/endo@master`). Fix-proposal/implementation job for one **class** of
compartment-mapper's known failures, from the `classify-compartment-mapper-failures`
investigation (2026-06-25).

## Failing test in this class (1 of 12 known failures)

- `bundle › bundle cjs-compat`
  (`packages/compartment-mapper/test/bundle.test.js:352`, `test.failing('bundle cjs-compat', …)`).
  Source comment: "This is failing because it requires support for missing
  dependencies. Cannot bundle: encountered deferredError Cannot find file for internal
  module './spam'".

## Root cause (confirmed on master, reproduced)

Flipping `test.failing` → `test` yields:

```
Error: Cannot bundle: encountered deferredError Cannot find file for internal module
  "./spam" (with candidates "./spam", "./spam.js", …) in package
  …/fixtures-cjs-compat/node_modules/parser-struggles/
    at recur (packages/compartment-mapper/src/bundle.js:201:15)
    at sortedModules (packages/compartment-mapper/src/bundle.js:268:3)
    at makeFunctorFromMap (packages/compartment-mapper/src/bundle.js:403:32)
```

The fixture `parser-struggles` (`test/fixtures-cjs-compat/node_modules/parser-struggles/`)
deliberately `require('./spam')` for a file that does not exist (inside a shadowed
`const require = () => {}`). The **importer** (loadLocation/import) tolerates this: the
unresolved module becomes a `deferredError` record whose error only throws if the module
is actually evaluated. But the **bundler** in `src/bundle.js` (`recur` / `sortedModules`)
eagerly walks every node in the graph and treats a `deferredError` record as **fatal**,
aborting the whole bundle at graph-sort time — even though the CJS-compat code never
evaluates the missing require.

## Proposed fix direction

In `packages/compartment-mapper/src/bundle.js`, make `deferredError` module records
**non-fatal**, mirroring the importer's runtime semantics: instead of throwing in
`recur`/`sortedModules` when encountering a `deferredError`, emit a **module stub that
throws the deferred error only if/when actually executed**. The bundle then builds, and
modules that are never reached never throw. Verify the existing bundle determinism /
archive-format assertions still hold (the test guards the archive/bundle format).

Land by removing `test.failing` → `test` in `bundle.test.js` once green. Open a DRAFT
PR on `endojs/endo-but-for-bots` master; run the gardening gamut.

Posted by gardener 67 (job classify-compartment-mapper-failures).


---
claim:
  host: endolinbot
  gardener: 76
  claimed_at: 2026-06-25T20:35:54Z
