---
id: merkle-crdt
aliases: [merkle-crdt, merkle crdt, merkle-dag crdt, causal fact dag, query-time merge]
topics: [change-propagation, local-first-sync]
---

# merkle-crdt

A **Merkle-CRDT** is a Merkle-DAG that is also a conflict-free replicated data type: each change references its predecessor by content hash, forming a directed acyclic graph that converges when all replicas hold the same nodes. In Dialog the causal `cause` references between facts form the Merkle-CRDT, and — the distinctive design choice — **merge strategy is applied at query time via Datalog** (last-write-wins, set-based, or custom) rather than baked into the store, so different fact types can reconcile differently. Concurrent divergent changes merge Git-style into a derived state while preserving the full audit trail.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [dialog-db--notes-architecture-overview--merkle-crdt-merge-semantics](../sections/dialog-db--notes-architecture-overview--merkle-crdt-merge-semantics.md) | Causal fact references form a Merkle-CRDT; merge strategy chosen at query time. |
| [dialog-db--notes-architecture-overview--causal-temporal-model](../sections/dialog-db--notes-architecture-overview--causal-temporal-model.md) | The B-theory causal timelines the CRDT DAG is built from. |

## See also

- [[prolly-tree]] — the content-addressed tree the Merkle-CRDT rides on.
- [[fact-triple]] — the `{the, of, is, cause}` atom whose `cause` edge forms the DAG.
- [[crdt-in-formula-persistence]] — where a bidirectional CRDT was considered and rejected in Endo's persistence design.
