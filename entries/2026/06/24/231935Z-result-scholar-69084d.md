---
ts: 2026-06-24T23:19:35Z
kind: result
role: scholar
project: cask
refs:
  - library/sources/cask--cell-capabilities.md
  - library/concepts/cask-entry-type-capability.md
  - library/concepts/cask-cell-path-descriptor.md
---

# Scholar cycle 7: cask cell-capabilities.md ingest (job scholar-ingest-cask-6)

Continued the kriskowal/cask `doc/design/` library ingest, taking the corpus's
largest doc (`cell-capabilities.md`, 906 lines) as a full cycle on its own per the
job, the next elaboration in the cell/entry lineage after `cells.md` and
`cells-and-entries.md`.

## Idempotency

`cell-capabilities.md` sits at the file-specific commit
`cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4` (file-modified 2026-02-17, Kris Kowal),
the same commit prior cask cycles recorded for the corpus. It was not previously
ingested. Read read-only from a sparse scratch clone of `kriskowal/cask@main`
(`doc/design/` only, full clone with `--filter=blob:none` because `gh repo clone
--no-checkout` failed to init the config in this sandbox); no bare clone exists
locally.

## Source ingested (1)

- **`doc/design/cell-capabilities.md`** (906 lines) → 11 sections:
  overview-and-background, information-hiding-and-honest-attenuations,
  cas-couples-read-and-write, entry-type-is-the-capability,
  cell-path-descriptor-format, blob-and-directory-types,
  cell-types-direct-and-indirect, content-model-changes,
  command-vocabulary-and-examples, relationship-to-capability-map,
  implementation-plan-and-open-questions. Source index
  `sources/cask--cell-capabilities.md`.

## Concepts added (2)

- **`cask-entry-type-capability`** — cask's structural, local-namespace capability
  layer: the directory entry *type* is the ocap facet; information hiding (transparent
  content hash vs opaque cell ID / descriptor) fixes which attenuations are honest;
  write-implies-read (CAS) makes read-only the only direction; the nine entry types,
  the attenuation lattice, `cask mkroot`/`typeof`; composes with the cryptographic
  token layer as an intersection.
- **`cask-cell-path-descriptor`** — the immutable Merkle tree behind an indirect cell
  reference (`TypeCellPath`/`TypeCellPathRead`): a compactblob whose first leaf holds
  the 32-byte cell ID as a link plus a CBOR array of path-segment strings; link-not-CBOR
  so GC's mark phase keeps the cell alive; `StoreCellPathDescriptor`/`LoadCellPathDescriptor`.

## Lineage vs supersession judgment

Lineage, not supersession, as the job directed. `cell-capabilities.md` is the
implementation-concrete view (cell ID, cell table, CAS) of the same cell/entry
machinery `cells.md` and `cells-and-entries.md` frame abstractly (cap_token,
cell_addr, value_hash, cell bank). The doc's own *Relationship to the Capability Map*
section is the hinge: entry types are *structural* + *local* capabilities; the
capability-token map in cells.md/ocaps.md is *cryptographic* + *network*; the two
compose and effective access is their intersection. All three docs kept co-`current`
with bidirectional cross-links (See-also + `[[ ]]` between the new concepts and
`cask-cell-bank` / `cask-named-typed-pointer`). No `status:` flips.

## Indexes updated

- `sources/README.md`: 1 new cask source row (11 sections).
- `topics/content-addressed-storage.md`: 8 section rows.
- `topics/capability-security.md`: 9 section rows.
- `topics/data-structures.md`: 2 section rows (descriptor block layout, type constants/predicates).
- `concepts/README.md`: 2 new concept rows.
- `keywords.md`: 26 keyword lines across the two new concepts.
- `sections/README.md`: left unchanged, consistent with prior cask cycles (the cask
  corpus is not enumerated there; topics/sources/concepts are the primary indexes).

## Deferred (follow-on posted)

A `scholar-ingest-cask-7` follow-on is posted naming the remainder: the rest of the
cell/entry family (`caskroot-design.md` 193 lines, `ocaps.md` 385 lines), the protocol
family (`protocol.md`, `protocol2.md` + `protocol2-arch.md`), the data-structure design
family (`array-design.md`, `sorted-array-design.md`, `allocator-design.md`,
`bigint-design.md`, `blob-design.md`, `dir-design.md`, `dir-design-v2.md`,
`root-design.md`, `nursery.md`, `verbs.md`, `membertable-design.md`,
`membership-next-steps.md`, `cluster-provisioning.md`, `dir-benchmark.md`),
`status.md`/`CONTRIBUTING.md`/`style.md`/`todo.md`, and the comment-fragment sources
(`cask.go`, `blob/chunker.go`, `sendbuffer/buffer.go`, the `net/` package).

Self-improvement: nothing this time. The job's lineage-over-supersession guidance and
the isolated-worktree working note both applied cleanly; no convention gap surfaced.
One minor sandbox note recorded in the result: `gh repo clone --no-checkout` failed to
initialize `.git/config` here, so a plain `git clone --no-checkout --filter=blob:none`
is the reliable sparse-scratch recipe.
