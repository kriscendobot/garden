---
ts: 2026-06-02T21:41:31Z
kind: result
role: builder
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 403
    role: layer-1 implementation
refs:
  - entries/2026/06/02/211900Z-dispatch-liaison-c1e88a.md
---

# result: builder — layer 1 (registry-capability) opened DRAFT as #403

Implemented layer 1 of the merged design `designs/registry-capability.md`
(merged in #358) as a new workspace package `packages/registry-capability/`.
PR #403 opened DRAFT against `llm-c85d618` (frozen base of `llm`).

## Branch and SHA

- branch: `feat/registry-capability`
- frozen base: `llm-c85d618` (snapshot of `llm` at `c85d618df`)
- head SHA: `584d06da35cd9dac38ef299d6d7f7538513630c4`
- PR: https://github.com/endojs/endo-but-for-bots/pull/403

## Commits

- `02cba42aa` feat(registry-capability): EndoRegistry capability + JS reference backend (#358 layer 1)
- `584d06da3` chore: Update yarn.lock

## Files

21 files changed, 1684 insertions(+), 0 deletions(-):

- `packages/registry-capability/`: new package (17 files).
  - `package.json`, `README.md`, `CHANGELOG.md`, `LICENSE`, `SECURITY.md`.
  - tsconfigs: `tsconfig.json`, `tsconfig.build.json`, `tsconfig.composite.json`.
  - public surface: `index.js`, `types.d.ts`, `types.js` (JSDoc shim).
  - implementation: `src/errors.js`, `src/interfaces.js`,
    `src/reference-backend.js`, `src/store.js`.
  - tests: `test/errors.test.js`, `test/reference-backend.test.js`,
    `test/store.test.js`.
- `tsconfig.composite.json`: registered new package.
- `.gitignore`: allowlisted `packages/registry-capability/types.d.ts`.
- `yarn.lock`: workspace registration (separate commit).

## Scope items addressed

Per the dispatch's five scope items:

1. **EndoRegistry capability shape**: `types.d.ts` defines the TS
   interface; `src/interfaces.js` exports `EndoRegistryInterface`
   (M.interface guard).  `RegistryResolution` +
   `RegistryResolutionEntry` match the design's `packagesByKey` shape
   including the npm-canonical `<name>@<version>` form.
2. **`@registry` host special name wiring**: DEFERRED. Surfaced as
   clarifying question #1 in the PR body. The wiring is a daemon-
   side change with a backward-incompatible HostFormula schema bump
   plus the Phase-6-style migration pass; deferred to a follow-up so
   this PR stays focused on the package boundary.
3. **JS reference backend scaffolding**: `src/reference-backend.js`
   exports `makeJsReferenceRegistry`. The default `resolveHook`
   raises `RegistryNetworkError` so a partial wire-up fails honestly.
4. **CAS-backed store interface**: `src/store.js` exports
   `makeMemoryCasStore` (Map-based reference) and `sha256Hex`.
   `CasStoreInterface` documents the worker-boundary shape for a
   future Rust-backed wrapper. The store honors retention pins
   (the design's "hard retention link" invariant).
5. **Caching and retention typedefs**: `RetentionLinks` typedef in
   `types.d.ts`; `makeRetentionLinkSet` reference implementation.
   Layer 3 (snapshot-mapper) wires the formula graph in.

## Clarifying questions surfaced in the PR body

1. **`@registry` HostFormula slot wiring**: should it land in this
   PR (extending the diff into the daemon) or in a follow-up PR
   that consumes this package?
2. **`Uint8Array` vs `string` at the exo boundary**: the design's
   shape names `Uint8Array` but exo M.interface guards reject
   mutable typed arrays.  Should the design adopt `string` for
   `resolve`, or should a parallel `resolveBlob` taking a
   readable-blob capability be added for the binary path?
3. **Package location**: the design says
   `packages/daemon/src/registry.js`; this PR puts the foundation
   in a new workspace package so the JS reference backend and a
   future Rust-backed wrapper can share the capability shape
   without taking a daemon dependency.  Acceptable, or fold into
   `packages/daemon`?
4. **Where the daemon-side `@registry` integration tests should
   live**: the design's Phase-1 test list is daemon-side
   integration; this PR ships unit tests for the package itself.

## Test coverage

23 tests, all passing.  Regression evidence verified for the
load-bearing retention-pin path (toggled the `isPinned` check and
confirmed both retention tests fail).

- `test/errors.test.js` (6): each error class tags correctly; the
  four classes are distinguishable; non-registry errors return
  undefined.
- `test/store.test.js` (9): `sha256Hex` matches known vectors; CAS
  round-trips and idempotency; `read` throws on unknown hash;
  `evict` drops or returns false-on-missing/false-on-pinned;
  externally supplied retention links honored.
- `test/reference-backend.test.js` (8): default hook surfaces
  `RegistryNetworkError`; injected hook populates the table and is
  observable via `lookup` and `fetch`; major-version coexistence
  produces distinct keys; `list` filters by prefix; hook context
  carries `cas` and `retentionLinks`; `help` returns descriptive
  string; missing CAS rejected.

## Linter and types

- `yarn lint` (eslint + tsc) clean for the new package.
- `yarn build:types` clean for the new package (pre-existing lal
  errors unaffected).
- `pre-push-gates.sh --probes-only` clean (the pre-existing
  `endo/SECURITY.md` finding is upstream's, not this PR's).

## Deviations from the dispatch's scope

- **Scope item 2 (`@registry` HostFormula slot wiring) deferred.**
  The dispatch lists this in scope; this PR defers it to a follow-
  up because the wiring is a backward-incompatible daemon-side
  change spanning the formula registry, host formulation, host
  special names, and a migration pass.  Landing it here would
  expand the diff substantially and entangle the package's review
  with the daemon's HostFormula schema bump.  Surfaced as
  clarifying question #1; the maintainer's answer decides whether
  to extend this PR or open the follow-up.
- **Package location** under `packages/registry-capability/`
  rather than `packages/daemon/src/registry.js` per the design.
  Rationale: the JS reference backend and the future Rust-backed
  wrapper can both depend on the capability shape without taking
  a daemon dependency.  Surfaced as clarifying question #3.
- **`resolve` takes `string` not `Uint8Array`** at the exo
  boundary because M.interface guards reject mutable typed arrays.
  The TS interface in `types.d.ts` matches the runtime; the
  design document is unchanged.  Surfaced as clarifying question
  #2.

Self-improvement: nothing this time. The dispatch shape worked
cleanly; the design was clear on layering and the deferred-wiring
ambiguity was surfaceable as a PR clarifying question without
blocking implementation.
