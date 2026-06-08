---
ts: 2026-06-08T02:46:38Z
kind: result
role: builder
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
worktree: dispatches/builder--813762/project
prs:
  - repo: endojs/endo-but-for-bots
    pr: 96
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/96
  - https://github.com/endojs/endo-but-for-bots/pull/96#issuecomment-4645032876
  - entries/2026/06/08/022400Z-result-researcher-0918be.md
---

# Result: builder design-to-implementation transition on PR #96

## Summary

PR #96 rebased from `llm` onto a fresh frozen base `master-4a04d07` (already existed on origin; matches `origin/master` tip `4a04d078b`). The three design-only commits replayed cleanly after dropping the `designs/README.md` delta (the design queue catalog does not exist on the implementation base). A single implementation commit on top lands phases 1-4 of the design: a `package-descriptor-cache.js` module with the two-question API, an opt-in `packageDescriptorCache` option on `mapNodeModules`, and a sibling `mapNodeModulesWithAuxiliary` constructor that wires a default cache. PR base retargeted via `gh pr edit 96 --base master-4a04d07`; transition summary comment posted; head pushed `--force-with-lease`.

## What landed

Commit `98042eca0` (`feat(compartment-mapper): auxiliary package.json cache (#96)`):

- **New module** `packages/compartment-mapper/src/package-descriptor-cache.js`. Exposes `makePackageDescriptorCache(maybeRead)` returning an object with three methods: `findEnclosingCompartmentRoot(path)` walks upward past auxiliary descriptors (those without a `name`) to the enclosing named compartment, returning `{packageLocation, packageDescriptor, auxiliaryDescriptors[]}`; `collectLanguageOverrides(path)` returns the descriptor list `[namedRoot, ...auxiliariesShallowFirst]`; `readDescriptor(packageLocation)` exposes the same memoization for callers' own walks. The walk throws the PR #70 diagnostic (`must have a "name" field`) when no named ancestor exists.
- **New option** `MapNodeModulesOptions.packageDescriptorCache` threaded through `mapNodeModules`. When supplied, the entry resolution uses `findEnclosingCompartmentRoot(moduleLocation)` instead of `search(...)+assertPackageDescriptorHasName(...)`; `moduleSpecifier` is computed as `relativize(relative(packageLocation, moduleLocation))` against the named ancestor. When omitted, the legacy path runs unchanged and `no-name.test.js`'s diagnostic still fires.
- **New sibling export** `mapNodeModulesWithAuxiliary` constructs a `PackageDescriptorCache` from the supplied `MaybeReadFn` and delegates to `mapNodeModules` with the cache pre-injected. Honors an externally supplied cache when one is already passed.
- **Public types** in `packages/compartment-mapper/src/types/external.ts`: `PackageDescriptorCache`, `CompartmentRootDescriptor`, `AuxiliaryDescriptor`.
- **Tests** in `packages/compartment-mapper/test/package-descriptor-cache.test.js`: seven cases covering the cache's two APIs against `fixtures-nested-pkg`, the integration through `mapNodeModules` (both with and without the cache), a synthetic no-named-ancestor case, and a synthetic mixed-walk case.
- **Changeset** `.changeset/compartment-mapper-auxiliary-package-json.md` as `'@endo/compartment-mapper': minor`.

Regression evidence: forcing `isCompartmentDefining = true` (classifying every descriptor as named) breaks five of the seven new tests, confirming the classification logic is load-bearing. All 909 prior `@endo/compartment-mapper` tests continue to pass; `yarn lint` and `yarn lint:types` are clean.

## What was deferred to follow-up

Per the dispatch brief's surgical-scope clause, the following design phases were left for a subsequent dispatch and named in the PR transition comment:

- **Phase 6** — applying the same `packageDescriptorCache` option and `WithAuxiliary` sibling to `archive.js`, `bundle.js`, and `import.js`. The mechanic is mechanical but multiplies the public surface across four files; held to keep this commit reviewable.
- **Phase 5 remainder** — the per-file `languageForExtensionByPrefix` field on the compartment descriptor and its consumption in the parser pipeline. `collectLanguageOverrides` returns the layered descriptors today, but `inferParsers` does not yet consult them; an auxiliary's `{"type": "module"}` is therefore *collected* but not yet *honored* at parse time. Today's auxiliary-entry test passes because the named compartment's `type` (or default CommonJS) covers the entry well enough for the compartment-map construction to succeed; the loading-time language flip is the deferred work.
- **Phase 7** is explicitly out of scope per the design.

A follow-up `build #96` (or `fix #96` if reviewers ask for the deferred work in this same PR) is the obvious next step. The factoring is in place; only the relatives' multiplication and the parse-time consumption remain.

## Operational notes

- The frozen base `master-4a04d07` was already pushed to `origin/refs/heads/master-4a04d07` before this dispatch began (someone or some prior dispatch minted it). Fetched and referenced; no double-mint.
- PR retarget: `gh pr edit 96 --base master-4a04d07` was authorized in the dispatch prompt.
- Top-level summary comment posted on PR #96 (`comment id=4645032876`), as authorized in the dispatch.
- The dispatch brief withheld two authorizations and they were respected: NO re-request of review, NO shepherd dispatch.
- The pre-push gate flagged a `sentence-per-line-md` finding on `designs/compartment-mapper-auxiliary-package-json.md` lines 234/236/240. The finding is a probe false-positive on numbered list items in the design author's own prose (the probe's exclusion list covers `-*+` bullets but not numbered lists), pre-dates this transition, and was left untouched. Surfacing here so the gardener or the probe's author can decide whether to widen the exclusion to numbered lists.
- The PR's draft state was *not* in draft when this dispatch began (it was already published). Did not touch the draft state; the dispatch did not authorize an un-draft and the PR is already published in the implementation-transition shape the maintainer requested.

## Followups for the orchestrator

- **Continue the gamut on PR #96 if appropriate**: now that this PR carries implementation, a `barrister` / first-round panel pass on the source diff is the next pipeline step. The orchestrator can dispatch when it sees fit; this dispatch surfaces but does not initiate.
- **Schedule the phase-6 follow-up**: a `build #96` or `fix #96` dispatch to thread the cache through `archive` / `bundle` / `import` and land the parse-time integration of the layered language overrides. The cache's API is stable and the integration is mechanical.

Self-improvement: `roles/builder/AGENT.md` has no operating norm for the **in-place design+implementation PR** shape (a single PR carrying both a `designs/<slug>.md` file *and* its implementation on the same head branch, with the base moved from the design roadmap branch to the implementation base mid-PR). The existing *A design that lives on the roadmap branch is read, not branched-from* norm names the standard split shape but does not address the maintainer-directed override case this dispatch executed. The researcher result entry called this out as an open question to the gardener. Surfacing here from the builder's side: a one-line norm under *Operating norms* naming the override (when the dispatch prompt says "rebase on master and proceed to implement in place", drop the design-queue README delta during the rebase, keep the design file in the implementation tree as the in-tree spec, and note the off-pattern in the transition comment) would let future builders execute the same transition without re-discovering each step.
