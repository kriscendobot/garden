---
source: doc/design/cells.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
section_count: 7
status: current
notes: The cell-graph design. Pairs with cells-and-entries.md (the shared name/mode/reference shape) and cell-capabilities.md (deferred to a follow-on cycle; the full capability model). Introduces the cask-cell-bank concept.
---

> Abstract: CASK's mutable-reference layer over the immutable content-addressed store. CASK runs **two orthogonal naming systems**: immutable Merkle trees (content-addressed, hash-propagating) and a mutable **cell graph** (capability-addressed, non-propagating), which compose into a "named mutable reference to an immutable snapshot." The **cell bank** is the GC root, built from a `capability_map` (`cap_token` → `cell_addr`) and a `cell_map` (`cell_addr` → `value_hash`); the split separates a cell's stable identity from its rotatable secret authorization and its mutable content. A tree embeds a **weak** `cell_ref` (locally just the `cell_addr`; distributed form adds `owner_pubkey` and routing hints, the swiss-number model from CapTP/OCapN), so the cell bank strongly retains value trees while trees do not retain remote cells. The caskdir **mode** field grows to 2 bytes (category/subtype: immutable, cell, map, set). Capabilities are unguessable 32-byte bearer tokens allocated hierarchically; `ALLOC`/`WRITE`/`READ` plus capability-map key rotation; cells nest recursively. GC has cell-bank, value-tree, and weak-cell-reference faces. The filesystem analogy is exact (inode ≈ cell, directory ≈ caskdir). Five open questions close the document: read capabilities, cell metadata, cross-peer transfer, versioning, and CAS-vs-CRDT conflict resolution.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview-two-orthogonal-systems](../sections/cask--cells--overview-two-orthogonal-systems.md) | content-addressed-storage, capability-security | current |
| [cell-bank-structure](../sections/cask--cells--cell-bank-structure.md) | content-addressed-storage, capability-security | current |
| [cell-references-and-retention](../sections/cask--cells--cell-references-and-retention.md) | content-addressed-storage, capability-security | current |
| [caskdir-mode-field](../sections/cask--cells--caskdir-mode-field.md) | content-addressed-storage, data-structures | current |
| [capability-model-and-nested-cells](../sections/cask--cells--capability-model-and-nested-cells.md) | capability-security, content-addressed-storage | current |
| [garbage-collection](../sections/cask--cells--garbage-collection.md) | content-addressed-storage | current |
| [filesystem-analogy-and-wire-protocol](../sections/cask--cells--filesystem-analogy-and-wire-protocol.md) | content-addressed-storage | current |

## Provenance

Source: [doc/design/cells.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/cells.md) at commit `cdb975d8` (2026-02-14, Kris Kowal). Ingested by scholar on 2026-06-24 (job `scholar-ingest-cask-5`).
