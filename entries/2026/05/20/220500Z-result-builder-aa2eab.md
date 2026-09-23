---
ts: 2026-05-20T22:05:00Z
kind: result
role: builder
project: endo
refs:
  - entries/2026/05/20/215539Z-dispatch-liaison-7add08.md
---

# Result: builder 7add08 — endojs/endo#2981 still reproduces; recommend case C (fix bundleSource alias handling)

## 1. Test status (on upstream-master @ ec3dcbc0)

PR #2980 is MERGED on master, so its three tests live on master and were run in this dispatch:

- `packages/bundle-source/test/marshal-failure.test.js` — **passes**, but only because commit `d3a081c22 fix(errors): avoid export aliases` (PR #2980, 2025-10-08) rewrote `packages/errors/index.js` to avoid the alias pattern. It is a workaround in the consumer, not a fix in bundleSource.
- `packages/bundle-source/test/export-alias.test.js` — declared `test.failing`; still fails as expected ("known failure"). This is the minimal #2981 reproducer.
- `packages/bundle-source/test/let-export.test.js` — declared `test.failing`; still fails as expected. The sibling #2982 defect.

Local probe of `demo/exports.js` through `bundleSource(..., { format: 'nestedEvaluate' })` then `eval`: aliased exports bind only one of each pair (`number2=42`, `number1=undefined`; `bigint2=[fn]`, `bigint1=undefined`; `bigint3=[fn]` via separate import alias also fails). Bundle-time alias to single cell is the lost binding.

## 2. Provenance of PR #2980

`headRefName: mhofman/add-bundle-failing-tests`, `headRefOid: 8a45476`, state MERGED on 2025-10-08T22:39:34Z. All three test files plus a `@endo/eslint-plugin` rule `no-multi-name-local-export` (recommended) and `no-assign-to-exported-let-var-or-function` are on master to *prevent* further occurrences in endo's own code, not to repair the engine.

## 3. Bisect / grep findings

Since 2025-10-07: no commit touches the actual link path in `packages/compartment-mapper/src/bundle-mjs.js` (the `exportsCellRecord` + `importsCellSetter` site that allocates per-export-name cells). `4ffd85548 fix(module-source): support 'export * as ns from'` is unrelated (namespace-reexport AST crash). `git log -S '__fixedExportMap__'` since the issue: nothing. Issue #2982 (the `export let` sibling) is also still OPEN, same package, same root cause family.

## 4. Recommendation: **case C** — defect still reproduces, no prior fix work found

Dispatch a builder against #2981 with the failing `test.failing('export alias')` and `test.failing('let export')` cases (already on master) as the regression gate. Most likely fix site: `packages/compartment-mapper/src/bundle-mjs.js` — the `__fixedExportMap__` / `__liveExportMap__` traversal in `getCells` + `getFunctorCall` must coalesce multiple export names that share a single local binding so all alias cells route to the same setter (and the live-export case must wire the setter to update every aliased cell). Sibling #2982 likely falls out of the same change because `__liveExportMap__` shares the cell-per-name shape. Recommend a single builder dispatch covering both issues; the PR body should ask kriskowal to confirm whether the fix belongs in `compartment-mapper/bundle-mjs.js` or earlier in `module-source/babel-plugin.js` (which builds the export maps).

Self-improvement: dispatch prompts that name a canonical brief by journal path should travel with the brief content inlined, or the subagent should be told to `git fetch origin journal` before the read; the prompt's path was unreachable from the subagent's local journal worktree until I synced. Worth a one-liner in the dispatch template (`roles/COMMON.md` § Your dispatch root) reminding subagents to fetch journal before chasing brief paths.
