---
title: Blob store, DID:key mutable pointers, and decoupled architecture
source: notes/architecture overview.md
source_repo: dialog-db/dialog-db
source_commit: f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [content-addressed-storage, local-first-sync, ucan-authorization]
status: current
---

> Abstract: Persistence is any hash-addressed **blob store** (S3, R2, IPFS) that supports only get/put — no query capability, no knowledge of the tree structure or semantics; it is "merely a buffer in the cloud." Mutability over this immutable substrate comes from **DID:key mutable pointers**: cryptographically signed pointers to the current root hash, whose only job is to verify updates are authorized (signed with the private key or a delegation) and to prevent unintended overrides via **compare-and-swap** (STM-like optimistic concurrency). The three components — blob store, mutable pointer, Probabilistic B-Tree — are **fully decoupled**, each unaware of the others, which enables Git-like multi-remote push/pull, independent upgrade, clear security boundaries, and layer-local encryption.

DialogDB uses simple **blob storage** for persistence:

- **Hash-addressed blob storage**: any system that can store and retrieve immutable blobs by hash (S3, R2, IPFS).
- **No query capabilities required**: only get/put operations.
- **Efficient caching**: immutable blobs can be cached at any level without invalidation concerns.
- **On-demand replication**: only the needed segments are fetched.
- **Storage agnostic**: the blob store is completely unaware of the tree structure or semantics.

The blob store "acts merely as a buffer in the cloud, storing content-addressed blobs without any knowledge of how they relate to each other or what they contain."

To enable mutability in an immutable data structure, DialogDB uses **DID:key mutable pointers**:

- **Cryptographically signed pointers**, identified by DID:Key identifiers (Decentralized Identifiers).
- **Root references**: point to the current root hash of the Probabilistic B-Tree.
- **Access control mechanism**: updates require signing with the private key or a delegation.
- **Convergence mechanism**: lets concurrent actors coordinate on the latest state.
- **STM-like concurrency**: optimistic concurrency control via **compare-and-swap** operations.

The mutable pointer is completely unaware of the blob store or tree structure; its only job is to verify updates are properly authorized and ensure updates don't unintentionally override current state. A write flow: create new segments and tree nodes, store new blobs, then issue a signed + CAS pointer update; if the CAS fails (a concurrent update moved the hash), pull latest, merge locally, and retry.

The three components are fully **decoupled**, which enables:

1. **Multiple independent blob stores**: users push/pull from multiple remotes like Git; each store sees only encrypted content-addressed blobs; storage diversity gives resilience.
2. **Independent mutable pointer**: acts like Git's HEAD reference; CAS semantics prevent unintended overrides; its only job is to authorize updates and prevent conflicts.
3. **Flexible tree implementation**: independent of storage and pointer mechanisms; can be optimized without changing others; encryption can be implemented at this layer only.

This strict separation of concerns lets components be replaced or upgraded independently, lets multiple implementations interoperate, defines clear security boundaries, and localizes specialized optimizations.

Source: [notes/architecture overview.md](https://github.com/dialog-db/dialog-db/blob/f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53/notes/architecture%20overview.md) at commit `f777fe7c`.
