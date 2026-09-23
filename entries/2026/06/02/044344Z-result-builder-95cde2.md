---
ts: 2026-06-02T04:43:44Z
kind: result
role: builder
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 379
    role: target
refs:
  - entries/2026/06/02/043000Z-dispatch-steward-0f7ad5.md
  - https://github.com/endojs/endo-but-for-bots/pull/379
---

# result: builder #379 CommonJS reexporter parity test rework

Restructured the new CommonJS reexporter test per kriskowal's
CHANGES_REQUESTED feedback. The work resolves all three inline comments
(ids r3338677487, r3338682426, r3338685696) by reframing test prose,
adding shared-fixture parity infrastructure for the agreement case, and
adding a divergence parity pair that programmatically verifies Node's
ERR_REQUIRE_CYCLE_MODULE rejection.

## Head and commits

Pushed three commits to `endojs/endo-but-for-bots:fix/issue-59-star-export-cycle`.
New head: `4d4953dcbdc0b4c6f7b9961f1dcbde6e017c6bcb` (regular append, no
force).

1. `f89afdb7817eb532495600b063fb170d77213def`
   `test(compartment-mapper): cyclic CommonJS reexporter parity fixture + tests (#59 follow-up)`
   - Added `packages/compartment-mapper/test/fixtures-cycle-cjs-reexporter/node_modules/app/package.json`
   - Added `packages/compartment-mapper/test/fixtures-cycle-cjs-reexporter/node_modules/app/main.js`
   - Added `packages/compartment-mapper/test/fixtures-cycle-cjs-reexporter/node_modules/app/star-reexporter.cjs`
   - Added `packages/compartment-mapper/test/fixtures-cycle-cjs-reexporter/node_modules/app/export-renamer.cjs`
   - Added `packages/compartment-mapper/test/_cycle-cjs-reexporter-assertions.js`
   - Added `packages/compartment-mapper/test/cycle-cjs-reexporter.test.js`
   - Added `packages/compartment-mapper/test/cycle-cjs-reexporter-node-parity.test.js`

2. `340479b2ee51c1ff2bd4a2ac7af3080b4053372f`
   `test(compartment-mapper): ESM-in-CJS-cycle divergence parity test (#59 follow-up)`
   - Added `packages/compartment-mapper/test/fixtures-cycle-esm-in-cjs/node_modules/app/package.json`
   - Added `packages/compartment-mapper/test/fixtures-cycle-esm-in-cjs/node_modules/app/main.mjs`
   - Added `packages/compartment-mapper/test/fixtures-cycle-esm-in-cjs/node_modules/app/bridge.cjs`
   - Added `packages/compartment-mapper/test/fixtures-cycle-esm-in-cjs/node_modules/app/peer.mjs`
   - Added `packages/compartment-mapper/test/cycle-esm-in-cjs.test.js`
   - Added `packages/compartment-mapper/test/cycle-esm-in-cjs-node-parity.test.js`

3. `4d4953dcbdc0b4c6f7b9961f1dcbde6e017c6bcb`
   `test(ses): reframe cyclic CJS reexporter test prose; reference compartment-mapper parity`
   - Modified `packages/ses/test/import-cjs.test.js`
   - Modified `packages/ses/test/import-gauntlet.test.js`

## Part C choice: reframe (keep in-process SES regression)

I kept the in-process SES regression in `packages/ses/test/import-cjs.test.js`
and reframed its JSDoc rather than relocating the test to the
compartment-mapper parity suite. Rationale:

- The in-process test exercises the `Compartment` API directly with
  inline `ModuleSource` and `CjsModuleSource` virtual sources, hitting
  the module-instance linker path on a surface the compartment-mapper
  scaffold does not cover. The compartment-mapper tests go through
  `loadLocation` / `mapNodeModules` / `importFromMap` / archives, which
  is broader machinery but the linker entry point is reached
  differently. Removing the SES-side test would lose direct linker
  coverage for the ESM-in-CJS-cycle shape.
