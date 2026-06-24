---
ts: 2026-06-12T05:26:21Z
kind: result
role: builder
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
worktree: dispatches/builder--91fa4a/project
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/438
refs:
  - https://github.com/Agoric/agoric-sdk/pull/12721
---

Opened DRAFT PR #438 on `endojs/endo-but-for-bots`: analogous tsgo migration modeling Agoric/agoric-sdk#12721.
Branch `chore/tsgo-lint-types` off frozen base `master-4a04d07`.

## Ladder landed (7 commits)

1. `chore(types): add @typescript/native-preview to the catalog` — `.yarnrc.yml` catalog entry, unpinned (`^7.0.0-dev.0`).
2. `chore: Update yarn.lock` — first lockfile churn.
3. `chore(types): switch lint:types to tsgo for the dev loop` — sweep of 49 packages from `tsc` to `tsgo --tsBuildInfoFile tsconfig.tsgo.tsbuildinfo`, `@typescript/native-preview` added to each package's `devDependencies` (catalog:dev), `packages/skel` template updated.
4. `chore: Update yarn.lock` — second lockfile churn.
5. `chore(types): add typecheck-all (tsgo over the unified config)` — root script `tsgo -p tsconfig.json --tsBuildInfoFile tsconfig.tsgo.tsbuildinfo`; CI lint job step after `yarn lint`.
6. `chore(types): add typecheck-packages (per-workspace consumer view)` — root script `yarn workspaces foreach --all --parallel --verbose run lint:types`; CI step after `typecheck-all`.
7. `docs(agents): tsgo transition (AGENTS.md)` — extends the TypeScript section with the *TypeScript Preview (tsgo)* division-of-labor table and refines the Testing section's `tsd` vs. `lint:types` boundary.

## Open-question decisions

- **tsconfig reuse**: reused existing `tsconfig.json` (already provides eslint-base `noEmit + incremental` and the workspace-graph exclusions) rather than introducing a dedicated `tsconfig.check.json`. Minimum-diff bias per researcher recommendation.
- **`packages/lockdown`**: left untouched (no `lint:types` script today; `workspaces foreach` naturally skips it). `pre.js` already has `@ts-nocheck`, so the wildcard `include` in `tsconfig.json` doesn't pin a check failure on it.
- **`tsd` integration**: kept separate from `lint:types` (was already the live layout in source); AGENTS.md updated to describe both layers.
- **Renovate / Dependabot policy**: documented in AGENTS.md (unpinned, fix-forward, `resolutions` fallback). No Renovate config touched; can land follow-up if needed.
- **Per-package `@typescript/native-preview` devDep** (vs. `yarn run -T tsgo`): added the per-package devDep to mirror the existing per-package `typescript` discipline.

## Material gaps documented in PR body

1. **tsgo strict-mode JSDoc cascade.** 39 of 49 packages surface new errors under tsgo. Most cascade from a single root cause: `packages/harden/make-hardener.js:155` missing a type predicate on the returned `isPrimitive` callback; every consumer of `@endo/harden` re-emits the error. Inspection suggests these are legitimate JSDoc precision issues; a follow-up `fix(harden)` and a small set of similar root-cause fixes in `@endo/pass-style` / `@endo/eventual-send` should clear most of the failures.
2. **tsgo crashes on the unified compilation.** Running `tsgo -p tsconfig.json` against the whole repo panics inside tsgo's relater (`getParameterNameAtPosition: index out of range [2] with length 2`). Upstream bug on `7.0.0-dev.20260611.2`; minimal reproduction not yet bisected.

Both gaps are surfaced in the PR body with three routing options each (fix root cause, exclude via TODO list, or hold CI gates while paying down). The PR is DRAFT specifically to let the maintainer route this rather than the builder picking a path.

## Sweep snapshot

- **Pass under tsgo (10)**: `base64`, `cjs-module-analyzer`, `eslint-plugin`, `exo`, `panic`, `path-compare`, `stream-types-test`, `trampoline`, `where`, `zip`.
- **Fail under tsgo (39)**: dominated by the `harden`-cascade root cause. Heaviest local error counts: `bundle-source` (223), `compartment-mapper` (222), `check-bundle` (213), `import-bundle` (204), `ocapn` (206), `nat` (203), `daemon` (147), `ses` (76), `goblin-chat` (63), `test262-runner` (58), `module-source` (56), `patterns` (46), `captp` (23), `marshal` (22).

## Pre-push gate state

- `yarn format` and `yarn lint --fix` ran clean (one auto-fix on AGENTS.md prettier landed silently in the docs commit per gate norm).
- All eight probes pass except `sentence-per-line-md`, which flags **pre-existing** lines on AGENTS.md (lines 44, 48, 59) that this PR does not touch; the one new sentence-per-line violation I introduced was fixed before commit.
- `yarn typecheck` step skipped (no root `typecheck` script).

## Recommended next stage

**cleaner** to start the gamut on PR #438. Two qualifications for the orchestrator:

- The cleaner's normal coverage-and-tests pass is mostly out of scope here (no behavior change to test). The cleaner should still walk the PR per its skill; the deliverable will likely be a short *no cleaner-side changes needed* result.
- The judge that follows may want the panel-hints for this PR to emphasize *what the design departures mean for review*, since the central question is which of the three routing options the maintainer wants for each material gap, not the usual code-review checklist.

The PR is structured to surface those decisions cleanly. Once the maintainer (or the panel) picks routing for both gaps, follow-up PRs can either fix the root-cause JSDoc cascade in `@endo/harden` or land an exclusion list with TODOs, and only then does this PR become a candidate for un-draft.

Self-improvement: nothing this time.
