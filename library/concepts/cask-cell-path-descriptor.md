---
id: cask-cell-path-descriptor
aliases: ["cell path descriptor", "cellpath", "descriptor hash", "indirect cell reference", "scoped cell reference", "StoreCellPathDescriptor", "LoadCellPathDescriptor", "subpath capability"]
topics: [content-addressed-storage, capability-security]
status: current
---

# cask-cell-path-descriptor

The small immutable Merkle tree that backs a CASK **indirect cell reference** (`TypeCellPath` / `TypeCellPathRead`), encoding a (cell ID, subpath) pair so a directory entry can grant access scoped to a subtree of a cell rather than to the cell's whole root value. Its content hash is what appears in the entry's hash field. Structurally it is a compactblob whose **first leaf block** holds the 32-byte cell ID as `Links[0]` and the path segments as a CBOR array of text strings in the data bytes (992 bytes available on the first leaf, full 1024 on continuations). The cell ID lives in the **link slot, not the CBOR**, for retention: the GC mark phase walks the descriptor's tree, discovers the cell ID as a link, and keeps the cell alive exactly as it does for a direct cell entry; buried in CBOR it would be invisible to GC. An empty path array is equivalent to a direct reference (direct types are recommended in that case). `StoreCellPathDescriptor` / `LoadCellPathDescriptor` round-trip it via `caskio.Writer`/`Reader` plus `github.com/fxamacker/cbor/v2`.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [cask--cell-capabilities--cell-path-descriptor-format](../sections/cask--cell-capabilities--cell-path-descriptor-format.md) | Block layout (cell ID as first-leaf link + CBOR path), the payload, and why a link not CBOR bytes. |
| [cask--cell-capabilities--cell-types-direct-and-indirect](../sections/cask--cell-capabilities--cell-types-direct-and-indirect.md) | How the resolver loads the descriptor, reads cell ID + path, and navigates to the subpath. |
| [cask--cell-capabilities--content-model-changes](../sections/cask--cell-capabilities--content-model-changes.md) | `StoreCellPathDescriptor` / `LoadCellPathDescriptor` and uniform GC link discovery. |

## See also

- [[cask-entry-type-capability]] — the entry-type capability model this descriptor implements the indirect (subpath-scoped) half of.
- [[merkle-tree-of-blocks]] — the general 1KB-block Merkle structure a descriptor is a small instance of.
- [[cask-cell-bank]] — the cell table / cell bank the descriptor's cell ID dereferences against.
