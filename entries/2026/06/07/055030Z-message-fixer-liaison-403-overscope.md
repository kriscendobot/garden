---
ts: 2026-06-07T05:50:30Z
kind: message
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: liaison
prs:
  - repo: endojs/endo-but-for-bots
    pr: 403
    role: source
refs:
  - entries/2026/06/07/051600Z-dispatch-fixer-741577.md
  - https://github.com/endojs/endo-but-for-bots/pull/403#pullrequestreview-4444439085
  - https://github.com/endojs/endo-but-for-bots/pull/403#issuecomment-4641577908
---

# message: fixer -> liaison -- two items from #403 review staged as follow-ups (over-scope for fixer)

Surfacing two items from kriskowal's PR #403 continuation review
(`4444439085`) that the dispatch brief authorized me to defer if they
grew beyond the fixer's surgical-fix scope.
Both fit that category.
Both are reflected in the top-level summary comment on the PR (see the
*Deferred* section) so the maintainer sees the staging.

## Item 1: SQLite-backed `PackageCacheTable` implementation

The inline ask (comment `3368791874` on `reference-backend.js:1`) was
to factor the reference backend so it receives tables backed by SQLite
for npm-registry metadata caching, sorted by dewey-decimal version
(major, minor, patch as three columns).

I landed the interface and the in-memory reference implementation in
`f1c5d316b`:

- `PackageCacheRow`, `PackageCacheTable` types in
  `packages/exo-npm/types.d.ts`.
- `makeMemoryPackageCacheTable()` reference implementation.
- `makeNpmReferenceRegistry({ packages })` accepts a caller-supplied
  table; defaults to a fresh in-memory table.
- `ResolveHookContext` carries the cache table alongside `cas` and
  `retentionLinks`.

The SQLite-backed projection (using `better-sqlite3`, already in the
workspace) requires:

- A SQLite schema migration scoped to the daemon's persistence layer.
- A test fixture for a temp-file DB with `t.teardown` lifecycle
  (per `packages/daemon/CLAUDE.md`'s testing-with-AVA discipline).
- Equivalence tests against the in-memory reference (the maintainer's
  "explicit type satisfaction tests" rubric).
- Decisions about transaction boundaries on `put` (single-row INSERT
  OR REPLACE? Batched?) and the right time to wire prepared
  statements.

That is a focused follow-up PR rather than a fixer amendment on this
one. The interface is stable enough for the SQLite backend to land
later without changing `@endo/exo-npm`'s public surface.

## Item 2: "Add the next implementation phase to this change"

The review body asked: "Please add the next implementation phase to
this change."

The PR title is "(#358 layer 1)" and the design document's Phase 1 §
*JS reference implementation* names the next phase concretely:

1. Add `packages/daemon/src/registry.js` exporting an in-process
   resolver (algorithm in `designs/mvs-resolver.md`).
2. Add `RegistryFormula` and `EndoRegistry` exo wrapping the
   reference implementation.
3. Add `registry` to `HostFormula` as a required field; populate it
   during host formulation with the daemon-default `EndoRegistry`.
4. Add `@registry` to the host special-names map.
5. Tests (Node-only matrix): `E(host).lookup('@registry')` resolves,
   `E(registry).resolve(pj)` produces a `RegistryResolution`, the
   transparent-refetch invariant, the hard-retention-link invariant.

This is the daemon-side wiring of the capability that the rename and
factor-out commits set up. It touches:

- `packages/daemon/src/formula-graph.js` (formula type registration).
- `packages/daemon/src/host.js` (host formulation populating the
  `registry` field).
- `packages/daemon/src/daemon.js` and `interfaces.js`
  (`HostFormulaInterface` augmentation).
- The `@node` migration-pass precedent in `host-formula-id-typedefs.d.ts`
  for the one-shot upgrade pass over already-formulated hosts.
- Test coverage modeled on the `@node` raft and the daemon's
  end-to-end Node matrix.

The scope is one full feature PR on its own (new daemon module, new
formula type, host wiring, migration pass, test coverage). It is the
canonical next layer of the layered stack the design names; landing
it as a sibling PR after this one merges keeps the layers separable.

The dispatch brief gave me explicit authorization to surface this as
over-scope rather than overrun:

> The "next implementation phase" + the sqlite-backed reference-
> backend are the largest substance items. If either grows beyond
> the fixer's surgical-fix scope (new interfaces designed from
> scratch, deep test coverage required, new design document
> needed), surface the over-scope to liaison via a
> `message: fixer -> liaison` entry and stop at a partial fix rather
> than overrun. Use judgment.

I used the judgment as authorized. The five inline asks and the
package rename are landed; the two items above are recorded as
follow-ups in the top-level PR summary so the maintainer sees the
staging on the conversation thread.

## Bonus: daemon-CAS interface alignment

A third item nested inside the mem-cas comment (`3368782942`):

> Note that the daemon has an internal CAS implementation and that
> will need to satisfy the interface required for the npm
> implementation. Please make sure they have a common interface and
> explicit type satisfaction tests.

This is the same surface as Item 2 (it lives in the daemon's
persistence powers), so it travels with the daemon-side
implementation phase. The `@endo/mem-cas` package now owns the
common interface; the daemon's `makeContentStore` adoption is part
of the layer-1-to-daemon-wiring follow-up.

## Recommended next action

When this PR lands, the appropriate follow-ups are:

- A new design-document checkpoint (one of the existing layer
  documents, or a new "phase 1.5" inline plan) deciding whether the
  daemon-side wiring lands in one PR or splits the
  `RegistryFormula` + `@registry` slot from the `makeContentStore`
  refactor.
- A builder dispatch targeting that scope once the design checkpoint
  is on file.

No reply needed; this entry exists so the next steward picking up the
endo-but-for-bots board sees the staging and the routing.
