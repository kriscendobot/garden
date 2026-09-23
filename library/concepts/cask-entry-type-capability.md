---
id: cask-entry-type-capability
aliases: ["entry type capability", "TypeCell", "TypeCellRead", "TypeCellPath", "TypeCellPathRead", "TypeBlob", "TypeDir", "TypeExecBlob", "TypeCompactBlob", "honest attenuation", "read-only cell", "cell read", "cell path", "cell path read", "structural capability", "facet over namespace", "entry type is the capability", "cask mkroot", "cask typeof", "write implies read", "CAS couples read and write", "attenuation lattice", "direct cell reference", "indirect cell reference"]
topics: [capability-security, content-addressed-storage]
status: current
---

# cask-entry-type-capability

CASK's **structural, local-namespace capability layer**: a directory entry's **type** field IS the capability, the object-capability facet that decides what the holder of a reference may *do* with the thing the entry names. Different type values over the same hash are different facets of the same content. What attenuations are honest is fixed entirely by **information hiding**, what the hash field reveals: a **content hash** is transparent (the hash is the content, so reads can never be restricted, only writes), while a **cell ID** or a **cell-path-descriptor hash** is opaque (the cell table mediates dereferencing, so read-only and subpath-scoped attenuations are enforceable). The load-bearing invariant is **write implies read**: cell mutation is compare-and-swap, which requires the current value, so a "write-only" cell would be dishonest and the only attenuation direction is read+write → read-only (never the reverse, never write-only). Nine types result: content-hash `TypeDir`/`TypeBlob`/`TypeExecBlob`/`TypeCompactBlob`/`TypeExecCompactBlob` (no meaningful attenuation), **direct** cells `TypeCell` (read+write root) and `TypeCellRead` (read root), and **indirect** cells `TypeCellPath` (read+write at a subpath) and `TypeCellPathRead` (read at a subpath) keyed by a cell path descriptor. `cask mkroot [--read-only]` mints an attenuated reference by walking to the cell boundary; `cask typeof` inspects the type. This structural layer composes with the future cryptographic capability-token layer (cells.md, ocaps.md): effective access is the intersection of the two.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [cask--cell-capabilities--overview-and-background](../sections/cask--cell-capabilities--overview-and-background.md) | The three-field entry; today's type conflates content-kind with capability; no read-only-cell expressible. |
| [cask--cell-capabilities--information-hiding-and-honest-attenuations](../sections/cask--cell-capabilities--information-hiding-and-honest-attenuations.md) | Content hash transparent, cell ID / descriptor opaque; the two honest attenuations; sealing removed. |
| [cask--cell-capabilities--cas-couples-read-and-write](../sections/cask--cell-capabilities--cas-couples-read-and-write.md) | Write implies read (CAS needs the current value); blind-write and server-mediated alternatives rejected. |
| [cask--cell-capabilities--entry-type-is-the-capability](../sections/cask--cell-capabilities--entry-type-is-the-capability.md) | The ocap-facet principle; direct vs indirect; the root/subpath × read/read-write lattice. |
| [cask--cell-capabilities--blob-and-directory-types](../sections/cask--cell-capabilities--blob-and-directory-types.md) | Content-hash types admit no read restriction; restrict a directory by putting it behind a cell. |
| [cask--cell-capabilities--cell-types-direct-and-indirect](../sections/cask--cell-capabilities--cell-types-direct-and-indirect.md) | TypeCell/TypeCellRead/TypeCellPath/TypeCellPathRead in detail; the nine-type summary table. |
| [cask--cell-capabilities--command-vocabulary-and-examples](../sections/cask--cell-capabilities--command-vocabulary-and-examples.md) | Resolution, read/write/cas/rm behavior, mkroot, typeof, ls; tiered-access worked examples. |
| [cask--cell-capabilities--relationship-to-capability-map](../sections/cask--cell-capabilities--relationship-to-capability-map.md) | Structural (entry type) vs cryptographic (token) capabilities compose; effective access is the intersection. |
| [cask--cell-capabilities--implementation-plan-and-open-questions](../sections/cask--cell-capabilities--implementation-plan-and-open-questions.md) | The ten implementation steps; transitive attenuation, append-only deferral, caching, CBOR, future types. |

## See also

- [[cask-cell-path-descriptor]] — the immutable Merkle tree behind an indirect cell reference (cell ID as link + CBOR path).
- [[cask-named-typed-pointer]] — the `name → (mode, reference)` shape; entry-type capability is the *authority* read of the same mode field that pointer concept reads as *interpretation metadata*.
- [[cask-cell-bank]] — the mutable cell layer (cap_token / cell_addr / value_hash); the cryptographic-network half of the capability model this concept's entry types are the structural-local half of.
- [[cask-cell-facets]] — ocaps.md's five-facet capability-token model; the cryptographic-network layer whose effective access **intersects** with this entry-type structural-local layer.
- [[member-table-authorization]] — casknet's peer-admission capability layer; adjacent cryptographic ocap machinery.
- [[object-capability]] — the general ocap model these entry-type facets are an instance of.
- [[principle-of-least-authority]] — read-only and subpath-scoped attenuations are POLA applied to the namespace.
