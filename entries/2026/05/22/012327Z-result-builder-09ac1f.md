---
ts: 2026-05-22T01:23:27Z
kind: result
role: builder
project: endo-but-for-bots
worktree: dispatches/builder--09ac1f/project
prs:
  - repo: endojs/endo-but-for-bots
    pr: 348
    role: mirror
  - repo: endojs/endo
    pr: 2902
    role: source
refs:
  - entries/2026/05/22/010659Z-dispatch-liaison-09ac1f.md
---

# Result: builder mirrored endojs/endo#2902 as endojs/endo-but-for-bots#348

- **Fork PR**: <https://github.com/endojs/endo-but-for-bots/pull/348> (DRAFT)
- **Head SHA**: `38bd5ba4d60a3ee73d396c5593cd1e9f19480c61`
- **Base**: `endojs/endo-but-for-bots@master` head `0ec70c6dd`
- **Diff**: 3 files, +16/-580.

## Commit shape

Two-commit cherry-pick mirroring the upstream PR exactly:

1. `b6b3f3aff refactor: Embrace default chaining` (upstream `26fa0b5df`; author kriskowal, committer endolinbot).
2. `38bd5ba4d refactor(compartment-mapper): Remove code inadvertently duplicated in bundle-lite refactor` (upstream `57d6b2e5b`; same identities).

## Conflict resolutions

- First commit: clean cherry-pick (no conflicts).
- Second commit: conflict in `packages/compartment-mapper/src/bundle.js`. The upstream PR deletes the duplicate `makeFunctorFromMap` / `makeScriptFromMap` (plus helpers `makeCjsExitBundlerKit`, `sortedModules`, `bundlerSupportForLanguage`, `getRuntime`, `getBundlerKitForModule`) and replaces them with a single `import { makeScriptFromMap, makeFunctorFromMap } from './bundle-lite.js'`. The bot-fork master had diverged from the upstream PR base on the deleted region (alias error message handling, `PackageCompartmentDescriptors` / `PackageCompartmentMapDescriptor` rename, `syncModuleTransforms` usage on the duplicate). Resolution: applied the deletion semantics by reconstructing the file with the upstream PR's `import + textEncoder` block while preserving the bot-fork's `@import` type names in the JSDoc header (unused after dedup but kept for minimal divergence). Final file = 158 lines, matching upstream's post-PR size.

## Local validation

| Command | Result |
| --- | --- |
| `yarn install` | clean (peer warnings pre-existing) |
| `yarn test` in `@endo/compartment-mapper` | 876 pass, 6 known failures (pre-existing) |
| `yarn test` in `@endo/bundle-source` | 39 pass, 3 known failures (pre-existing) |
| `yarn lint` in `@endo/compartment-mapper` | exit 0 |
| `yarn lint` in `@endo/bundle-source` | exit 0 |
| `yarn lint` in `@endo/captp` | exit 0 |
| `yarn docs` (top level) | exit 0 (66 pre-existing warnings) |
| `pre-push-gates.sh --probes-only` | only the pre-existing repo-wide `security-md-hash-uniform` fail; no new findings in the PR's changed paths |

The `yarn lint --fix` auto-fix stage of `pre-push-gates` re-staged unrelated changes in `packages/evasive-transform/src/index.js` and `packages/ses/src/compartment.js` that are out of scope for this mirror; those were reverted before the push.

## Relationship to PR #332

PR #332 (mirror of endojs/endo#2901) carries the same first commit (`refactor: Embrace default chaining`). Whichever lands first leaves the other rebase as a one-commit (dedup-only) follow-up. The maintainer's directive named `master` as the mirror base, so the duplication is intentional under the documented constraint.

## Out of scope (per dispatch)

- No cross-post on endojs/endo#2902.
- No un-draft; the contractor's per-cycle PR-creation-flow scan picks up the orphan DRAFT and dispatches cleaner / judge / fixer-loop / un-draft.
- No upstream ferry.

Self-improvement: When `pre-push-gates.sh --summary` reports auto-fix re-stages on paths outside the dispatch's diff, those are repo-wide drift the gate surfaces opportunistically and must be reverted before commit; the gate's value-add for the PR is the probes + the diff-scoped lint, not whatever the tree-wide `yarn lint --fix` happens to touch.
