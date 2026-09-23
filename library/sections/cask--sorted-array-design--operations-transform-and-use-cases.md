---
title: Operations, Transform, and Use Cases
source: doc/design/sorted-array-design.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures, content-addressed-storage]
status: current
---

> Abstract: The query/mutation surface of the Rabin-chunked `sortedarray` and the design decision to operate directly on the block store. `Has`/`Get` binary-search the `chunks_tree` to the owning chunk then binary-search within it (O(log n) + O(log c)). `Insert` and `Delete` find the chunk, edit in sort order, then re-chunk only the affected region — splitting at Rabin boundaries if over `max_chunk`, merging with a neighbor if under `min_chunk` — and rewrite the chunk hashes up `chunks_tree`. `Range` and `ForEach` iterate chunks in order. Bulk edits reuse the `caskarray` transform pattern: `Transform(root, ops)` with Keep/Skip/Inject(sorted entries) walks the prior array and ops in lockstep, re-chunks the output via Rabin fingerprinting, and builds a new chunks tree in one pass. Against alternatives, the structure matches a B-tree's O(log n) lookup and beats it on **Merkle locality** ("excellent" vs B-tree's rebalance cascades) while keeping sorted iteration `hashtree` cannot offer. Chunk parameters tune the size/locality trade (membership avg=64/min=16/max=256; large indexes 128/32/512; append-heavy logs 256/64/1024). The mutation strategy is **Option B, direct-to-store** (every mutation updates blocks immediately) chosen over an in-memory buffer for syncability, simplicity, correctness-first, and reducer-pattern fit; a read cache and batch mutations are deferred optimizations. Use cases: membership (node_id → peer_info_index, 40-byte entries), pinned-roots hash sets (32-byte entries, supports set algebra and incremental GC), and event-log indexes (timestamp → event_index, 16-byte entries).

## Query and mutation operations

- **`Has(key) → bool`** / **`Get(key) → (entry, bool)`**: binary-search `chunks_tree` to the chunk containing `key`, load it, binary-search within. Time O(log n) chunk lookups + O(log c) within-chunk.
- **`Insert(entry) → new_root`**: binary-search to the insertion point, load the affected chunk, insert in sort order, then re-chunk the region (split at Rabin boundaries if over `max_chunk`, merge with a neighbor if under `min_chunk`), update `chunks_tree` with the new chunk hashes, return the new root.
- **`Delete(key) → new_root`**: find the owning chunk, remove the entry, re-chunk if needed (merge under `min_chunk`, re-apply Rabin boundaries to the merged region), update `chunks_tree`, return the new root.
- **`Range(start_key, end_key) → iterator`**: find the start chunk, iterate from `start_key` through subsequent chunks until past `end_key`.
- **`ForEach(fn)`**: iterate all chunks in order, all entries within each, calling `fn(entry)`.

## Operational transform for bulk edits

Bulk operations reuse the `caskarray` transform shape, with `Inject` entries required to be sorted:

```go
type Op struct {
    Keep   uint64   // keep N entries from input
    Skip   uint64   // skip N entries from input
    Inject []Entry  // inject entries (must be sorted)
}
func Transform(ctx, store, root, ops []Op) (Hash, error)
```

The transform walks the prior array and ops in lockstep, outputs kept and injected entries in sorted order, re-chunks the output with Rabin fingerprinting, and builds a new `chunks_tree` — efficient bulk insert/delete without repeated single-entry operations.

## Comparison with alternatives

| Property | B-Tree | hashtree | Rabin Sorted |
|---|---|---|---|
| Lookup | O(log n) | O(1) amortized | O(log n) |
| Insert | O(log n) + rebalance | O(1) amortized | O(log n) + local re-chunk |
| Delete | O(log n) + rebalance | O(1) amortized | O(log n) + local re-chunk |
| Range query | O(log n + k) | O(n) | O(log n + k) |
| Merkle locality | Poor (rebalance cascades) | Good | Excellent |
| Sorted iteration | Yes | No | Yes |

Use the Rabin sorted array when you need sorted order or range queries, frequent mutations, Merkle stability (sync, diff), or large collections; use `hashtree` when key lookup is primary, order is unneeded, and collections are smaller.

## Configuration

| Parameter | Small chunks | Large chunks |
|---|---|---|
| avg_chunk | 32-64 | 256-512 |
| Lookup cost | more tree levels | larger chunk loads |
| Insert cost | smaller re-chunks | larger re-chunks |
| Merkle locality | better | worse |
| Space overhead | higher (more chunk headers) | lower |

Recommendations: membership tables avg=64/min=16/max=256; large indexes 128/32/512; append-heavy logs 256/64/1024. Entries should be fixed-size; for variable-size values, store a hash reference and keep the data in a parallel array.

## Mutation strategy: direct-to-store (Option B)

Two approaches were weighed: **Option A** keeps an in-memory sorted slice and periodically flushes (fast mutations, batched writes, but crash-loss risk and flush-coordination complexity); **Option B** sends every mutation directly to the block structure. The design picks **Option B (direct-to-store)** for: **syncability** (always consistent and diffable, peers can sync at any time), **simplicity** (no in-memory state, no flush logic, no crash recovery), **correctness first** (get the algorithms right on the persistent structure; caching and batching come later), and **reducer-pattern fit** ((root, args) → new_root). Membership changes are infrequent and chunks load efficiently, so the slower individual mutations are acceptable. Two deferred optimizations are noted: a read-only LRU chunk cache (invalidated on root change, never complicating mutations) and batch mutations via the existing `Transform` (one Inject instead of N inserts).

## Use cases

- **Membership** (`node_id → peer_info_index`): entry_size 40, key_size 32, value 8-byte uint64 index, avg_chunk 64. Enables peer lookup, range queries for sharding, and stable sync.
- **Pinned roots** (hash set): entry_size 32, key_size 32, pure set, avg_chunk 128. Enables membership tests, set operations (union/intersection/difference), and incremental GC over ordered hashes.
- **Event-log index** (`timestamp → event_index`): entry_size 16, key_size 8 (big-endian timestamp), value 8-byte index, avg_chunk 256. Enables time-range queries, efficient append (timestamps increase), historical replay.

Status PLANNED: dependencies are `arraytree` (exists) and a Rabin fingerprint from the `blob` package; packages to create are `sortedarray` and possibly `sortedset`.

Source: [doc/design/sorted-array-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/sorted-array-design.md) at commit `cdb975d8`.
