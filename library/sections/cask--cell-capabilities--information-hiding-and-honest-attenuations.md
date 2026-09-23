---
title: Information Hiding and the Hash Field
source: doc/design/cell-capabilities.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [capability-security, content-addressed-storage]
status: current
---

Abstract: The central design constraint: the security properties of any entry type depend on what its hash field reveals. A **content hash** is transparent (the hash *is* the content, so anyone who can read the parent directory block can load the content directly; reads can never be restricted, and attenuations can only restrict writes). A **cell ID** is opaque (a random identifier in the cell table's namespace, not loadable as a block; the cell indirection genuinely hides the content hash, so reads *can* be restricted). A **descriptor hash** has the same opaque property (loading it reveals the cell ID and path but not content). The honest attenuations are therefore exactly two: read-only on cell types, and subpath-scoped access on cell types. Write-only is dishonest because compare-and-swap requires reading.

The security properties of any entry type depend on what the hash field reveals. This is the central design constraint.

### Content hashes are transparent

When the hash field is a **content hash** (`TypeDir`, `TypeBlob`, etc.), anyone who can read the parent directory block can see the hash and load the content directly from the block store. The hash *is* the content: knowing it is equivalent to having the content. No entry type can restrict read access to content whose hash is visible. An entry type that claims to restrict reads while exposing the content hash provides only advisory enforcement and misleads the user into a false sense of security.

Consequence: **attenuations on content-hash entries can only restrict writes (entry replacement/removal), never reads.** The content is always readable by anyone who can see the entry.

### Cell IDs are opaque

When the hash field is a **cell ID** (`TypeCell`, `TypeCellRead`, etc.), the hash is a random identifier in the cell table's namespace. It is not a content hash: you cannot load a block with it. To discover the content, you must look up the cell ID in the cell table, which requires traversing the head block. The cell indirection genuinely hides the content hash.

Consequence: **attenuations on cell entries can restrict reads.** A `TypeCellRead` entry reveals the content (via cell table lookup) but prevents mutation.

### Descriptors are opaque

When the hash field is a **descriptor hash** (`TypeCellPath`, etc.), the hash is the content hash of a cell path descriptor block. Loading the descriptor reveals the cell ID (as a link) and the path segments (as CBOR data). But the cell ID alone does not reveal content: you still need cell table access to dereference it. The descriptor adds one level of indirection but does not leak content hashes.

Consequence: **attenuations on indirect cell entries have the same security properties as direct cell entries.** The descriptor is a content-addressed block, but its content is metadata (cell ID + path), not the actual data.

### Summary of honest attenuations

| Hash field | Read restriction? | Write restriction? |
|------------|-------------------|-------------------|
| Content hash | No: hash reveals content | No: content is immutable by hash |
| Cell ID | Yes: cell table required | Attenuate to read-only |
| Descriptor hash | Yes: cell table required | Attenuate to read-only |

The only honest attenuations are:

- **Read-only** on cell types: grant read access but prevent CAS. This is enforceable because the cell ID does not reveal the content hash.
- **Scoped access** on cell types: grant read or read+write access at a specific subpath via a cell path descriptor.

Write-only access is not an honest attenuation because CAS requires reading (see [cas-couples-read-and-write](cask--cell-capabilities--cas-couples-read-and-write.md)).

### Note on sealing

A previous version of this design included sealed entry types (`TypeBlobSeal`, `TypeDirSeal`, `TypeCellSeal`) that prevented entry replacement. These were removed because sealing provides only advisory enforcement: a user with write access to the parent directory can replace the entire directory, bypassing the seal. The same protection is better achieved by taking a snapshot: the content hash is an unforgeable reference to the exact content, and comparing hashes later verifies integrity.

Source: [doc/design/cell-capabilities.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/cell-capabilities.md) at commit `cdb975d8`.
