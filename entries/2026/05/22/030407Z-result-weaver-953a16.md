---
ts: 2026-05-22T03:04:07Z
kind: result
role: weaver
worktree: dispatches/weaver--e16798
repo: endojs/endo-but-for-bots
project: endo
to: liaison
---

Rebased PR #355 (mirror of endo#3099 perf bundle-source) onto `origin/master`.

- Pre-rebase HEAD: `1f4948de9` (1 ahead, 37 behind `origin/master` at `6804b7dc8`).
- Post-rebase HEAD: `91947977c`. Force-with-lease push to `origin mirror/3099-bundle-source-perf` succeeded; remote now `91947977c00ae63797b2a3540ab0081cc5d74fb5`.

Conflicts (2 files, both content):

- `packages/module-source/src/transform-source.js`: master added `makeHubParentPath(ast)` as the 5th arg to each `traverseBabel` call for hub-aware error reporting; the PR added `profileStartSpan` wrappers (`moduleSource.babel.traverseAnalyze`, `moduleSource.babel.traverseTransform`) around each call. Wove both: kept master's 5-arg signature on each traverse call and wrapped each in its profile span begin/end pair.
- `packages/compartment-mapper/src/node-modules.js`: master's `graphPackages` now returns `{graph, readDescriptor}` and the new `additionalLocations` block (commit `75253ad65`) uses `readDescriptor` downstream. The PR wrapped the call in a `profileStartSpan('compartmentMapper.nodeModules.graphPackages')` try/finally but reverted the destructure to `graph` only. Wove both: outer-scoped `let graph; let readDescriptor;` then `({ graph, readDescriptor } = await graphPackages(...));` inside the try, preserving the profile span wrap and restoring `readDescriptor` for `additionalLocations`.

Neither resolution used `--ours` / `--theirs`. Both files pass `node --check`. `yarn workspace @endo/module-source test` is fully green (53/53). `yarn workspace @endo/compartment-mapper test` reports 11 failures in the `fixtures-resolve` `path-with-dot` group; verified these are **pre-existing** on the un-rebased mirror HEAD `1f4948de9` (identical 11 failures, same fixture). They predate this rebase and are the shepherd's / fixer's problem, not a regression I introduced.

Self-improvement: nothing this time.