- The parity claim is now substantiated by the new compartment-mapper
  parity suite, which the SES test prose now references explicitly.
  The two layers form a complete picture: the SES test pins the
  in-process linker behavior, the compartment-mapper tests pin the
  Node parity (where parity holds) and the divergence (where it does
  not).

I also reframed the JSDoc on `packages/ses/test/import-gauntlet.test.js`
for the `'cyclic star export with renaming reexport, unused live binding'`
test, dropping the procedural "verified directly with `node`" prose
while preserving the parity claim. The leading test at line 242 already
referenced the compartment-mapper cycle-rename parity tests; I left it
unchanged.

## Verification

All four verification gates from the dispatch pass:

- `cd packages/compartment-mapper && yarn test` → 918 tests passed,
  6 known failures (pre-existing).
- `cd packages/ses && yarn test` → 504 tests passed, 2 known failures
  (pre-existing), 2 skipped.
- `yarn build:types:check` → `All composite tsconfig files are up to date.`
- `git grep -n -E 'Naugtur asked|builder verified directly|verified directly with .node.'`
  → no matches (exit 1).

The new tests:

- `cycle-cjs-reexporter` SES scaffold: 11/11 variants pass.
- `cycle-cjs-reexporter-node-parity`: 1/1 passes.
- `cycle-esm-in-cjs` SES scaffold: 11/11 variants pass.
- `cycle-esm-in-cjs-node-parity`: 1/1 passes (asserts Node exits
  nonzero with `ERR_REQUIRE_CYCLE_MODULE` in stderr, via
  `child_process.spawnSync`).

Lint clean on `compartment-mapper`. SES lint surfaces a pre-existing
`dist/types.d.cts` duplicate-identifier error unrelated to this work
(reproduced on the parent commit before any of my changes).

## Fixture topologies

Part A (parity, pure-CJS):
- `star-reexporter.cjs`: `Object.assign(exports, require('./export-renamer.cjs'))`
  (the CJS analog of `export *`, eager property copy).
- `export-renamer.cjs`: defines `x` as a live getter onto its own `y`
  via `Object.defineProperty`, then `exports.y = 45`. The cyclic
  `require('./star-reexporter.cjs')` at the top reads the partial
  exports.
- `main.js`: requires both, asserts captured=45 and both namespaces
  project `{ x: 45, y: 45 }`.

Part B (divergence, ESM-in-CJS-cycle):
- `main.mjs`: `import * as bridge from './bridge.cjs'`.
- `bridge.cjs`: `const m = require('./peer.mjs'); exports.value = m.value`.
- `peer.mjs`: `import { value as bridgeValue } from './bridge.cjs'; export const value = 42`.
- Node throws `ERR_REQUIRE_CYCLE_MODULE`; SES allows it and projects
  `bridgeValue === 42`. I deliberately picked this minimal topology
  rather than the original star-export topology because Node v22.22.2
  crashes hard (V8 `Check failed: module_status == kLinked || ...`)
  on the more complex star-export-with-renaming shape, which produces
  a useless parity assertion. The minimal cycle throws the clean
  `ERR_REQUIRE_CYCLE_MODULE` we want to pin.

## PR comment IDs

I did not reply on the review threads. Per the dispatch's
"Not authorized" list, the steward resolves the threads after this
result. The three threads kriskowal opened:

- r3338677487 (line 295 on `import-gauntlet.test.js`): reframe prose,
  add shared-fixture parity.
- r3338682426 (line 676 on `import-cjs.test.js`): SES vs Node
  divergence should be stated and verified programmatically.
- r3338685696 (line 682 on `import-cjs.test.js`): parity claims need
  parity tests; inform the gardener about the parity-test concept.

The last sub-item (informing the gardener about the parity-test
concept) is the steward's responsibility per the dispatch's note that
"the steward handles that via a separate message-to-gardener."

Self-improvement: nothing this time.
