---
ts: 2026-06-10T23:04:53Z
kind: result
role: researcher
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 403
    role: target
refs:
  - entries/2026/06/02/214131Z-result-builder-8b34fb.md
  - entries/2026/06/02/220357Z-message-liaison-403-review.md
  - entries/2026/06/07/043000Z-result-steward-403-423.md
  - entries/2026/06/07/055030Z-message-fixer-liaison-403-overscope.md
  - entries/2026/06/02/060529Z-result-designer-a56206.md
---

# result: researcher -- references for #403 builder that subsumes layers 2-4 of #358 stack

The proposed builder dispatch is the next implementation phase for PR #403 (the
`feat/registry-capability` branch carrying the layer-1 `@endo/exo-npm` /
`@endo/mem-cas` scaffolding for the four-layer `daemon-worker importLocation`
stack from #358). The maintainer's outstanding asks on the PR (carried by the
fixer's 2026-06-07 over-scope message) are to subsume the planned phases 2 / 3
/ 4 into the same PR rather than spread them across three follow-up PRs: the
MVS algorithm in `mvs-resolver.md`, the `mapSnapshot` mapper in
`snapshot-mapper.md`, and the daemon-side integration / host-method / CLI in
`daemon-worker-import-from-mount.md`, including the `@registry` slot wiring
that exo-npm's README:53 explicitly defers (the bullet "Wiring of `@registry`
into `HostFormula` as a required field"). The refinement below catalogues the
four merged design documents, the layer-1 implementation surface the builder
will extend, the consuming daemon surfaces for layer 4 (host, host formulas,
worker dispatch, CLI), and the prior PR-context journal entries that frame
the maintainer's directives.

