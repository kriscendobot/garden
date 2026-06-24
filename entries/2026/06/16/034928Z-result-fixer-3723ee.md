---
ts: 2026-06-16T03:49:28Z
kind: result
role: fixer
repo: kriscendobot/agoric-sdk
project: agoric-sdk
refs:
  - entries/2026/06/16/030805Z-result-fixer-d8a32b.md
---

# Fixer: Class D regression on PR #5 (lint-primary after absorb)

OODA loop cycle on `kriscendobot/agoric-sdk#5` per `skills/ci-failure-classification-loop/SKILL.md`. The prior fixer d8a32b's absorb of upstream Agoric#12734 (3 commits 3a6be3fa1b + aee8f7a92c + edf76d44cb) flipped previously-green lint-primary and lint-rest jobs to red and cascaded to many test-* jobs via fail-fast.

## Pre / post

- Pre HEAD: `edf76d44cba8fec2b253169859cf67e8a42408cf` (chore: Update yarn.lock; tip of absorb)
- Post HEAD: `509f34b0d04f7c01b1b6b21a83e74d8a4b1ec70d` (fix(vats): reorder imports per import/first after absorb)
- Two commits pushed (append, no force):
  - `460617f92f` fix(swingset-runner): adopt upstream Agoric#12734 slogulator readline replacement
  - `509f34b0d0` fix(vats): reorder imports per import/first after absorb

## Per-regression classification

Failing CI rollup at `edf76d44cb` (run 27591352979):

| Class | Job | Signature | Disposition |
| --- | --- | --- | --- |
| D | lint-primary | n-readlines missing from swingset-runner/package.json; 4× import/first in vats/src/types.ts | fixed this cycle |
| D | lint-rest | same lint regressions | fixed by same commits |
| A | test-dapp (node-new) | docs dapp endo skew | skip (maintainer-authorized 2026-06-15) |
| C/cascade | test-quick (node-old), test-quick2 (node-new), test-portfolio-contract (node-old), test-solo (node-old), test-cosmic-swingset (node-old), test-inter-protocol (node-old), test-swingset (node-old, 2, 5) | likely fail-fast cascade from lint-primary; sampled test-quick (node-old) output showed runtime test work in progress when killed | re-observe after this cycle |
| cascade | many test-* CANCELLED jobs | fail-fast cancellation when lint-primary failed | re-observe |

## Root cause

Two parallel introductions in d8a32b's absorb:

1. **swingset-runner**: absorbed upstream's `package.json` (dropped `n-readlines`, dropped Node 20 from engines, bumped Endo deps) but missed taking the matching `slogulator.js` refactor (n-readlines → node:readline, sync → async main).
2. **vats/src/types.ts**: replaced the `@agoric/orchestration` `CaipChainId` import with a local type alias and explanatory comment, but placed it mid-import-group, violating import/first.

## Fixes

1. `460617f92f` — adopted upstream's `slogulator.js`, `slogulator-entrypoint.js`, `slogulator-debug-entrypoint.js` wholesale (per the absorb directive "favoring solutions pursued there"). The entrypoints needed updating because upstream's `main()` is now async.
2. `509f34b0d0` — moved the `type CaipChainId = ...` alias and its rationale comment to immediately after all imports. Identical semantics.

## Local validation

- `corepack yarn workspace @aglocal/swingset-runner lint:eslint`: 0 errors, 3 warnings (pre-existing `jsdoc/reject-any-type`).
- `corepack yarn workspace @agoric/vats lint:eslint`: 0 errors, 117 warnings (pre-existing `jsdoc/reject-any-type`).

## Pre-push-gates result

- `yarn format`: pass (no auto-fixes).
- 8 probes: all pass.
- `yarn lint --fix`: fail on inherited monorepo `lint:types` issues across many workspaces (cosmic-proto / client-utils tsc errors) — pre-existing, unrelated to the absorb. The targeted `lint:eslint` for the two regressed packages passes.
- `yarn typecheck`: skip (no root script).

## Preserved work (verified intact)

- Float*Array endow at all 6 SwingSet sites (per ses#3153 fix from fixer 65b4a3).
- multichain-testing dual-AVA install resolution (per fixer cc9bb5).
- All 3 absorb commits' net effect (Endo @1.5.0 / @1.10.0 / ses 2.x / bundle-source 4.3.2 / type fixes).
- The `# Inlined to avoid pulling @agoric/orchestration` rationale comment in vats/src/types.ts (moved, not deleted).

## PR comment

Posted top-level summary @-mentioning @kriskowal with the classification table, fixes by SHA, preserved-work note, and recommended next stage:
<https://github.com/kriscendobot/agoric-sdk/pull/5#issuecomment-4714705606>

## Recommended next stage

`next: ooda-observation`. The CI run on `509f34b0d0` will reveal whether the cascading test-* failures clear once lint-primary passes. The orchestrator's next OODA cycle observes the new rollup, classifies the residual reds (Class C or B), and dispatches accordingly per `skills/ci-failure-classification-loop/SKILL.md`. If lint-primary stays green and test-quick / test-portfolio-contract / test-cosmic-swingset / test-inter-protocol etc. clear, the loop converges toward green; if any persist with a real runtime signature, dispatch the next fixer at the largest coherent C subset.

Self-improvement: When absorbing an upstream PR's package.json that drops a dependency, scan the corresponding source files for stale imports of that dep. The d8a32b absorb took upstream's package.json wholesale but did not cross-check source code in the same package, leaving slogulator.js with a stale `import Readlines from 'n-readlines'` after the dep was removed. A simple pre-commit check: for each removed package.json `dependencies` entry, `git grep -l '<dep-name>' packages/<workspace>/src/ packages/<workspace>/lib/` and confirm the file diff also removed the import. This generalizes beyond Endo absorbs to any dependency-pruning rebase. Routing this as a message to the liaison for evaluation against `skills/pre-push-gates/probes/` (could become a new probe: `package-json-deps-match-imports`).
