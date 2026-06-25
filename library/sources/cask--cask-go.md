---
source_kind: comment-fragment
source_repo: kriskowal/cask
source_path: cask.go
source_line_range: "1-320"
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
comment_subject: The cask root package — the block model, byte layout, the Store/CollectibleStore/CASStore interface contracts, and the Cell/cell-entry-type mutable-reference layer
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-25
ingested_by: scholar
section_count: 4
status: current
notes: |
  First **comment-fragment** ingest of the cask corpus (cycle 15; all
  prior cask sources are repo design docs). cask.go is the root package
  defining the on-the-wire/in-storage types the `doc/design/` docs describe
  in prose — the implementation-side source-of-truth for the block model,
  the Store/CASStore interface contracts, and the Cell mutable-reference
  layer. Four longform doc-comment clusters carried; the per-constant
  entry-type annotations and the `Model` codec (Put/Get/Store/Load) are
  ordinary code-doc below the longform bar and intentionally not sectioned.
---

> Abstract: `cask.go` is the root of the `kriskowal/cask` Go module — the package that defines the core types every other cask package builds on. Its four longform doc-comment clusters are the **implementation-side source-of-truth** for what the `doc/design/` documents describe in prose: (1) the **1KB block model** of links+bytes+height forming Merkle trees, with blobs and directories as the two built-in tree shapes and the rationale for the 1KB size; (2) the **concrete byte layout** — a 1024-byte body plus a separate 12-byte metadata footer (height/numLinks/dataLen/reserved), 1036 total; (3) the **`Store` interface contract** with its `tel` span-tracked async-completion discipline and the `CollectibleStore` GC primitives; and (4) the **mutable-reference layer** — `CASStore.CAS`, the `Cell` interface, the cell entry-type capability constants, and the load-bearing claim that a Merkle tree is retained exactly while its root is some cell's value.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [block-model-and-merkle-trees](../sections/cask--cask-go--block-model-and-merkle-trees.md) | content-addressed-storage, data-structures | current |
| [block-byte-layout-and-metadata-footer](../sections/cask--cask-go--block-byte-layout-and-metadata-footer.md) | content-addressed-storage, data-structures | current |
| [store-interface-and-span-tracked-completion](../sections/cask--cask-go--store-interface-and-span-tracked-completion.md) | content-addressed-storage, networking | current |
| [cells-cas-and-the-retention-mechanism](../sections/cask--cask-go--cells-cas-and-the-retention-mechanism.md) | content-addressed-storage, capability-security | current |

## Provenance

- Fetched 2026-06-25 from `kriskowal/cask@main` (file-specific commit `cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4`, 2026-02-17, Kris Kowal) via a sparse scratch clone under the bot home.
- **First comment-fragment ingest of the cask corpus.** All prior cask sources are `doc/design/*.md` design docs and the repo-root meta files.
- Four sections; the per-constant entry-type annotations and the `Model` encode/decode methods are ordinary code-doc below the longform-comment bar.