```markdown
## Library and project references

### Project context — design documents (the four-layer stack from #358)

- `designs/registry-capability.md` (layer 1; merged in #358; **Status:
  Proposed**) — `EndoRegistry` capability shape, `@registry` host special
  name, snapshot-vs-live-read contract, structured failure surface
  (`RegistryTamperedError` / `RegistryMissingPackageError` /
  `RegistryNetworkError` / `RegistryOfflineError`), § *Caching and retention*
  (transparent refetch + bounded growth + hard retention link from captured
  `(compartmentMap, resolutionHash, entrySnapshotHash)` formula into the CAS
  trees), § *Phase 1 tests* (the test surface the layer-1 PR already
  partially satisfies), and § *Migration for already-formulated hosts* (the
  `@node`-precedent one-shot upgrade pass).
- `designs/mvs-resolver.md` (layer 2; merged in #358; **Status: Proposed**) —
  Go-like MVS algorithm adapted to npm versioning, the
  `EndoRegistry.resolve(packageJsonBytes, options)` single-call eager-
  resolution shape, § *Workspace resolution* (parent-directory walk to find
  the `workspaces`-bearing root, workspace-wins semantic), peer / optional
  dependency walking, § *Lockfile interaction: out of scope*, § *Phased
  implementation* (the JS-reference test surface that lands inside layer 1's
  Phase 1).
- `designs/snapshot-mapper.md` (layer 3; merged in #358; **Status:
  Proposed**) — `mapSnapshot({ registry, mount, entry? })` daemon-side lane
  in `packages/daemon/src/map-snapshot.js`, `makeMountReadPowers` in
  `packages/daemon/src/worker-import.js`, archive-precedent layout (top-level
  `compartment-map.json` + peer directories named by package, with
  `<name>@<version>/` for registry-resolved entries and `<name>/` for
  workspace members), § *npm-shape and compartment-map-shape translation*
  table, and the one small `compartment-mapper` extension point (re-export
  of the package descriptor walker + hook for the archive-shaped peer-
  directory layout) that lets `mapSnapshot` reuse the walker.
- `designs/daemon-worker-import-from-mount.md` (layer 4; merged in #358;
  **Status: Proposed**) — `makeFromPackage(workerPetName, mountName,
  options)` host method, `makeFromMount` thin dispatcher that branches via
  `selectRootShape` (`compartment-map.json` vs `package.json`),
  `MakeFromPackageFormula` formula type, Node worker dispatch body (snapshot
  → mapSnapshot → importLocation), CLI shape (`endo run <mount>`,
  `--offline`, `--registry`), XS bridging (Node-worker default; XS deferred),
  the architecture sequence diagram, and § *Phased implementation* Phases 1
  through 4 (Phase 5 is the Rust drop-in; Phase 6 is XS-deferred).

### Project context — layer-1 implementation the builder will extend

PR #403 head `origin/feat/registry-capability` (most recent commit
`9da73262d`) carries five #403 commits past the `c85d618df` frozen base.
Package layout at the PR head (post-rename from the original
`@endo/registry-capability` package to the `@endo/exo-npm` + `@endo/mem-cas`
two-package split):

- `packages/exo-npm/` (the layer-1 capability package).
  - `README.md` — names this as "layer 1 of the daemon-worker
    `importLocation` stack" and enumerates the "What this package does
    **not** provide" follow-ups at lines 44-53 that the merged builder will
    subsume:
    - "The MVS resolution algorithm itself (layer 2)."
    - "The snapshot mapper that consumes a `RegistryResolution` (layer 3)."
    - "The daemon-worker entry point that calls `makeFromPackage` (layer
      4)."
    - "Wiring of `@registry` into `HostFormula` as a required field. The
      design's migration policy is named but the wiring is a daemon-side
      change deferred to a follow-up (see the PR body for the open
      question)." ← README:53 (the bullet the dispatch brief calls out).
    - "A SQLite-backed `PackageCacheTable` implementation. The interface
      is in place; a SQLite projection lands in a follow-up." (This bullet
      is on the fixer's over-scope deferred list per the 2026-06-07
      message and is a separate follow-up from the layers-2-3-4 subsume.)
  - `types.d.ts` — `EndoRegistry`, `RegistryResolution`,
    `RegistryResolutionEntry`, `EndoReadableTree`, `ResolveOptions`,
    `PackageCacheRow`, `PackageCacheTable`, `ResolveHook`,
    `ResolveHookContext`, `RegistryErrorName`. **Note**: the layer-1
    `resolve()` accepts `packageJson: string` rather than the design's
    `Uint8Array` because the exo `M.interface` guard rejects mutable typed
    arrays; the design retains `Uint8Array` and the builder may
    optionally add a parallel readable-blob entry per the layer-1 PR's
    clarifying question #2.
  - `src/interfaces.js` (the `EndoRegistryInterface` `M.interface` guard).
  - `src/reference-backend.js` — `makeNpmReferenceRegistry({ packages,
    resolveHook, cas, retentionLinks })`. The default `resolveHook`
    surfaces `RegistryNetworkError`; the merged builder fills it with the
    MVS algorithm. The npm-scoped `PackageCacheTable` interface plus the
    in-memory `makeMemoryPackageCacheTable` reference are already
    present.
  - `src/errors.js` — the four structured error classes plus
    `isRegistryError` / `registryErrorName` helpers.
  - `index.js` — public surface (the names the builder consumes).
  - `test/errors.test.js`, `test/reference-backend.test.js` — the layer-1
    test surface the merged builder extends.
- `packages/mem-cas/` (the layer-1 CAS interface).
  - `README.md` — names the family (`@endo/mem-cas`, `@endo/git-cas` as
    placeholder, the daemon's `store-sha256` tree as an on-disk projection
    of the same `CasStore` shape).
  - `types.d.ts` — `CasStore`, `Sha256Hex`, `RetentionLinks`.
  - `src/store.js` — `makeMemoryCasStore({ sha256 })`.
  - `src/store-web-powers.js` — `sha256HexWebCrypto` (Web Crypto power for
    browser / Node 19+ / SES-realm use; the daemon-side
    `node:crypto`-backed power is wired by the consumer).
  - `src/interfaces.js` — `CasInterface` runtime guard.
  - `test/store.test.js` — CAS / retention-pin test surface.

### Project context — layer-4 consuming surfaces in the daemon

The merged builder's layer-4 work touches the existing daemon source. The
key files and the precedents the design references:

- `packages/daemon/src/host.js` — the host facet. **Line 199-211** holds the
  `specialNames` map where the design wants `@registry` added beside
  `@node` (line 205). The `@node` line is the exact precedent
  `registry-capability.md` § *Migration for already-formulated hosts* cites
  for the required-slot + one-shot-upgrade-pass pattern. The host's
  `makeArchive` / `makeFromTree` / `makeUnconfined*` methods (the
  `makeArchive` / `makeFromTree` precedents from
  `designs/daemon-make-archive.md` § Phase 7 and Phase 8) live on the same
  facet and are the structural template for `makeFromPackage` /
  `makeFromMount`.
- `packages/daemon/src/formula-type.js` and `packages/daemon/src/graph.js`
  — formula-type registration and dependency-graph wiring. The design
  introduces `MakeFromPackageFormula` and a `RegistryFormula`; both register
  alongside the existing formula types.
- `packages/daemon/src/daemon.js` and `packages/daemon/src/interfaces.js` —
  the `HostFormula` schema, `HostFormulaInterface` augmentation, and the
  formula evaluator's case for the new types. The `HostFormula.registry`
  required-field addition lands here.
- `packages/daemon/src/worker-node.js` — Node worker daemon facet. The
  builder adds the `makeFromPackage` worker-side method body (the
  pseudocode in `daemon-worker-import-from-mount.md` § *Worker dispatch*).
- `packages/daemon/src/mount.js` — `Mount.snapshot()` is on lines 681 and
  996; the integration layer calls `E(source).snapshot()` before
  resolution per `registry-capability.md` § *Mount snapshot vs live read*.
- `packages/daemon/test/endo.test.js` — the daemon integration-test home
  for the new method's end-to-end coverage (`makeFromPackage` + CLI).
- `packages/cli/` — the `endo run` / `endo make` CLI surface that
  `daemon-worker-import-from-mount.md` § *CLI shape* extends with
  `--offline` / `--registry` flags and the `makeFromMount` delegation.
- `packages/compartment-mapper/src/` — the one small extension point the
  mapper layer adds (re-export of the package descriptor walker + the
  archive-precedent layout hook). The `compartment-mapper`'s existing
  `mapNodeModules` / `mapArchive` / `archive.js` modules are the
  structural reference for the new `mapSnapshot` lane (which lives in
  `packages/daemon/src/`, not in `compartment-mapper`).

### Project context — supporting designs the layer-4 build cites

- `designs/daemon-make-archive.md` § Phase 6 (`@node` host special name +
  the one-shot host-formula migration pass; the precedent
  `registry-capability.md` § *Migration for already-formulated hosts*
  follows verbatim for `@registry`) and § Phase 7 / 8 (`makeFromTree`,
  `makeUnconfinedFromTree`; the sibling-method precedent for
  `makeFromPackage`).
- `designs/daemon-mount.md` § *Snapshot* and
  `designs/daemon-mount-capabilities.md` § Phase 7 (the immutable
  `readable-tree` `EndoMount.snapshot()` produces; the lifetime-coupling
  story the integration layer relies on).
- `designs/daemon-cas-management.md` and
  `designs/daemon-content-store-gc.md` (the CAS the resolver writes to;
  the eviction surface the registry's transparent-refetch story leans
  on).
- `designs/inventory-cancel-and-liveness.md` § *Lifetime coupling*
  (`thisDiesIfThatDies`; the primitive that pins captured CAS trees to
  the formula's lifetime, the basis for the hard retention link).
- `designs/retention-path-notation.md` (the captured-formula-graph
  retention model the registry's hard retention link extends).
- `designs/endor-npm-registry-proxy.md` (the Rust-side analogue; the
  Phase-5 Rust-backed `EndoRegistry` drop-in target; same Go-like MVS
  semantics).
- `designs/endor-run-expanded.md` § Phase 5 (the Rust-side entry-flow
  precedent the JS-side integration mirrors).

### Project context — project README anchors

- `journal/projects/endo-but-for-bots/README.md` § *Rules of engagement*
  (the bot-identity discipline for #403 commits and the PR-comment
  authorization shape; the merged builder's commits are bot-identity by
  default).
- `journal/projects/endo-but-for-bots/README.md` § *Identity and
  credentials* (the kriscendobot vs kriskowal split; ferrying happens
  later via the boatman, not in this dispatch).
- `journal/projects/endo-but-for-bots/README.md` § *Authority structure*
  (kriskowal is the maintainer; no senior-contributor routing applies to
  this build).
- `journal/projects/endo-but-for-bots/followups/endo-but-for-bots--358.md`
  — five round-1 follow-ups from the design-panel verdict on PR #358.
  The first three (workspace-protocol resolution, Yarn PnP, Rust-side
  resolver callback boundary) intersect the layers 2 / 3 / 4 scope and
  should be considered explicitly while the builder runs; the design now
  carries the workspace-resolution path so the first follow-up is mostly
  resolved by `mvs-resolver.md` § *Workspace resolution* (the builder can
  close that item by implementing it). The Yarn PnP item stays a separate
  follow-up (the design defers PnP). The Rust-side callback boundary
  follow-up is not part of this build (it lands when Phase 5 stabilizes).

### Library — concepts and sources

- `journal/library/sources/endo-but-for-bots--llm-designs-endor-npm-registry-proxy.md`
  — the Rust-side analogue's source-page, including § *Go-style Minimal
  Version Selection (MVS)* (§ *pick-the-version-that-was-explicitly-
  required* + § *avoid-untested-upgrades*), § *Four-step algorithm*, §
  *Comparison with Go's MVS table* (§ *five-aspects-named-side-by-side*),
  § *Six-step package-fetching pipeline*, § *Six-step integration with
  `endor run`*, § *Offline-mode* + § *registry-table-as-implicit-lock-
  file*, § *CAS tree structure*. The MVS rule the JS-side layer-2 must
  implement is canonical there; `mvs-resolver.md` is the JS-side mirror
  and points back at this source for the rule statement.
- `journal/library/sources/endo-but-for-bots--llm-designs-endor-run-expanded.md`
  — the `endor run` Rust-side entry flow; Phase 5 there is the analogue of
  the JS-side single-call eager-resolution shape.
- `journal/library/sources/endo--pkg-compartment-mapper-readme.md` — the
  `@endo/compartment-mapper` overview, with section links for *overview*,
  *evaluating-from-filesystem* (the `importLocation` flow the worker
  drives), *writing-archive* (the archive layout `mapSnapshot` reuses),
  *evaluating-from-archive* (the archive `read` shape `makeMountReadPowers`
  re-implements over CAS trees), and *language-extensions* (the
  `parserForLanguage` argument the worker dispatch passes through to
  `importLocation`).
- `journal/library/topics/compartments.md` — the cross-cutting topic page
  for compartment-mapper section files (overview, writing-archive,
  evaluating-from-archive, language-extensions). Cited when the builder
  needs the cross-section context for the archive-precedent layout.
- `journal/library/keywords.md` line 7095 (Go-style Minimal Version
  Selection (MVS) | patterns) and line 7098 (comparison with Go's MVS
  table; five aspects named side-by-side). These pin the MVS rule the
  layer-2 work follows.

### Why each reference is relevant

- The four design documents are the canonical source for what the build
  delivers; the builder reads them in dependency order
  (`registry-capability.md` → `mvs-resolver.md` → `snapshot-mapper.md` →
  `daemon-worker-import-from-mount.md`) and lands the work in that
  layering.
- The `packages/exo-npm/` and `packages/mem-cas/` layer-1 packages are the
  starting surface; the merged build does not rename them (the prior
  package renames in #403 are already settled) and extends them rather
  than wrapping them.
- The README:53 bullet ("Wiring of `@registry` into `HostFormula`...") is
  the exact deferred item the builder will land alongside layers 2 / 3 /
  4, removing the bullet (and the matching open question from the layer-1
  PR body) when the build is complete.
- The daemon surfaces (host.js, formula-type.js, daemon.js, worker-node.js,
  endo.test.js, the CLI) are where the layer-4 work materially lives. The
  `host.js` line 199 special-names map is the literal site for the
  `@registry` slot addition.
- The supporting designs (daemon-make-archive, daemon-mount,
  daemon-mount-capabilities, daemon-cas-management,
  inventory-cancel-and-liveness, retention-path-notation) carry the
  precedents and primitives the four merged design documents cite without
  re-deriving; the builder consults them only when it touches the
  corresponding integration site (the `@node` migration shape, the
  `snapshot()` lifecycle, the `thisDiesIfThatDies` retention link, the
  CAS eviction discipline).
- The `endor-npm-registry-proxy.md` source-page in the library names the
  MVS rule the layer-2 algorithm follows. The library's `sources/`
  + `topics/compartments.md` pages give the builder a fast path to
  `compartment-mapper`'s archive-precedent layout (the structural
  template `mapSnapshot` reuses).
- The project README anchors fix the bot-identity discipline and the
  follow-up status for PR #358's round-1 verdict items that intersect
  this build; the builder can resolve the workspace-protocol item by
  implementing layer 2's workspace branch.
- The prior #403 journal entries (the builder result `8b34fb`, the
  CHANGES_REQUESTED message `220357Z`, the partial-review steward result
  `043000Z`, the fixer over-scope message `055030Z`, and the round-2
  designer result `060529Z`) carry the full conversational history of
  what has already landed and what the maintainer expects next; the
  builder reads them to align the dispatch's expectations with the PR's
  current state.

### Open questions surfaced to the builder

These are load-bearing but the library does not (yet) carry a concept
page for them; the builder will encounter them in design text and the
maintainer's directives during the build.

- **`@registry` slot wiring shape** — `registry-capability.md` §
  *Migration for already-formulated hosts* names a one-shot upgrade
  pass; `daemon-make-archive.md` § Phase 6 (the `@node` precedent) shows
  the structural template, but the daemon-side migration record (the
  field analogous to the `@node`-era host-formula-id-typedefs.d.ts
  migration-pass note that the fixer's over-scope message cites) needs
  to live somewhere. The fixer's message names
  `host-formula-id-typedefs.d.ts` as the precedent file; the builder
  confirms whether the same file or a sibling carries the `@registry`
  upgrade-pass record.
- **`Uint8Array` vs `string` for `resolve()`** — the design names
  `Uint8Array`; the layer-1 exo accepts `string` (exo guards reject
  mutable typed arrays). The merged builder either keeps `string` (and
  the design carries the deviation as a future readable-blob entry) or
  adds a parallel `resolveBlob(readableBlob, options)` entry alongside
  the existing `resolve(string, options)`. The dispatch should pick a
  stance.
- **`@endo/exo-npm` vs `@endo/registry-capability` package boundary** —
  the renames `c4fe1680e` / `c28016e11` / `f1c5d316b` consolidated the
  layer-1 split; the merged builder neither renames nor re-splits, but
  it should record (in commit messages or the PR body) why the
  daemon-side wiring lives in `packages/daemon/src/` rather than inside
  `packages/exo-npm/`. (Answer per the design: the daemon-side wiring is
  the integration layer; `packages/exo-npm/` is the capability layer
  package, intentionally without a daemon dependency.)
- **`compartment-mapper` extension point shape** — the design's §
  *mapSnapshot in context* names a small extension point in
  `packages/compartment-mapper/` (re-export of the package descriptor
  walker + a hook for the archive-shaped peer-directory layout the
  walker emits compartment locations against). The exact API of the
  extension point is not specified in the design and is the builder's
  call to design-of-implementation; the builder will need to either
  introduce a tiny named export (preferred) or thread the layout
  contract through an existing entry point's options.
```

