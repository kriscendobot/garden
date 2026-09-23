---
title: Snapshot GC with Mandatory Quarantine — Data Model and Algorithm
source: doc/design/gc-concurrent-design.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [content-addressed-storage]
status: current
---

> Abstract: A concurrency-safe garbage collector for CASK stores under three assumptions: each store is sweepable (List + Delete), each store has a single root hash at any time, and roots can be atomically swapped while GC runs. The collector takes a **single root snapshot at GC start** (`Rs`), marks everything reachable from `Rs` into a `RetainSet`, sweeps everything else, then flushes quarantine. Root updates during the cycle do **not** affect it. The key safety mechanism is **mandatory quarantine**: all new writes during GC are routed to a quarantine store and only flushed into the primary after the sweep completes, so GC never sweeps a post-snapshot block that the snapshot cannot reach. The governing rule is **install-after-store** — a new root may be published only after every block reachable from it is fully stored (including the quarantine flush). The data model names `RootRef` (atomic `(hash, epoch)`), `Store`, `CollectibleStore` (Store + List + Delete), `CollectorStore` (the quarantining wrapper over a primary plus a quarantine store, e.g. diskstore primary + memstore quarantine), and `RetainSet`.

This document proposes a concurrency-safe garbage collector for CASK stores under the assumptions: each store is sweepable (List + delete capability); each store has **a single root hash** at any given time; roots can be **atomically swapped** while GC runs. The design ensures that **operations in flight** are not invalidated by GC, even as a new root is installed.

## Summary

Use a **snapshot GC with mandatory quarantine**: pick a single root snapshot at GC start, retain all blocks reachable from that root, and sweep everything else. Root updates are allowed concurrently; they do **not** affect the current GC cycle.

During GC, **all new writes are quarantined** and only flushed into the store after the GC pass completes. This prevents a GC pass from sweeping blocks that were written after the snapshot but are not reachable from that snapshot.

Key rule: **install-after-store** — a new root may be published only after all blocks reachable from that root are fully stored (including quarantine flush).

## Data Model

- **RootRef**: atomically stores `(hash, epoch)`. Epoch increments on every root swap.
- **Store**: CAS with `Load` and `Store`.
- **CollectibleStore**: Store + `List` + `Delete`, used by GC internals.
- **CollectorStore**: a wrapper store that quarantines writes during GC and flushes them after the GC completes. It wraps a **primary Store** and a **quarantine Store** (example: primary = diskstore, quarantine = memstore).
- **RetainSet**: set of hashes discovered during marking.

## Algorithm

1. **Begin GC (snapshot)**: Atomically read `RootRef` → `(Rs, Es)`. `Rs` is the **snapshot root** for this GC cycle.
2. **Mark**: Traverse all blocks reachable from `Rs`; add each block hash to `RetainSet`.
3. **Sweep**: For each hash in `Store.List`, if not in `RetainSet`, delete it.
4. **End (flush quarantine)**: Flush all quarantined blocks into the store.
5. **End**: GC completes; any later root will be retained in a later cycle.

Source: [doc/design/gc-concurrent-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/gc-concurrent-design.md) at commit `cdb975d8`.
