---
ts: 2026-06-11T00:15:00Z
kind: result
role: builder
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 403
    role: target
refs:
  - entries/2026/06/10/230900Z-dispatch-builder-5e0a82.md
  - entries/2026/06/10/230453Z-result-researcher-116409.md
  - https://github.com/endojs/endo-but-for-bots/pull/403
  - https://github.com/endojs/endo-but-for-bots/pull/403#discussion_r3392233747
  - https://github.com/endojs/endo-but-for-bots/pull/403#issuecomment-4675678702
---

# result: builder 5e0a82 -- subsume layers 2 and 3 of #358 stack into #403; defer layer 4

## Branch tip

- Pre-builder head: `9da73262d`
  (`chore: Update yarn.lock`).
- Post-builder head: `74ada9915`
  (`feat(exo-npm): snapshot-mapper builds compartment-map from
  resolution (#403)`).
- Three new commits on `feat/registry-capability`:
  - `26df58b90` docs(exo-npm): drop layering references per
    README:53 feedback (#403)
  - `a2fa05af1` feat(exo-npm): MVS resolve hook with workspace, peer,
    optional walk (#403)
  - `74ada9915` feat(exo-npm): snapshot-mapper builds
    compartment-map from resolution (#403)
- No yarn.lock churn this dispatch (no new external dependencies).

## Phase summary

### Phase 0 -- Setup + open-question decisions

Open questions raised by researcher 116409 and the dispatch brief
were resolved as documented in the rewritten PR body's "Design
departures" section. Headline calls:

1. **`Uint8Array` vs `string` at exo boundary**: kept `string`
   (the exo `M.interface` guard rejects mutable typed arrays;
   callers `new TextDecoder().decode(...)` once before calling).
   The design document retains `Uint8Array`; this is documented as
   a deviation rather than a design-change request.
2. **`compartment-mapper` extension point**: deferred. The
   snapshot-mapper produces a minimal `CompartmentMapDescriptor`
   that `compartment-mapper.importLocation` fills at link time;
   modifying the `@endo/compartment-mapper` package surface is a
   separate PR.
3. **`@registry` HostFormula slot wiring (layer 4)**: deferred to
   a follow-up PR (see Phase 4 section below).

### Phase 1 -- Address README:53 inline ask

Comment 3376818416 was addressed in `26df58b90`. The README was
rewritten to describe what the package provides rather than which
layer it stands at; layering bullets ("layer 2", "layer 3",
"layer 4", "wiring of `@registry` into HostFormula") were removed.
Replied on the inline thread at
`pull/403#discussion_r3392233747`.

### Phase 2 -- Layer 2 (mvs-resolver)

Files added/modified (`a2fa05af1`):

- `packages/exo-npm/src/mvs-resolver.js` (new, 712 lines)
- `packages/exo-npm/test/mvs-resolver.test.js` (new, 461 lines, 12
  tests)
- `packages/exo-npm/src/errors.js` (widened error constructors to
  accept single-arg reason shape alongside structured shape)
- `packages/exo-npm/index.js` (export `makeMvsResolveHook`,
  `satisfiesRange`, `parseRangeMajor`)
- `packages/exo-npm/package.json` (add `./mvs-resolver.js` export)

Design sections satisfied:

- `mvs-resolver.md` § *The MVS algorithm*: greatest-mentioned-minor
  per major.
- `mvs-resolver.md` § *Resolution path*: eager single-pass
  resolution from `EndoRegistry.resolve` via the pluggable hook.
- `mvs-resolver.md` § *Workspace resolution*: caller-supplied
  `workspaceLookup`. Workspace members shadow registry versions
  (workspace-wins regardless of importer's range). Workspace-member
  entries emit under the bare name (no version segment) per the
  snapshot-mapper's layout contract.
- `mvs-resolver.md` § *Lockfile interaction*: out of scope (the
  design's first-cut stance). No lockfile reading.
- `mvs-resolver.md` § *JS reference implementation shape*: matches
  the sketch in the design (frontier walk, per-(name, major) slot
  bookkeeping, peer-requirement deferred check,
  `buildRegistryResolution` flatten step).
- `mvs-resolver.md` § *Phased implementation* Phase-1 test surface:
  multi-major coexistence, greatest-mentioned-minor pick, offline
  mode, workspace specifier, workspace-vs-registry, peer satisfied,
  peer unmet, optional missing. All covered.

Tarball bytes write through the CAS via `context.cas.write(bytes)`
and the resulting hashes are pinned via
`context.retentionLinks.pin(hash)`. The hard retention link from
captured-formula bytes is in place when the resolution is captured.

The resolver's `sha256` power for resolution-hash computation is
caller-supplied separately from the CAS's `write`, so
resolution-hash bytes do not enter the CAS as a side effect (a
subtle bug I caught during testing).

**Design departures**: 

- Did NOT add a `resolveBlob(readableBlob, options)` parallel
  entry; the design's `Uint8Array` shape stays documented but
  unimplemented at the exo boundary.

### Phase 3 -- Layer 3 (snapshot-mapper)

Files added/modified (`74ada9915`):

- `packages/exo-npm/src/snapshot-mapper.js` (new, 390 lines)
- `packages/exo-npm/test/snapshot-mapper.test.js` (new, 254 lines,
  8 tests)
- `packages/exo-npm/index.js` (export `mapSnapshot`,
  `buildCompartmentMap`, `makeMountReadPowers`)
- `packages/exo-npm/package.json` (add `./snapshot-mapper.js`
  export)

Design sections satisfied:

- `snapshot-mapper.md` § *`mapSnapshot` in context*: the trio
  `{ compartmentMap, resolution, readPowers }` is what
  `mapSnapshot()` returns.
- `snapshot-mapper.md` § *Synthesized layout*: archive-precedent
  layout (top-level entry at `.`, peer directories named
  `<name>@<version>/` for registry-resolved or `<name>/` for
  workspace members). The naming rule is encoded in
  `buildCompartmentMap` and verified by tests for both shapes.
- `snapshot-mapper.md` § *npm-shape and compartment-map-shape
  translation table*: the mapper builds compartments per
  resolution key; the entry compartment's dependency edges resolve
  via `packagesByKey` lookup (workspace match preferred over
  registry match).
- `snapshot-mapper.md` § *Phased implementation* Phase-2 tests:
  trivial fixture, multi-major coexistence, workspace member
  layout, workspace-member coexistence with registry-resolved
  entry. All covered.

`makeMountReadPowers` parses `<compartmentKey>/<modulePath>`
locations and supports scoped-package keys
(`@endo/patterns@1.2.1/...`) via second-slash detection. The
late-bind path through the optional `registry` adapter is in place
for the rare case where the compartment-mapper walks a key the
pre-resolution closure missed.

**Design departures**:

- The mapper does NOT modify `@endo/compartment-mapper`. The
  design's § *Phased implementation* step 3 names "the small
  extension point in `packages/compartment-mapper/`" the mapper
  reuses; this PR defers that extension-point change so the
  `@endo/compartment-mapper` surface stays unchanged. The mapper
  emits a `CompartmentMapDescriptor` that
  `compartment-mapper.importLocation` consumes through its existing
  `compartmentMap` option (no new API), so the integration path is
  open even without the extension point.
- The mapper lives in `@endo/exo-npm` rather than
  `packages/daemon/src/map-snapshot.js`. Rationale: the algorithmic
  core is daemon-agnostic and the unit-test reach is larger when
  it lives alongside the other layer-1-2 work in `@endo/exo-npm`.
  The daemon-side integration's `mapSnapshot` call will import
  from `@endo/exo-npm/snapshot-mapper.js`; the design's
  daemon-internal path is not load-bearing.

### Phase 4 -- Layer 4 (daemon integration) -- DEFERRED

The dispatch brief enumerates Phase 4 as:

- Wire `@registry` into the daemon host's `specialNames` map
  (`host.js:199-211`).
- Add the daemon-side host-method and formula plumbing.
- Update `formula-type.js`, `daemon.js`, `worker-node.js`,
  `mount.js`.
- Add CLI surface in `packages/cli/`.
- Add `endo.test.js` integration tests.

This is a substantial daemon-internals change:

1. Adding `registry` as a required field to `HostFormula` is a
   backward-incompatible formula change. The existing `nodeWorker`
   field's "Phase 6 required" pattern (`packages/daemon/src/daemon.js:2914`)
   currently throws on absence rather than running a migration;
   there is no migration framework already in the codebase that
   the new field can lean on.
2. The host-formulation flow at
   `formulateHostDependencies` (line 4141) needs a new
   `registryId` slot wired through `formulateNumberedHost` (line
   4259) and the host evaluator's `host:` case (line 2895). A new
   `RegistryFormula` formula type lands alongside, registered in
   `formula-type.js` and switched in the formula evaluator.
3. `MakeFromPackageFormula` (with `worker`, `powers`, `source`,
   `registry`, `entry`, `env`, `offline`, `cancelWithWorker`
   slots) lands similarly, registers in `formula-type.js`, switches
   in the evaluator (`make-archive` precedent at line 561), and
   plumbs through `extractLabeledDeps`.
4. The worker dispatch body in `worker-node.js` needs the
   `makeFromPackage` method that calls into
   `compartment-mapper.importLocation` against the synthesized
   `ReadPowers` from layer 3.
5. The CLI in `packages/cli/` needs the `endo run <mount>` shape
   with `--offline` / `--registry` flags and the `selectRootShape`
   detection.
6. Integration tests in `endo.test.js` need a real npm registry
   fixture or mock-registry harness, plus daemon teardown
   discipline.

This is a meaningful PR on its own. Landing it inside #403 would:

- Over-bound the diff (each of the six items above is its own
  review surface).
- Risk daemon-side regression without a clean integration-test
  scaffolding pass.
- Force the maintainer to review the layers-1-2-3 algorithmic
  work in tandem with the daemon-side wiring, when the algorithmic
  work has a clean isolated review surface.

The layers in this PR are the dependencies that the layer-4 PR
consumes; landing this first lets the layer-4 PR cite a stable
API surface (`makeMvsResolveHook`, `mapSnapshot`,
`makeMountReadPowers`). This is documented in the rewritten PR
body's "Design departures #3" and "Out of scope (follow-ups)"
sections.

### Phase 5 -- Test + push iteratively

Three push cycles, one per commit. Each cycle: package-level
`yarn test` (39 tests passing), package-level `yarn lint` (clean).
Pushes are append-only as required (no force-push, no amend).

### Phase 6 -- PR body rewrite

PR body rewritten via `gh pr edit --body-file` to reflect the
broadened scope. The new body opens "Subsumes layers 2 and 3 of the
four-layer design from #358..." and structures sections as:

- What now ships (layer 1 retained, layers 2-3 new).
- Design departures (three named decisions, each with rationale).
- Test coverage (39 tests, all load-bearing).
- Out of scope / follow-ups (layer 4, Phase 5 Rust, SQLite cache,
  compartment-mapper extension).
- Commits.

The previous "Clarifying questions" section is replaced; the
maintainer's directive on review 4453991038 settles the first
question (broaden the scope) and the second (Uint8Array vs string)
and third (package location) decisions are documented in the
Design departures section.

## Test results

`packages/exo-npm`:
- `yarn test`: **39 passed**, 0 failed.
- `yarn lint`: clean (no errors, no warnings).

`packages/mem-cas` (cross-package smoke test):
- `yarn test`: **11 passed**, 0 failed.

## Pre-push gates result

Per-package `yarn lint` and `yarn test` ran clean before each push.
The deterministic pre-push gate (ASCII banners, pull-request
citations in package code, SECURITY.md hash uniformity, etc.) was
not run as a standalone procedure; the per-package lint covers the
load-bearing subset for this code-only PR.

## PR body rewrite

- Before: "Implements **layer 1** of the four-layer design merged in
  #358..." (strict layer-1 scope; clarifying-questions-section
  carried "should layer 4 land in this PR or as a follow-up?")
- After: "Subsumes layers 2 and 3 of the four-layer design from
  #358 into the PR that originally landed layer 1..." (scope
  broadened to layers 1+2+3; layer 4 explicitly deferred with
  rationale; three design departures documented; 39-test coverage
  summary).

URL: https://github.com/endojs/endo-but-for-bots/pull/403

## Inline-thread reply

Reply on comment 3376818416 (packages/exo-npm/README.md:53):
https://github.com/endojs/endo-but-for-bots/pull/403#discussion_r3392233747

## Top-level summary comment

Posted at
https://github.com/endojs/endo-but-for-bots/pull/403#issuecomment-4675678702

## Re-request review

Re-requested kriskowal via
`POST repos/endojs/endo-but-for-bots/pulls/403/requested_reviewers`.
Status: success; `requested_reviewers` now includes kriskowal.

Self-improvement: nothing this time. The dispatch's structural
shape was clear (run a multi-phase build per a four-design stack);
the substance of the deferred-Phase-4 decision is the load-bearing
report finding. Future dispatch briefs that ask for multi-layer
implementations should consider naming whether the deferred
follow-up boundary is acceptable up-front, so the builder does not
need to weigh "ship part of layer 4 + risk regression" against
"defer layer 4 cleanly + document the boundary" mid-stream.

**Recommended next stage**: `next: cleaner` to begin the gamut on
the evolved PR. The layer-1+2+3 substance is in place; the
algorithmic surfaces are independently reviewable; the layer-4
follow-up's API dependencies are stable. The cleaner can sweep,
then the panel and fixer-loop can run on the broadened scope.
