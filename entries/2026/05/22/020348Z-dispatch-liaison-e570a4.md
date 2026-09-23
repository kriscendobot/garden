---
ts: 2026-05-22T02:03:48Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: builder
issues:
  - repo: endojs/endo
    issue: 2982
refs:
  - entries/2026/05/20/220345Z-result-liaison-7add08.md
---

# Dispatch: builder addresses endojs/endo#2982 (bundleSource interferes with `export let` bindings) on master

Dispatch root: `dispatches/builder--e570a4/`. Project worktree on `endojs/endo-but-for-bots@master` (head `0ec70c6dd`).

Maintainer directive (2026-05-22): *"Please dispatch a builder to respond to [`journal/entries/2026/05/20/220345Z-result-liaison-7add08.md`]."*

That earlier liaison result recommended *case C — dispatch a builder to fix*, with **both #2981 and #2982 in scope** (sibling defects sharing the export-map model). PR `endojs/endo-but-for-bots#346` (`fix/bundle-source-aliased-exports-2981`, head `6a72d10f`) already addresses **#2981** via a fan-out closure in `importsCellSetter` (`packages/compartment-mapper/src/bundle-mjs.js`); the regression test `packages/bundle-source/test/export-alias.test.js` was un-`.failing`'d in that PR and now passes. This dispatch covers **the remaining sibling — #2982** as a separate PR rather than extending #346 (so the gauntlet on #346 finishes undisturbed and the two defects bisect independently).

## Upstream issue #2982

- Title: "`bundleSource` interferes with `export let` bindings"
- Labels: `bug`, `next-release`
- Regression test: `packages/bundle-source/test/let-export.test.js` — marked `test.failing` on master (the canonical reproducer), checked in via endojs/endo#2980.
- Sibling to #2981 (aliased exports) per `journal/entries/2026/05/20/220345Z-result-liaison-7add08.md` § Recommendation.

The defect shape (per the earlier recommendation):
- The `__liveExportMap__` path in `packages/compartment-mapper/src/bundle-mjs.js` builds per-export-name *live* cells.
- When an `export let X` is reassigned at runtime, the writer mutates the local binding but the per-export cell's setter is not invoked, leaving the bundled module's export observably stuck at the initial value.
- Compare with PR #346's `importsCellSetter` fan-out fix for the *fixed* (alias) case; the live (`export let` mutation) case needs an analogous fix on the live-cell side.

The upstream site that produces the export maps is `packages/module-source/src/babel-plugin.js`; the consumer that emits the calling-convention object is `packages/compartment-mapper/src/bundle-mjs.js`. PR #346's fix landed in the consumer; the #2982 fix is likely in the same neighborhood.

## Task

1. Read `garden/roles/COMMON.md`, then `garden/roles/builder/AGENT.md`.
2. Read `garden/skills/library-lookup/SKILL.md`, `pre-push-gates/SKILL.md`, `regression-evidence/SKILL.md`, `pr-formation/SKILL.md`.
3. Read `project/CLAUDE.md`.
4. Read the PR #346 diff (head `6a72d10f`, branch `fix/bundle-source-aliased-exports-2981`) — its `importsCellSetter` fan-out closure is the reference shape; #2982 likely needs an analogous fan-out in the live-cell setter (`liveExportMap` / `liveVar`).
5. Run the failing test to confirm reproduction: `cd packages/bundle-source && npx ava test/let-export.test.js --timeout=60s`. Confirm it is `test.failing` and that the underlying behavior is wrong (`export let X = 1; setX(2);` ends up not propagating to `bundle.X`).
6. **Diagnose** the bug. Inspect `packages/compartment-mapper/src/bundle-mjs.js` for the `__liveExportMap__` and `liveVar` constructs. Determine whether the bug is:
   - **a)** the live-cell setter is per-local-binding not per-export-name (analogous to the #2981 root cause; needs fan-out), or
   - **b)** the per-export `liveVar.set` is never invoked because the live binding's write site is rewritten incorrectly upstream in `module-source/src/babel-plugin.js` (the AST rewriter that turns `export let X = 1; ...` into a `liveVar.X` assignment), or
   - **c)** something else.
7. **Fix** with the smallest change. Likely candidate: a fan-out in `__liveExportMap__` analogous to PR #346, plus possibly a corresponding rewriter fix in `babel-plugin.js` if the write-site instrumentation is wrong.
8. **Regression evidence.** Per `garden/skills/regression-evidence/SKILL.md`, prove the test is load-bearing: with the fix reverted (`git stash`), `let-export.test.js` fails; with the fix restored, it passes. Un-`.failing` the test in the same commit as the fix.
9. **Local validation.**
   - `cd packages/bundle-source && npx ava` (full suite).
   - `cd packages/compartment-mapper && npx ava` (the fix site).
   - `cd packages/module-source && npx ava` (if `babel-plugin.js` is touched).
   - `cd packages/ses && npx ava` (if `module-instance.js` is touched).
   - `yarn lint`, `yarn docs`, pre-push-gates.
10. **Commit shape.**
    - `fix(compartment-mapper): propagate live-export writes for `export let` bindings in nestedEvaluate (fixes endojs/endo#2982)` (or the appropriate package depending on where the fix lands).
    - One changeset entry per project convention.
    - Separate `chore: Update yarn.lock` if dependencies changed (unlikely).
11. Push to `endojs/endo-but-for-bots:fix/bundle-source-export-let-2982`.
12. Open **DRAFT** PR on `endojs/endo-but-for-bots` against `master`. Title: `fix(compartment-mapper): propagate live-export writes for export let bindings (fixes endojs/endo#2982)`. Body cites issue #2982, the sibling PR #346 (#2981 fix), the diagnosis, and the regression evidence.

## Per-action authorization

- Push to `endojs/endo-but-for-bots:fix/bundle-source-export-let-2982`.
- Open draft PR on `endojs/endo-but-for-bots` against `master`.
- READ-ONLY on `endojs/endo`.

## Out of scope

- No cross-post on `endojs/endo#2982`.
- No un-draft (steward / contractor scan handles via PR-creation-flow chain).
- No upstream ferry.
- No edits to PR #346's branch — that PR is mid-gauntlet and remains undisturbed.

## Report

≤ 500 words. PR URL + head SHA. Root cause (one sentence). The fix (file:line). Whether the fix path matched PR #346's shape (fan-out) or required a different shape. Regression evidence (test fails before fix, passes after, with confirmation method). Per-command local test status. One-line `Self-improvement: ...`. Write the result as `journal/entries/2026/05/22/<HHMMSSZ>-result-builder-e570a4.md` (refs: this entry + `entries/2026/05/20/220345Z-result-liaison-7add08.md` + the PR #346 builder result) and push journal (rebase if non-fast-forward).