## Library writeback

No new keyword shortcuts added, no concept pages drafted, no distractions
pruned during this engagement. The library carried the MVS keyword at line
7095 and the compartment-mapper source page; the four design documents the
build subsumes are not (yet) ingested as library sources, but they live in
the project under `<project>/designs/` where the merged builder reads them
directly. A future librarian dispatch could ingest the four layered designs
as `journal/library/sources/endo-but-for-bots--llm-designs-registry-
capability.md` (and three siblings); the engagement budget for this
researcher precedence did not extend to that ingest, and the design
documents are well enough cross-linked within the project tree that the
builder reads them in dependency order without library indirection.

## Open questions

Listed in the refinement section's *Open questions surfaced to the
builder* sub-section above. Each names a decision the merged builder will
either make or defer; they are not library structural gaps.

Self-improvement: nothing this time. The proposed prompt's subject is a
multi-layer build of a four-document design stack with an existing layer-1
package surface; the references the builder needs are the four design
documents themselves, the layer-1 implementation surface, and the daemon
sites the integration layer touches. The library's role here is supporting
context (the MVS rule, the `compartment-mapper` archive precedent) rather
than canonical lookup. The researcher precedence's value on a build like
this is mostly in mapping the project's design tree + implementation
surface to the prompt's task; the library lookup adds the cross-reference
to the upstream-mirror Rust-side analogue.
