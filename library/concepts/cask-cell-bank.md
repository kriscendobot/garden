---
id: cask-cell-bank
aliases: ["cell bank", "cell graph", "mutable cell", "stand-alone cell", "cell_addr", "cap_token", "value_hash", "capability_map", "cell_map", "cell reference", "cell_ref", "named mutable reference", "swiss number cell", "key rotation cell"]
topics: [content-addressed-storage, capability-security]
status: current
---

# cask-cell-bank

CASK's **mutable-reference layer** over its immutable content-addressed store. CASK runs two orthogonal naming systems: immutable Merkle trees (content-addressed, hash-propagating) and a mutable **cell graph** (capability-addressed, non-propagating); they compose into a "named mutable reference to an immutable snapshot." The **cell bank** is the GC root for mutable state, built from two `caskmap` maps: the **capability map** (`cap_token` → `cell_addr`) and the **cell map** (`cell_addr` → `value_hash`). The split separates a cell's stable identity (`cell_addr`, never changes) from its rotatable secret authorization (`cap_token`, a 32-byte unguessable bearer token; key rotation maps several tokens to one `cell_addr` during a migration window) and its mutable content (`value_hash`, which roots an immutable tree). A tree embeds a **weak** `cell_ref` (locally just the `cell_addr`; the distributed form adds `owner_pubkey` and routing hints, the unforgeable swiss-number model from CapTP/OCapN), so the cell bank strongly retains value trees while trees do not retain remote cells, and a deleted cell fails at resolution time rather than GC time. Operations are `ALLOC(parent_cap) -> (cell_cap, cell_addr)`, `WRITE(cell_cap, cell_addr, value_hash)`, and `READ(cell_addr) -> value_hash`. The filesystem analogy is exact: a cell is an inode (stable identity, mutable content) and a caskdir is a directory.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [cask--cells--overview-two-orthogonal-systems](../sections/cask--cells--overview-two-orthogonal-systems.md) | The immutable-tree / mutable-cell-graph duality and how they compose. |
| [cask--cells--cell-bank-structure](../sections/cask--cells--cell-bank-structure.md) | The two maps: capability_map and cell_map; cap_token / cell_addr / value_hash. |
| [cask--cells--cell-references-and-retention](../sections/cask--cells--cell-references-and-retention.md) | Weak cell_ref in trees; local vs distributed (swiss number) form; retention asymmetry. |
| [cask--cells--capability-model-and-nested-cells](../sections/cask--cells--capability-model-and-nested-cells.md) | ALLOC/WRITE/READ, key rotation through the capability map, recursive nesting. |
| [cask--cells--garbage-collection](../sections/cask--cells--garbage-collection.md) | Cell-bank, value-tree, and weak-cell-reference GC faces. |
| [cask--cells--filesystem-analogy-and-wire-protocol](../sections/cask--cells--filesystem-analogy-and-wire-protocol.md) | inode≈cell / directory≈caskdir; casw/casr wire protocol; open questions. |
| [cask--cells-and-entries--standalone-cells-and-cell-record](../sections/cask--cells-and-entries--standalone-cells-and-cell-record.md) | Stand-alone cell as cap_token-named triple; proposed mode-bearing cell_record. |
| [cask--cask-go--cells-cas-and-the-retention-mechanism](../sections/cask--cask-go--cells-cas-and-the-retention-mechanism.md) | The code-side `Cell`/`CASStore` definitions: CAS nonce/old/new semantics, the "a tree is retained while its root is some cell's value" claim, and the cell entry-type capability constants (direct vs indirect, writable vs read-only). |

## See also

- [[cask-cell-facets]] — ocaps.md's cryptographic capability-token model that elaborates this bank: the five facets (read/write/observe/delegate-read/delegate-write) answer cells.md's "read capabilities" open question, and `cap_token` is the bearer token of that model.
- [[cask-named-typed-pointer]] — the shared name/mode/reference shape cells and directory entries both realize.
- [[content-addressed-block-store]] — the immutable Merkle store a cell's value_hash roots.
- [[member-table-authorization]] — casknet's peer-admission capability layer, adjacent ocap machinery.
