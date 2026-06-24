---
title: The Entry Type Is the Capability; Two Kinds of Cell Reference
source: doc/design/cell-capabilities.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [capability-security]
status: current
---

Abstract: The organizing principle and the two-by-two lattice it produces. The type on a directory entry determines the operations the holder may perform; different type values for the same hash are different *facets* of the same underlying content, the object-capability pattern applied to the namespace. Content-hash entries admit no meaningful attenuation; cell entries admit read-only and subpath-scoped attenuations only. Cell entry types split into **direct** references (hash = cell ID, one cell-table lookup, authority over the cell's root value) and **indirect** references (hash = content hash of a cell path descriptor, one extra block load, authority scoped to a subpath). The two axes (root vs subpath) × (read-only vs read+write) give the four cell types `TypeCellRead`, `TypeCell`, `TypeCellPathRead`, `TypeCellPath`.

## Principle: the entry type is the capability

The type on a directory entry determines the operations the holder may perform. Different type values for the same hash are different *facets* of the same underlying content: the ocap pattern applied to the namespace.

The attenuations available depend on the hash field:

- **Content-hash entries** (blobs, directories): No meaningful attenuation. The content is immutable and readable by anyone who sees the hash.
- **Cell entries** (direct and indirect): Attenuations are **read-only** and **scoped to a subpath**. Write implies read (CAS semantics), so the only attenuation direction is from read+write down to read-only.

## Two kinds of cell reference

Cell entry types fall into two categories based on what the hash field contains.

### Direct cell references (hash = cell ID)

The hash field is the cell ID itself. The resolver looks up the cell ID in the cell table to get the current value hash. These types grant authority over the cell's root value:

| Type | Meaning |
|------|---------|
| `TypeCell` | Read + write (CAS) the cell's root value |
| `TypeCellRead` | Read the cell's root value only |

### Indirect cell references (hash = content hash of a cell path descriptor)

The hash field is the content hash of a **cell path descriptor**: a small immutable Merkle tree that carries the cell ID as a link in its first leaf block and a CBOR-encoded path as its data bytes. The resolver loads this descriptor to extract the cell ID and the path segments, then resolves the cell's current value and navigates to the specified subpath. These types grant authority scoped to that subpath:

| Type | Meaning |
|------|---------|
| `TypeCellPathRead` | Read content at the specified subpath |
| `TypeCellPath` | Read + write content at the specified subpath |

The descriptor is immutable and content-addressed. Multiple entries can share the same descriptor if they encode the same (cell ID, path) pair.

### Why two categories?

Direct references are efficient: resolving a `TypeCell` entry requires one cell table lookup. Indirect references add one block load (the descriptor) but encode a path constraint that cannot be represented in the entry's three fields.

The two categories are orthogonal. Direct types control access at the cell root. Indirect types control access at a subpath. Together they cover the full spectrum:

| | Read only | Read + Write |
|---|-----------|--------------|
| **Root** | `TypeCellRead` | `TypeCell` |
| **Subpath** | `TypeCellPathRead` | `TypeCellPath` |

Source: [doc/design/cell-capabilities.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/cell-capabilities.md) at commit `cdb975d8`.
