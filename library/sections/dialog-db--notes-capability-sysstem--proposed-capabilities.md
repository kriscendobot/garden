---
title: Proposed capability set (Archive, Memory, Acquire)
source: notes/capability-sysstem.md
source_repo: dialog-db/dialog-db
source_commit: f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [ucan-authorization, capability-security, content-addressed-storage]
status: current
---

> Abstract: The proposed concrete capabilities partition into two ability families over a repository subject plus a meta-capability. **Archive** (content-addressed blob access, policy-scoped by `Catalog`): `Get { digest: Blake3Hash }` returns the content for a digest; `Put { digest, content }` stores content. **Memory** (mutable-cell access, policy-scoped by `MemorySpace` then `Cell`): `Resolve` returns a cell's current `(Content, Edition)` or `None`; `Publish { content, edition }` updates a cell with **compare-and-swap** semantics (an unexpected edition errors; `content: None` unpublishes). The meta-capability **`Acquire<Access>`** returns a `Delegation<Access>` for a requested capability, the authorization step by which an effectful function obtains authority for the active principal. The Archive/Memory split is exactly the blob-store-plus-mutable-pointer decoupling from the architecture overview, expressed as capabilities.

The proposed capabilities, over a `RepositoryAccess = Subject`:

**Archive** family (content-addressed blobs), scoped by a `Catalog` policy:

```rust
#[derive(Ability)] struct Archive;
type ArchiveAccess = Access<Archive, RepositoryAccess>;
#[derive(Policy)] struct Catalog { pub catalog: String }
type CatalogAccess = Access<Catalog, ArchiveAccess>;

/// Retrieves content corresponding to the requested digest
#[derive(Ability)] pub struct Get { pub digest: Blake3Hash }
impl Effect for Access<Get, CatalogAccess> { type Output = Result<Vec<u8>, ArchiveError>; }

/// Stores given content in the archive
#[derive(Ability)] pub struct Put { pub digest: Blake3Hash, pub content: Vec<u8> }
impl Effect for Access<Put, CatalogAccess> { type Output = Result<(), ArchiveError>; }
```

**Memory** family (mutable cells), scoped by `MemorySpace` then `Cell`:

```rust
type MemoryAccess = Access<Memory, RepositoryAccess>;
type MemorySpaceAccess = Access<MemorySpace, MemoryAccess>; // MemorySpace { memory: String }
type CellAccess = Access<Cell, MemorySpace>;                // Cell { cell: String }

/// Resolves a memory cell, returning its current content and edition (None if empty)
#[derive(Ability)] pub struct Resolve;
impl Effect for Access<Resolve, CellAccess> {
  type Output = Result<Option<(Content, Edition)>, MemoryError>;
}

/// Updates cell content with CAS semantics. If the cell's edition differs from
/// the expected edition it errors; otherwise returns the new edition. content: None unpublishes.
#[derive(Ability)] pub struct Publish { pub content: Option<Vec<u8>>, pub edition: Option<Vec<u8>> }
impl Effect for Access<Publish, CellAccess> { type Output = Result<Option<Vec<u8>>, MemoryError>; }
```

The meta-capability **`Acquire`** obtains a delegation for a requested capability:

```rust
#[derive(Ability)] pub struct Capability;
pub type CapabilityAccess = Access<Capability, Subject>;

#[derive(Authorize)] pub struct Acquire<Access> { access: Claim<Access> }
/// Acquires delegation for a requested capability
impl Effect for Access<Acquire, CapabilityAccess> {
  type Output = Result<Delegation<Access>, AuthorizationError>;
}
```

The Archive-versus-Memory partition is the capability-shaped restatement of the architecture overview's decoupling: **Archive** is the content-addressed blob store (get/put by hash), **Memory** is the DID:key mutable pointer (resolve/publish a cell with CAS on an `Edition`). Authority to each is a separate delegable capability, so a sync service can be handed Archive-only access while cell-publish authority stays with the owner.

Source: [notes/capability-sysstem.md](https://github.com/dialog-db/dialog-db/blob/f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53/notes/capability-sysstem.md) at commit `f777fe7c`.
