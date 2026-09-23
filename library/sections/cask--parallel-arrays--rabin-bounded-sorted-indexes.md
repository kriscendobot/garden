---
title: Rabin-Bounded Sorted Indexes
source: doc/design/parallel-arrays.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures, content-addressed-storage]
status: current
---

> Abstract: Tree-based sorted indexes (B-tree, splay) rebalance, and rebalancing can cascade up the Merkle tree, changing hashes at every level. CASK's alternative reuses the blob chunker's trick: apply **content-defined (Rabin) chunking** to a sorted sequence of (key, slot) records so chunk boundaries follow the data, not fixed offsets. Just as Rabin-chunked blobs survive local edits with only the affected chunk re-chunking, a Rabin-chunked sorted index survives a local insert or delete by re-chunking only the region around the change — entries before and after keep their boundaries, and the Merkle disturbance is local chunks only rather than a path-to-root-plus-siblings rebalance. Lookup and range scan stay O(log n)/excellent; the win is **no rebalancing**. The same deterministic-boundary property preserves the reducer guarantee: the operational-transform form (`SortedIndexOp{Keep, Skip, Inject}`) re-chunks its sorted output identically for identical inputs.

## How It Works

A sorted index is (key, slot) pairs in sorted order. Instead of a balanced tree: serialize entries as fixed-size records (key hash + slot index), apply Rabin fingerprinting to find chunk boundaries, store each chunk as a block, and build a tree of chunk hashes (like caskblob).

On insert: find the chunk containing the insertion point, insert there, and re-chunk only the affected region. Because boundaries are content-defined, entries before and after the insertion keep their boundaries; only the local region re-chunks — the same property that makes Rabin-chunked blobs stable under local edits.

## Comparison with B-Trees

| Property | B-Tree | Rabin-Chunked |
|----------|--------|---------------|
| Lookup | O(log n) | O(log n) |
| Insert | O(log n) + rebalance | O(log n) + local re-chunk |
| Delete | O(log n) + rebalance | O(log n) + local re-chunk |
| Merkle disturbance | Path to root + siblings | Local chunks only |
| Range scan | Excellent | Excellent |
| Rebalancing | Required | Never |
| Chunk sizes | Fixed (node size) | Variable (content-defined) |

The key advantage is **no rebalancing**: B-tree rebalancing can cascade up the tree, changing hashes at every level, while Rabin chunking localizes changes.

## Operational Transforms and Tuning

Like caskarray, sorted indexes support operational transforms:

```go
type SortedIndexOp struct {
    Keep   uint64   // keep next n entries
    Skip   uint64   // skip next n entries
    Inject []Entry  // inject sorted entries (must be in order)
}
```

The transform walks the prior index and op stream in lockstep, outputs kept and injected entries in sorted order, re-chunks via Rabin fingerprinting, and rebuilds the tree of chunks. Deterministic boundaries preserve the reducer property. Rabin parameters (avg/min/max entries per chunk) trade insert locality against tree depth: smaller chunks localize updates; larger chunks reduce depth for read-heavy workloads. The IDL exposes this as `index byTime: rabin_sorted(timestamp) { avg_chunk: 64, min_chunk: 16, max_chunk: 256 }`. Good fit: large, update-heavy, sync-replicated, range-scan, or append-heavy (logs, time series) indexes; less ideal for tiny indexes, point-lookup-only (use a hash index), or algorithms needing an exact tree shape.

Source: [doc/design/parallel-arrays.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/parallel-arrays.md) at commit `cdb975d8`.
