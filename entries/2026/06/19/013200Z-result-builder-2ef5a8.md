---
ts: 2026-06-19T01:32:00Z
kind: result
role: builder
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
worktree: dispatches/builder--2ef5a8/project
---

DRAFT PR #474 opened: refactor: retire function-keyword in favor of
arrow/method syntax per erights review.
URL: https://github.com/endojs/endo-but-for-bots/pull/474

## Substance per commit

1. `docs: design for retiring the function keyword` — new
   `designs/retire-function-keyword.md` enumerating motivation,
   conversion rules, legitimate exception categories, per-package
   scope table.
2. `refactor(promise-kit)`: `isPromise`.
3. `refactor(harden)`: inner `enqueue`.
4. `refactor(eventual-send)`: `postpone`; kept `baseHandledPromise`
   (documented constructor).
5. `refactor(trampoline)`: `syncTrampoline`, `asyncTrampoline`; kept
   `function* () {}` sentinel.
6. `refactor(import-bundle)`: `importBundle`,
   `wrapInescapableCompartment`; kept `function Compartment(...args)`
   constructor.
7. `refactor(cli)`: `prompt`.
8. `refactor(benchmark)`: `benchmark`, `assert`, `truthy`, `test`.
9. `refactor(evasive-transform)`: `evadeComment`, `evadeCensorSync`,
   `evadeCensor`, `transformAst`, `parseAst`.
10. `refactor(init)`: rewrote `AsyncLocalStorage.prototype` patches in
    `node-async-local-storage-patch.js` as concise methods on a
    `patches` object literal.
11. `refactor(bundle-source)`: `bundleZipBase64`, `bundleScript`;
    explicitly left demo files alone (they are bundler test inputs
    exercising various binding forms).
12. `refactor(zip)`: 21 sites across `signature`, `crc32`,
    `format-reader`, `format-writer`.
13. `refactor(ocapn)`: 19 sites across `syrup/decode`, `syrup/encode`,
    `syrup/compare`, `syrup/js-representation`. Skipped
    `client/ocapn.js`'s `serializeAndSendMessage` (module-init forward
    reference; flagged).
14. `refactor(module-source)`: `makeModulePlugins`, the named
    `createStaticRecord` expression, inner `curryImporter` /
    `makeImportExpr`; kept `ModuleSource` and `AbstractModuleSource`
    constructors and `function*` generators.
15. `refactor(compartment-mapper)`: `attenuateGlobalThis`,
    `attenuateVirtualModuleSource`, `attenuateModule`,
    `getImportsFromRecord`, `makeImportNowHookMaker`, two anonymous
    error-throwing arrows from named function expressions. Kept
    generators (`function*`), the TS-assertion function
    `assertModuleConfiguration`, and bundler runtime template strings.
16. `refactor(daemon)`: `formulateMarshalValue`; all other sites are
    `async function*` async-generators or `function*` generators
    (exception).
17. `refactor(eslint-plugin)`: 7 inner helpers across
    `no-assign-to-exported-let-var-or-function.js`,
    `no-polymorphic-call.js`, and one visitor handler in
    `harden-exports.js`. Skipped `assert-fail-as-throw.js` (vendored
    port from mysticatea/eslint-plugin-node that relies on hoisting
    for module-init `safeRequire(...)` calls).
18. `refactor(ses)`: 11 low-risk helpers across `scope-constants.js`,
    `transforms.js`, `intrinsics.js`, `module-link.js`,
    `module-instance.js` (inner `imports` and `execute`). Deferred ~45
    further SES sites in the lockdown path (`tame-*`, `enable-*`,
    `permits-intrinsics`, `error/*`) to a follow-up audit; each
    touches the security boundary and warrants per-file reasoning.
19. `docs(design)`: documented four new exception categories surfaced
    during conversion (sloppy-mode `this`, TS assertion functions,
    module-init forward references, bundler runtime template
    literals).
20. `style`: prettier touch-up on `benchmark.js` and
    `transform-analyze.js`.

## Per-package conversion counts

| Package               | Sites converted |
| --------------------- | --------------: |
| promise-kit           | 1 |
| harden                | 1 |
| eventual-send         | 1 |
| trampoline            | 2 |
| import-bundle         | 2 |
| cli                   | 1 |
| benchmark             | 4 |
| evasive-transform     | 5 |
| init                  | 4 |
| bundle-source         | 2 |
| zip                   | 21 |
| ocapn                 | 19 |
| module-source         | 4 |
| compartment-mapper    | 6 |
| daemon                | 1 |
| eslint-plugin         | 8 |
| ses                   | 11 |
| **Total**             | **~93** |

