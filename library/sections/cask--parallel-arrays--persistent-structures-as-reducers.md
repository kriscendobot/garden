---
title: Persistent CASK Structures as Reducers
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

> Abstract: How the in-memory parallel-array patterns translate to persistent CASK structures. Every CASK operation is a **reducer** with the signature `Operation(ctx, store, root Hash, args...) (Hash, error)`: it takes the current state hash plus arguments and returns a new state hash, a deterministic pure function that enables replay, verification, and composition (chain operations by feeding output hash to the next input). The design goal is minimal Merkle-tree disturbance — operations should modify a single leaf-to-root path, never shift large data ranges. Four persistent structures realize the in-memory patterns: **CaskHeap** (priority queue, Push/Pop/Peek/Fix touch one O(log n) path), **CaskAllocator** (swap-to-end free list, Alloc/Free touch O(log n) in the entities array only), **CaskIndexedHeap** (allocator + heap = the full sendbuffer pattern with stable external slot references), and **CaskLinkedList** (doubly-linked list for LRU caches). All exploit caskarray's 32-way trie, giving O(log₃₂ n) depth so even large structures stay shallow.

## The Reducer Pattern

```go
func Operation(ctx context.Context, store cask.Store, root cask.Hash, args...) (cask.Hash, error)
```

Input is the current state hash plus arguments; output is the new state hash (or error); the function is a deterministic pure function of its inputs. This enables **replay** (same op on same state → same result), **verification** (anyone can check the op was applied correctly), and **composition** (chain ops by passing output hash as the next input).

## Minimizing Merkle Disturbance

Operations that move data disturb the tree, propagating hash changes to the root. **Good**: operations that modify a single leaf-to-root path. **Bad**: operations that shift large data ranges. The persistent structures below are designed so common operations touch minimal tree nodes.

## The Four Persistent Structures

- **CaskHeap** — persistent priority queue (`Push`/`Pop`/`Peek`/`Fix`), each touching one O(log n) path. The caskarray's 32-way trie keeps even large heaps shallow; no bulk data movement.
- **CaskAllocator** — persistent free list using swap-to-end. Root is a caskmap of `length`, `capacity`, `entities` (caskarray of indexes), `values` (caskarray of value hashes). `Alloc`/`Free` each touch O(log n) nodes in the entities array (one swap) plus O(1) for the length update; the values array is untouched.
- **CaskIndexedHeap** — allocator + heap combined for the full sendbuffer pattern (`values`, `heap`, `coHeap`, `entities`). `Put`/`Top`/`PopTop`/`Update`/`Remove`; values keep stable slots usable as external references, only indexes move.
- **CaskLinkedList** — persistent doubly-linked list (`head`, `tail`, `length`, `next`, `prev`, `values`) for LRU caches and stable iteration. `PushFront`/`PushBack`/`MoveToFront`/`Remove` touch O(log n) for index updates plus O(1) for head/tail pointers.

## Cost Comparison

| Operation | caskarray | caskheap | caskallocator |
|-----------|-----------|----------|---------------|
| Append | O(log n) | O(log n) | N/A |
| Set at index | O(log n) | O(log n) | O(log n) |
| Insert at index | O(n) ⚠️ | N/A | N/A |
| Delete at index | O(n) ⚠️ | N/A | N/A |
| Alloc/Free | N/A | N/A | O(log n) |
| Find min/max | O(n) | O(1) | N/A |

The ⚠️ operations disturb large tree portions; the heap and allocator avoid them by design. These structures apply directly to block storage: a caskallocator for block allocation, a caskindexedheap for GC/eviction/scheduling priority queues, and a casklinkedlist for an LRU block cache. Structures **compose** by storing root hashes in a parent caskmap, and multi-structure updates are atomic via a single CAS on a recomputed composite root.

Source: [doc/design/parallel-arrays.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/parallel-arrays.md) at commit `cdb975d8`.
