---
title: Glossary — data architecture, indexing/storage, distributed sync
source: notes/glossary.md
source_repo: dialog-db/dialog-db
source_commit: 054a7982ae47c06693c5ce6372a0844d1549a8d1
source_date: 2025-07-08
source_authors: [Argonaut Nautilus, Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [local-first-sync, datalog-query]
status: current
---

> Abstract: The glossary's architecture, indexing/storage, distributed-systems, and implementation terms, consolidated for grep. **Data architecture:** Schema-on-Query (interpret at query, not write, time — evolution without migration), Local-First (queries against a local instance, background sync), Causal Temporal Model (facts in causal timelines not a universal one, B-theory of time). **Indexing & storage:** EAV/AEV/VAE indexes (three Prolly-tree indexes covering every access pattern without planning), Index, Probabilistic B-Tree (Prolly Tree — deterministic content-addressed, insertion-order-independent), Index Node / Segment Node / Segment (content-addressed compressed chunks), Content-Addressed Storage, Blob Store (get/put by hash, S3/R2/IPFS/fs). **Distributed:** CRDT, Merkle-CRDT, Mutable Pointer (signed `did:key` HEAD), DID, Compare-and-Swap, Eventual Consistency, Pull, Partial Replication. **Implementation:** Artifact (Rust's term for a fact), Scalar, Branch Factor (16–32), Genesis (empty-DB revision).

Consolidated glossary entries (Data Architecture, Indexing & Storage, Distributed Systems, Advanced Concepts, Implementation Details), anchors preserved inline for lookup.

## Data Architecture
- **Schema-on-Query:** schema applied at query time, not write time; any valid fact is stored and interpreted per query, enabling schema evolution without migrations and different applications interpreting the same data differently.
- **Local-First:** all queries run against local database instances with background synchronization; responsive and functional offline, syncing opportunistically.
- **Causal Temporal Model:** facts exist in causal timelines rather than a universal one (inspired by physics' B-theory of time); distributed nodes operate independently and merge later, avoiding global clock synchronization.

## Indexing & Storage
- **EAV / AEV / VAE Index:** the three core indexes — EAV (entity primary sort; "what do we know about X?"), AEV (attribute primary; "which entities have attribute A?"), VAE (value primary; "which entities have name 'Alice'?", reverse lookups). Maintained simultaneously so all common patterns have optimal access paths without query planning or index selection.
- **Index:** generic term for the Probabilistic B-Tree structures maintaining sorted fact access.
- **Probabilistic B-Tree (Prolly Tree):** deterministic, content-addressed tree — same data produces the same tree regardless of insertion order (content-based splitting, not child count), making it optimal for replication.
- **Index Node:** internal Prolly-tree node with sorted keys and child references; guides traversal, holds no facts directly.
- **Segment Node:** node with inlined leaf entries (arrays of EAV/AEV/VAE key → fact pairs) — inlining reduces network requests by bundling logical leaves into one physical node.
- **Segment:** the base storage unit — a content-addressed, immutable, serialized, compressed chunk (the serialized form of a segment node); identified by content hash for dedup and caching.
- **Content-Addressed Storage:** data addressed by cryptographic hash rather than location; ensures integrity (tamper-detectable), enables dedup and efficient caching.
- **Blob Store:** hash-addressed storage for immutable blobs; DialogDB is agnostic to the implementation (any get/put-by-hash system — S3, R2, IPFS, filesystem), which has no knowledge of DialogDB's structure.

## Distributed Systems & Synchronization
- **CRDT:** DialogDB implements Merkle-CRDT properties for convergent replication — replicas update independently and converge without coordination or consensus.
- **Merkle-CRDT:** a CRDT using merkle trees; the structure enables efficient diff detection and transmitting only changed portions, Git-like.
- **Mutable Pointer:** a cryptographically-signed reference to the current root hash, identified by `did:key` — the database "HEAD" giving the immutable content-addressed structure a stable, updatable reference; updates must be signed.
- **DID:** identifier `did:method:identifier`; DialogDB currently supports `did:key` (identifier derived from a public key), a decentralized way to identify/authenticate instances.
- **Compare-and-Swap (CAS):** optimistic concurrency control for updating the mutable pointer — includes the expected current value, succeeds only if it matches, preventing lost updates; failure indicates concurrent changes to merge.
- **Eventual Consistency:** all replicas converge given the same facts, regardless of application order.
- **Pull:** retrieve the differential of facts from a known revision to the current state, fetching only what changed (Git-like).
- **Partial Replication:** replicate only needed subtrees rather than the whole database — privacy-preserving sync (fetch only accessible portions) and efficient operation on limited-storage devices.

## Advanced Concepts
- **Incremental View Maintenance:** a DBSP-based approach computing only the delta to a result set instead of re-running queries — for standing queries and subscriptions.
- **Top-Down Evaluation:** the current strategy — start from query goals and work backward, loading only needed portions rather than scanning entire indexes.

## Implementation Details
- **Artifact:** the Rust implementation's term for a fact (a semantic triple stored/retrieved), distinguishing the abstract concept from its concrete code representation.
- **Scalar:** the value component of a fact — null, boolean, number, string, bytes, attribute, or entity.
- **Branch Factor:** Prolly-tree configuration determining how many children an internal node can have (affects depth/performance); typical values 16–32.
- **Genesis:** the empty database revision, an IPLD Link for the empty byte array — the well-known initial state all databases derive from.

Source: [notes/glossary.md](https://github.com/dialog-db/dialog-db/blob/054a7982ae47c06693c5ce6372a0844d1549a8d1/notes/glossary.md) at commit `054a7982`.
