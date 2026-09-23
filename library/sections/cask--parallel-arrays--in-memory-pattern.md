---
title: In-Memory Parallel Arrays
source: doc/design/parallel-arrays.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures]
status: current
---

> Abstract: CASK's central in-memory layout pattern. A parallel-array structure stores a table of rows as flat columns: **value columns** (`deadlines[]`, `priorities[]`), **index arrays** that reorder access without moving values (`minDeadlines[]`), and **co-index arrays** that give O(1) reverse lookup (`coMinDeadlines[i]` = where value `i` sits in the heap). The governing invariant is *values stay in place; indexes move*, which lets multiple independent orderings (a deadline heap and a priority heap) coexist over the same data with no copying. Allocation appends to the end of an `entities` free-list partition (active indexes `< length`, free `>= length`); deallocation swaps the victim to the boundary and shrinks `length`. The whole pattern rests on one primitive, `Swap(values, coValues, i, j)`, which exchanges two index entries while restoring `coValues[values[i]] == i`. Used throughout CASK in `sendbuffer` and `recvbuffer`.

## The Core Pattern

```go
type Buffer struct {
    capacity int
    length   int
    // Value columns (the actual data)
    deadlines  []uint64
    priorities []uint64
    // Index array: heap[i] = index into values
    // Co-index: coHeap[i] = position in heap where values[i] lives
    minDeadlines   []int
    coMinDeadlines []int
}
```

Key insight: **values stay in place; indexes move** — multiple orderings of the same data without copying values.

## Allocation: Append to End

The `entities` array partitions indexes into active (`< length`) and free (`>= length`). `Put` takes the next free slot, swaps it into the active partition of each index, expands the active region, sets the value, and fixes the heap.

## Deallocation: Swap to End

`evict(i)` resets the value to a sentinel, shrinks the active region, swaps the entity out of the active partition of every index, then fixes the heap for the element swapped into the freed position. The slot becomes available for future allocation.

## The Swap Primitive

```go
func Swap[T ~int](values []T, coValues []int, i, j int) {
    a, b := values[i], values[j]
    values[i], values[j] = values[j], values[i]
    coValues[int(a)], coValues[int(b)] = j, i
}
```

It swaps two elements in an index array and updates the co-index to maintain `coValues[values[i]] == i` for all `i`.

## Heap, List, and Selection Guidance

- **Heap index**: `heap[0]` is the index of the min/max value; children of `heap[i]` at `heap[2i+1]`, `heap[2i+2]`; `coHeap[j]` says where `values[j]` appears in the heap. `Fix` restores the heap property by sifting; the value stays put, only the index moves.
- **Circular doubly-linked list**: `next[]`/`prev[]`/`head` as parallel arrays, for stable iteration order during modification (move element to front/back without disturbing others) — the basis for LRU ordering.

| Pattern | Use case |
|---------|----------|
| Swap-to-end allocation | Fixed capacity, fast alloc/free, no ordering |
| Heap index | Priority queue, find min/max in O(1) |
| Circular linked list | Stable iteration, LRU ordering |
| Multiple indexes | Same data, multiple orderings (deadline + priority) |

Source: [doc/design/parallel-arrays.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/parallel-arrays.md) at commit `cdb975d8`.
