---
title: Merkle-CRDT properties and query-time merge semantics
source: notes/architecture overview.md
source_repo: dialog-db/dialog-db
source_commit: f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [change-propagation, local-first-sync]
status: current
---

> Abstract: The causal references between facts form a **[Merkle-CRDT]** (a Merkle-DAG that is also a conflict-free replicated data type): each change references its predecessor, forming a directed acyclic graph; different **merge strategies** (last-write-wins, set-based, custom) can be applied **at query time**; all replicas converge when the same facts are present (eventual consistency); and changes can be made offline and merged later. Crucially, CRDTs are expressed through Datalog queries — giving applications the flexibility to choose appropriate merge semantics for different fact types at query time, rather than hardcoding them into the database. Concurrent divergent changes reconcile in Git-like fashion (a merged state derived from both branches).

The causal references between facts form a [Merkle-CRDT] (Conflict-free Replicated Data Type):

- **Causality tracking**: each change references its predecessor, forming a directed acyclic graph.
- **Query-time merge semantics**: different merge strategies (last-write-wins, set-based, etc.) can be applied at query time.
- **Eventual consistency**: all replicas converge when the same facts are present.
- **Offline operation**: changes can be made offline and merged later.

The pivotal design decision: **CRDTs are expressed through Datalog queries**, giving applications the flexibility to choose appropriate merge semantics for different types of facts at query time, rather than being hardcoded into the database. Concretely the query-time strategies include:

- **Last-write-wins**: take the most recent value for a given attribute.
- **Set-based**: treat multi-valued attributes as sets to be merged.
- **Custom logic**: apply domain-specific merge functions.

When concurrent changes occur, DialogDB employs **Git-like workflows**: an initial state forks into Change A (device 1) and Change B (device 2), which reconcile into a merged state. Causally related changes maintain their order; the audit trail preserves all changes so conflict resolution is traceable.

This is the merge-strategy-at-read complement to the append-only fact model: because the store only grows and every fact carries its causal predecessor, "which value wins" is a reader's choice, not a writer's destructive commitment.

Source: [notes/architecture overview.md](https://github.com/dialog-db/dialog-db/blob/f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53/notes/architecture%20overview.md) at commit `f777fe7c`.

[Merkle-CRDT]: https://research.protocol.ai/publications/merkle-crdts-merkle-dags-meet-crdts/psaras2020.pdf
