---
ts: 2026-05-20T22:05:49Z
kind: result
role: builder
project: endo
refs:
  - entries/2026/05/20/051910Z-result-liaison-90f5ea.md
---

# Result: builder 8e2aba — endojs/endo#59 reproduces, fix landed on `fix/issue-59-star-export-cycle`

## Verification: the defect reproduces against modern endo

Reproducer (the issue's three-file pattern, ported to a Compartment + makeNodeImporter harness):

- `mod1.js`: `export * from './mod2.js';`
- `mod2.js`: `export { y as x } from './mod1.js'; export var y = 45;`
- `main.js`: `import { x } from './mod1.js';`

Against `upstream-master = ec3dcbc0c`, `compartment.import('./main.js')` rejects with `TypeError: notify is not a function` at `wireUpExportNotifier` (`packages/ses/src/module-instance.js:364`). The 2019 report observed a `SyntaxError: does not provide an export named 'y'`; the underlying defect (the cycle's back-edge wires a reexport before the upstream's notifier exists) is the same. The crash flavor moved when `e8dbc77e0` ("wire up live bindings for reexports early ...") tightened the wire-up path without considering the star-import case where the upstream notifier is filled later by candidate-all.

## Fix

Single-file change, local to `wireUpExportNotifier`. When a reexport's upstream notifier is undefined at wire-up time (a star-export cycle's back-edge), install a forwarding notifier that queues subscribers and resolves through `mapGet(importedInstances, specifier).notifiers[localName]` on first invocation. By the time any downstream module subscribes, the upstream's own candidate-all walk has populated the notifier; the queue drains and pipes through.

Diff: `packages/ses/src/module-instance.js` (+44 / -16 around `wireUpExportNotifier` and one call site).

## Test

`packages/ses/test/import-gauntlet.test.js` gains `cyclic star export with renaming reexport (issue #59)`, exercising the exact reproducer and asserting both the imported binding (`captured === 45`) and the namespace shape of both cyclic modules (`{x: 45, y: 45}`).

Regression-test note (per `skills/regression-evidence/SKILL.md`):

1. Stashed both files; restored only the test. `yarn ava test/import-gauntlet.test.js --match '*issue #59*'` failed with `TypeError: notify is not a function` at the original line 364.
2. Restored the fix from stash. The same test passed alongside the 14 pre-existing gauntlet tests + 1 known failure.
3. Full `packages/ses` suite: 502 passed, 2 known failures, 2 skipped (all pre-existing).
4. `packages/module-source` suite: 53 passed.
5. `packages/compartment-mapper` suite: 882 passed, 6 known failures (all pre-existing).

## Branch and commit

- Branch: `fix/issue-59-star-export-cycle` on `kriscendobot/endo`.
- Head SHA: `461c392dc`.
- Author + Committer: `endolinbot <main.barn5084@fastmail.com>` (bot identity per the dispatch host).
- Subject: `fix(ses): resolve cyclic star-export reexport rename (#59)`.
- Changeset: `.changeset/fix-ses-star-export-cycle-rename.md` (`'ses': patch`).

## PR-create attempt

`gh pr create --repo endojs/endo --base master --head kriscendobot:fix/issue-59-star-export-cycle --draft` failed with the documented cross-fork permission block:

> GraphQL: kriscendobot does not have the correct permissions to execute `CreatePullRequest` (createPullRequest)

Expected per `entries/2026/05/20/051910Z-result-liaison-90f5ea.md`. Compare URL for maintainer or boatman ferry:

`https://github.com/endojs/endo/compare/master...kriscendobot:endo:fix/issue-59-star-export-cycle?expand=1`

## Pre-push gate

`pre-push-gates.sh --probes-only` against the project worktree: all probes pass except `security-md-hash-uniform`, which fails on pre-existing divergent SECURITY.md files in `packages/immutable-arraybuffer`, `packages/bytes`, `packages/hex`, `packages/panic`. Unrelated to this diff; surfacing for project-meta awareness.

`yarn lint:eslint` in `packages/ses`: one pre-existing warning (`compartment.js:340` missing `@param`). `yarn lint:types`: pre-existing `Duplicate identifier 'Compartment'` in `dist/types.d.cts` and `types.d.ts:549`. `prettier --check` on the two changed files: clean.

## Out-of-scope notes

- Did not investigate whether the change interacts with `module-source/test/hardened-module-source.test.js` reexport fixtures beyond what the gauntlet exercises; module-source's own suite is green.
- Did not propose changes to `babel-plugin.js` or the analyzer; the defect is purely linker-side.
- Did not run the full repo `yarn test`; per-package suites touching the cycle (`ses`, `module-source`, `compartment-mapper`) all pass.

Self-improvement: nothing this time.
