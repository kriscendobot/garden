---
title: Context — the top-down engine and the prolly-tree store interface
source: notes/dbsp.md
source_repo: dialog-db/dialog-db
source_commit: ff9f03bf29edebb429a37de62eac9bcf99312131
source_date: 2025-06-03
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [change-propagation, content-addressed-storage]
status: current
---

> Abstract: The starting point for Dialog's DBSP / incremental-view-maintenance exploration: a working Datalog engine that evaluates **top-down** (a query planner that reorders conjuncts to minimize search space, a cycle analyzer that rejects non-evaluable queries at planning time, and selective data loading that pulls only the relevant slice of a possibly-huge fact graph). Storage is Datomic-like but over **probabilistic b-trees (prolly trees)**: hash-addressed blobs in commodity storage (S3), partial replication at query time through a three-level cache hierarchy (local LRU → persisted partial replica → remote blob store), a mutable pointer to the latest store-tree root (the "revision" concept), and EAV/AEV/VAE indexes with embedded values. The key insight that motivates the whole exploration: because a prolly tree's structure is content-defined, when the root pointer changes the system can selectively replicate *only the changed subtrees relevant to a query*, achieving partial replication of exactly the data an incremental update needs. The store's interface is captured as a TypeScript contract: a `Fact` is a `{the, of, is?, cause?}` semantic triple (attribute namespaced `${string}/${string}`, entity an arbitrary URI, scalar the usual primitives, cause a 32-byte hash reference forming a partial order), and `Source.pull(selector, revision?)` returns a `Differential` — a revision plus a z-set `Map<Fact, number>` of signed weights.

Dialog has a working Datalog query engine over a data store of facts represented as semantic quads, using a **top-down evaluation strategy** with:

1. **Query Planner**: reorders conjuncts to minimize search space.
2. **Cycle Analyzer**: detects cycles during planning and rejects non-evaluable queries.
3. **Selective Data Loading**: loads only the relevant subset of the store during queries (can be a tiny slice of huge fact graphs).

**Storage Architecture**: similar to Datomic but using **probabilistic b-trees (prolly trees)** instead of traditional b-trees:

- **Hash-addressed blobs** in commodity blob storage (e.g., S3).
- **Partial replication** at query time with hierarchical caching: local LRU cache (fastest) → persisted partial replica cache (fallback) → remote blob store (final fallback).
- **Mutable pointer** to the latest store tree root (the revision concept).
- **EAV, AEV, VAE indexes** with embedded values for efficient access patterns.

**Key insight**: incremental view maintenance can leverage prolly-tree properties — when the root pointer changes, the system can selectively replicate only the changed subtrees relevant to its queries, achieving partial replication of just the data needed for incremental updates.

## Store interaction interface

```ts
interface Fact {
  the: Attribute
  of: Entity
  is?: Scalar
  cause?: Reference<Fact>   // optional causal reference forming a partial order
}
type Attribute = `${string}/${string}`;   // namespaced predicate
type Entity = URI;                          // subject: arbitrary URI
type Scalar = null | boolean | number | bigint | string | Uint8Array | Attribute | Entity;

interface Selector { the?: Attribute; of?: Entity; is?: Scalar }
type Revision = Uint8Array;                  // hash of the data source at a point in time

interface Source {
  // Retrieves a differential of the facts from the provided revision.
  pull(selector: Selector, revision?: Revision): Promise<Differential>
}

type Change =
  | { assert: Fact, retract?: void }
  | { retract: Fact, assert?: void }

interface Differential {
  revision: Revision          // last revision of the data source
  weights: Map<Fact, number>  // effectively a z-set of facts
}
```

Source: [notes/dbsp.md](https://github.com/dialog-db/dialog-db/blob/ff9f03bf29edebb429a37de62eac9bcf99312131/notes/dbsp.md) at commit `ff9f03bf`.