## Legitimate exceptions kept

- Constructor emulations: `PseudoTypedArray`, `baseHandledPromise`,
  the SES inert-constructor pattern (`InertConstructor` for
  `Function`, `Date`, `RegExp`, `Error`, `Symbol`), `ModuleSource`
  and `AbstractModuleSource`, the `NewCompartment = function
  Compartment(...args)` in import-bundle.
- Generator / async-generator function expressions: trampoline's
  sentinel, captp's `trapHost`, stream/syrup-frame/netstring async
  iterator makers, daemon's many `followX` async generators,
  compartment-mapper's `chooseModuleDescriptor` and `interpret*`
  family, src-xs's `getImports`/`getExports`/`getReexports`.
- Vendored / third-party-derived: `cjs-module-analyzer` (port of
  `es-module-lexer` with mutual recursion via hoisting),
  `test262-runner/test262` (tc39 corpus under separate license).

## New exception categories flagged for erights

Surfaced during conversion and now documented in the design file:

1. **Sloppy-mode `this` detection** (`ses/src/assert-sloppy-mode.js`):
   `function getThis() { return this; }` deliberately returns the
   calling-context `this`. Arrow `this` is lexical (module-scope
   `undefined`); converting would defeat the `SES_NO_SLOPPY` check.
2. **TypeScript assertion functions** (`asserts X is Y`): TS2775
   "Assertions require every name in the call target to be declared
   with an explicit type annotation" when the function is a const
   arrow. One site:
   `compartment-mapper/src/compartment-map.js`'s
   `assertModuleConfiguration`.
3. **Module-init forward references**: when a function is called by
   *name* during module top-level evaluation rather than from inside
   a deferred function body, converting the declaration to const puts
   the reference into TDZ. Concrete sites left as-is:
   - `captp/src/captp.js`: `convertValToSlot`, `convertSlotToVal`
     are passed to `makeMarshal(...)` during module init.
   - `ocapn/src/client/ocapn.js`: `serializeAndSendMessage` is
     passed into `makeOcapnCommsKit({...})` during module init.
   - `eslint-plugin/lib/rules/assert-fail-as-throw.js`: top-level
     `safeRequire(...)` calls precede `function safeRequire`'s
     declaration; the file is a vendored port with
     `/* eslint-disable no-use-before-define */` at the top.
4. **Bundler runtime template literals**: the `function` text inside
   `compartment-mapper/src/bundle-mjs.js` / `bundle-cjs.js`'s
   `runtime` template strings is bundler output, not module-side
   code.

These three plus the existing two are flagged in the PR body for
erights's guidance.

## Test results

Each per-package commit was preceded by `yarn workspace <pkg> test`
and `yarn workspace <pkg> lint`, all passing locally. Global
`yarn lint` ended clean after a prettier touch-up of two files.
SES specifically: 513 passing tests, 2 known failures, 2 skipped
(all pre-existing).

## PR number and URL

PR #474 (DRAFT) on `endojs/endo-but-for-bots`.
URL: https://github.com/endojs/endo-but-for-bots/pull/474

## Self-improvement

Two lessons worth noting for the builder role (folding into a
`message` to liaison would be appropriate):

1. The `model-selection` tier for "substantial multi-package
   refactor across ~24 packages with hundreds of conversion
   sites" is borderline; opus carried this dispatch but I made
   the call to defer ~45 SES sites in the lockdown path to keep
   the PR mechanically reviewable rather than push to the
   ceiling. A follow-up PR per file group is the right
   continuation shape.
2. The dispatch prompt's per-package commit cadence proved
   correct: every package was independently tested and pushed,
   so the budget exhaustion failure mode would have lost at most
   one in-progress package, not the whole engagement.

Self-improvement: when a multi-package refactor enumerates the
legitimate-exception list in the dispatch prompt, the prompt
should also enumerate the *forms of evidence that mark a site as
an exception* (uses `new.target`, returns `this`, has an
`asserts X is Y` JSDoc tag, etc.), so the builder can apply the
rule mechanically without a re-derivation per package. The form
"the dispatch enumerates the categories; the builder discovers
the per-site evidence" is what I did, and it worked, but a
concise evidence table in the prompt would have made the
per-file decisions faster.

## Recommended next stage

`next: cleaner` (gamut stage 1). The PR is DRAFT; the cleaner /
barrister / fixer-loop / un-draft chain should follow.
