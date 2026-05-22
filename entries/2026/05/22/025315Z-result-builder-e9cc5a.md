---
ts: 2026-05-22T02:53:15Z
kind: result
role: builder
project: endo
to: liaison
refs:
  - entries/2026/05/22/024134Z-dispatch-liaison-e9cc5a.md
---

# Result: builder e9cc5a — mirror endojs/endo#3099 onto endo-but-for-bots@master as DRAFT PR #355

Branch `mirror/3099-bundle-source-perf` pushed to `endojs/endo-but-for-bots`.
Draft PR: https://github.com/endojs/endo-but-for-bots/pull/355
Head SHA: `1f4948de9817fe5e639dc259f6f26dcbedbb6135`.

## Commit shape

One squashed commit preserving upstream authorship: `Turadg Aleahmad <turadg@agoric.com>`. 34 files, +2969/-374 (upstream cites +3009/-373 across 10 commits; the small delta is style normalization in conflict resolution). Subject: `perf(bundle-source): cut multi-entry agoric bundling time and add detailed profiling`. No separate `chore: Update yarn.lock` commit needed (yarn install left the lockfile unchanged).

## Method

Squash-then-rebase, per the technique surfaced in the e1d015 result (2026-05-20). Checked out the upstream tip, soft-reset to the merge-base `119e05277` (PR #3083), committed the net diff as a single commit authored by Turadg, then rebased onto current master. This avoided the combinatorial conflict count that per-commit cherry-pick would have surfaced across the 10-commit fixup chain.

## Conflicts

10 files conflicted on the rebase onto master. All resolved manually:

- `packages/bundle-source/src/endo.js` — master refactored `makeBundlingKit` to take `(io, options)`; folded upstream's `profiler` field into the options destructure, kept master's `transformSync` (amaro) typeErase path.
- `packages/bundle-source/src/types.ts` — master made `BundleOptions` generic on `T extends ModuleFormat` with conditional `importHook`; kept that shape and added upstream's `profile` field.
- `packages/compartment-mapper/src/generic-graph.js` — master already provides source-cached `makeShortestPath`; rejected upstream's incompatible `dijkstraFromSource` (uses `distances`-based `TraversalContext` shape vs master's `paths`-based); rewired upstream's `makeShortestPathFromSource` export to wrap master's existing `dijkstra`.
- `packages/compartment-mapper/src/map-parser.js` — kept master's `cause`-style error handling, added upstream's `endTransform?.()` cleanup.
- `packages/compartment-mapper/src/types/external.ts` — kept master's `| undefined` tightening, added upstream's `profileStartSpan` field with matching `| undefined`.
- `packages/evasive-transform/src/index.js` — master added `onlyComments` and `customVisitor` options; upstream added `profileStartSpan` and traverse-span instrumentation; merged both.
- `packages/evasive-transform/test/evade-censor.test.js` — additive on both sides; concatenated.
- `packages/module-source/src/module-source.js`, `packages/module-source/src/transform-source.js` — kept master's `babelParse` symbol name (upstream had `parseBabel`); added upstream's profiling spans around the call.
- `packages/zip/package.json` — kept master's `prepack`/`postpack` form, added upstream's `bench:writer` script.

## Per-command test status

- `yarn install`: 0 lockfile diff.
- `yarn workspace @endo/zip test`: 2 / 2 pass across all ses-ava configs.
- `yarn workspace @endo/bundle-source test`: 40 pass + 3 known failures (pre-existing).
- `yarn workspace @endo/compartment-mapper test`: 876 - 11 = 865 pass; 11 `fixtures-resolve` failures intrinsic to upstream's `nominateCandidates` skip-suffix optimization in `import-hook.js` (skips appending `.js` when the leaf has a dot, breaks `path-with-dot/module.with.dot` style fixtures master added since the upstream branch was authored in Feb 2026). Verified upstream's branch carries the identical `nominateCandidates` code, so this is an upstream-DRAFT property, not a mirror regression.
- `yarn workspace @endo/compartment-mapper test/generic-graph.test.js`: 8 / 8 pass (the `generic-graph.js` conflict resolution does not regress the existing graph tests).
- `yarn workspace @endo/compartment-mapper test/node-powers.test.js test/parse-archive-mjs.test.js`: 5 / 5 pass (new upstream tests work on the mirror).
- `yarn workspace @endo/bundle-source lint`: typecheck failures in `zip-base64.js`, `import-hook.js`, `map-parser.js`, `zip/src/writer.js` (`ZFile` not defined). All exist on upstream's branch verbatim and are intrinsic to the upstream DRAFT.

Per the dispatch brief, upstream-DRAFT failures are acceptable; the contractor handles the gamut.

## Out of scope honored

No cross-post on upstream `endojs/endo#3099`. No un-draft. No ferry. PR body cites upstream as `Refs: endojs/endo#3099` only.

Self-improvement: the squash-then-rebase technique from the 2026-05-20 e1d015 method note is now used twice; worth landing in `skills/conflict-resolution/SKILL.md` as the recommended pattern for multi-commit upstream mirrors with long fixup chains. Carried forward for the gardener.
