---
source: doc/design/cell-capabilities.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
section_count: 11
status: current
---

CASK's "Entry Type Capabilities" proposal: how a directory entry's **type** field encodes a **capability**, the operations the holder of a reference may perform on the thing it names. The central design constraint is information hiding: the security properties of an entry type depend entirely on what its hash field reveals. Content hashes are transparent (the hash *is* the content, so reads can never be restricted), while cell IDs and cell-path-descriptor hashes are opaque (the cell table mediates dereferencing, so read-only and subpath-scoped attenuations become enforceable). Write access to a cell implies read access because compare-and-swap requires reading the current value, so the only honest attenuation direction on cells is from read+write down to read-only. The proposal defines nine entry types (direct cells `TypeCell`/`TypeCellRead` keyed by cell ID, indirect cells `TypeCellPath`/`TypeCellPathRead` keyed by a cell path descriptor that carries the cell ID as a Merkle link plus CBOR path segments, plus the existing blob and directory types), the attenuation lattice over them, the `cask mkroot`/`typeof` commands, and how this *structural* local-namespace capability layer composes with the future *cryptographic* network capability-token layer described in cells.md and ocaps.md.

This is the next elaboration in the cell/entry lineage after [cells.md](cask--cells.md) and [cells-and-entries.md](cask--cells-and-entries.md): it takes the implementation-concrete view (cell ID, cell table, CAS) where the earlier docs took the abstract/distributed view (cap_token, cell_addr, value_hash, cell bank). The three are kept co-`current`; cell-capabilities.md does not supersede the earlier two, and it names them as complementary (entry types are structural and local; capability tokens are cryptographic and cross-peer; effective access is the intersection).

| Section | Topics | Status |
|---------|--------|--------|
| [overview-and-background](../sections/cask--cell-capabilities--overview-and-background.md) | content-addressed-storage, capability-security | current |
| [information-hiding-and-honest-attenuations](../sections/cask--cell-capabilities--information-hiding-and-honest-attenuations.md) | capability-security, content-addressed-storage | current |
| [cas-couples-read-and-write](../sections/cask--cell-capabilities--cas-couples-read-and-write.md) | capability-security | current |
| [entry-type-is-the-capability](../sections/cask--cell-capabilities--entry-type-is-the-capability.md) | capability-security | current |
| [cell-path-descriptor-format](../sections/cask--cell-capabilities--cell-path-descriptor-format.md) | content-addressed-storage, data-structures | current |
| [blob-and-directory-types](../sections/cask--cell-capabilities--blob-and-directory-types.md) | content-addressed-storage, capability-security | current |
| [cell-types-direct-and-indirect](../sections/cask--cell-capabilities--cell-types-direct-and-indirect.md) | capability-security, content-addressed-storage | current |
| [content-model-changes](../sections/cask--cell-capabilities--content-model-changes.md) | content-addressed-storage, data-structures | current |
| [command-vocabulary-and-examples](../sections/cask--cell-capabilities--command-vocabulary-and-examples.md) | content-addressed-storage, capability-security | current |
| [relationship-to-capability-map](../sections/cask--cell-capabilities--relationship-to-capability-map.md) | capability-security | current |
| [implementation-plan-and-open-questions](../sections/cask--cell-capabilities--implementation-plan-and-open-questions.md) | capability-security, content-addressed-storage | current |

Source: [doc/design/cell-capabilities.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/cell-capabilities.md) at commit `cdb975d8`.
