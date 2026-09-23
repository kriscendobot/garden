---
ts: 2026-05-20T22:03:45Z
kind: result
role: liaison
project: endo
to: maintainer
dispatch: 215539Z-dispatch-liaison-7add08
---

# Result: builder 7add08 — endojs/endo#2981 reproduces; recommend dispatching a fixer (case C)

Builder dispatch `7add08` complete. **Verification: defect reproduces on master `ec3dcbc0`**. No prior fix work exists since the issue was filed 2025-10-07. Self-report at `journal/entries/2026/05/20/220500Z-result-builder-aa2eab.md`.

## Verification

Three reproducer tests already live on master (PR #2980 merged 2025-10-08):

- `packages/bundle-source/test/export-alias.test.js` — `test.failing`, *known failure* (the canonical #2981 reproducer).
- `packages/bundle-source/test/let-export.test.js` — `test.failing`, *known failure* (sibling #2982 reproducer, `export let` mutation case).
- `packages/bundle-source/test/marshal-failure.test.js` — **passes**, but misleading: passes only because workaround commit `d3a081c22 fix(errors): avoid export aliases` rewrote `@endo/errors/index.js` to stop using the alias pattern. The engine is not fixed.

Direct probe of `bundleSource('demo/exports.js', {format: 'nestedEvaluate'})` confirms: aliased exports bind only one name per pair (`number1=undefined`, `number2=42`; `bigint1=undefined`, `bigint2=[fn]`).

PR #2980 also added two preventive `@endo/eslint-plugin` rules (`no-multi-name-local-export`, `no-assign-to-exported-let-var-or-function`) to the recommended set — workarounds, not fixes.

## Bisect

No commit since 2025-10-07 touches the link path in `packages/compartment-mapper/src/bundle-mjs.js` (the `exportsCellRecord` / `importsCellSetter` / `__fixedExportMap__` site that allocates per-export-name cells). The only post-issue module-source touch (`4ffd85548`) is namespace-reexport AST handling, unrelated.

## Recommendation: case C — dispatch a builder to fix

The defect needs a real fix. Most likely fix site: `packages/compartment-mapper/src/bundle-mjs.js` — the cell-per-export-name model in `getCells` / `getFunctorCall` must coalesce export names that share a single local binding (alias case) and route every aliased cell to the same setter. `__liveExportMap__` needs the analogous fanout for the `export let` case (#2982). Upstream site to consider: `packages/module-source/src/babel-plugin.js`, where the export maps are produced.

Regression gate is ready-made: flip the two `test.failing` cases to `test()`.

If maintainer agrees, the liaison can dispatch the fixer with both #2981 and #2982 in scope (sibling defects share the export-map model).

## Self-improvement (carried from builder)

Builder noted that dispatch-prepare ran *before* the dispatch entry was committed to journal, so the per-dispatch `journal/` worktree was frozen without the brief. Builder had to `git fetch origin journal && git checkout origin/journal -- ...` to get its own brief. Real workflow bug: should commit + push journal *before* dispatch-prepare, so the new worktree carries the brief at creation. Liaison to log this and reorder for future batches.

## Teardown

Dispatch root `/home/kris/dispatches/builder--7add08/` torn down by the liaison after this entry lands.
