---
ts: 2026-05-20T22:06:59Z
kind: result
role: liaison
project: endo
to: maintainer
dispatch: 214952Z-dispatch-liaison-8e2aba
---

# Result: builder 8e2aba — endojs/endo#59 verified, fixed, pushed (cross-fork PR-create blocked)

Builder dispatch `8e2aba` complete. **Defect reproduces and is fixed.** Branch `fix/issue-59-star-export-cycle` pushed to `kriscendobot/endo` at `461c392dc`. Self-report at `journal/entries/2026/05/20/220549Z-result-builder-8e2aba.md`.

Compare URL for maintainer ferry (cross-fork PR-create blocked as documented):

  [https://github.com/endojs/endo/compare/master...kriscendobot:endo:fix/issue-59-star-export-cycle?expand=1](https://github.com/endojs/endo/compare/master...kriscendobot:endo:fix/issue-59-star-export-cycle?expand=1)

## Verification

The exact 2019 three-file scenario reproduces on master `ec3dcbc0`:

- `mod1.js` — `export * from './mod2.js';`
- `mod2.js` — `export { y as x } from './mod1.js'; export var y = 45;`
- `main.js` — `import { x } from './mod1.js'`

Surface crash today: `TypeError: notify is not a function` at `packages/ses/src/module-instance.js:364`. The 2019 report observed `SyntaxError: does not provide an export named 'y'`. The underlying defect is identical; the crash flavor moved when `e8dbc77e0` tightened the wire-up path without considering the star-export cycle case where the upstream notifier fills in later via candidate-all.

## Root cause

`mod2`'s `export { y as x } from './mod1.js'` wires the reexport during `mod2.imports()`, but at that moment `mod1.notifiers['y']` is `undefined` because `mod1`'s `y` notifier only materializes later during `mod1`'s candidate-all walk over `mod2`. Passing `undefined` as `notify` to `wireUpExportNotifier` then crashes at `notify(update)`.

## Fix

In `packages/ses/src/module-instance.js`, when `wireUpExportNotifier` is called for a reexport whose upstream notifier is `undefined`, install a *deferred forwarding notifier* that queues subscribers until the upstream resolves (looked up through `mapGet(importedInstances, specifier).notifiers[localName]` on first invocation). The queue drains and pipes subscribers to the upstream once available. Genuine missing exports still raise `SyntaxError` from the deferred lookup, preserving the diagnostic.

## Regression coverage

`packages/ses/test/import-gauntlet.test.js` gains `cyclic star export with renaming reexport (issue #59)`. Without the fix, the test fails with the exact `TypeError`. With the fix it passes alongside the 14 pre-existing gauntlet tests.

## Wider verification

`ses` 502 passed. `module-source` 53 passed. `compartment-mapper` 882 passed. Pre-existing known-failures unchanged. Changeset added (`'ses': patch`).

## Next step

Maintainer ferry needed to open the upstream PR. Once open, the gamut's downstream stages (cleaner / judge / fixer / un-draft) can be dispatched by the liaison.

## Teardown

Dispatch root `/home/kris/dispatches/builder--8e2aba/` torn down by the liaison after this entry lands.
