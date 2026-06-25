---
title: The Store interface and span-tracked async completion
source: cask.go
source_kind: comment-fragment
source_repo: kriskowal/cask
source_path: cask.go
source_line_range: "192-235"
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
comment_subject: The Store interface contract — span.Add(1)/Add(-1)/Fail completion tracking via tel.SpanFromContext, the four-step caller pattern, Weigh's 0-means-uncomputed sentinel, and the CollectibleStore GC primitives
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-25
ingested_by: scholar
topics: [content-addressed-storage, networking]
status: current
---

> Abstract: The `Store` interface doc-comment in `cask.go` is the **interface-contract** side of CASK's span completion model — the consumer's view of what the `casktel` design doc (`cask--trace2--*`) describes from the producer's side. A `Store` implementation extracts a **Span** from the context (`tel.SpanFromContext`; a nop span if none is present), calls `span.Add(1)` before enqueuing a block and `span.Add(-1)` on completion (or `span.Fail(err)` then `Sub(1)` on error). This lets a caller (1) create a span and attach it via `tel.WithContext`, (2) call `Store` many times — possibly across `caskdir`/`caskblob` — (3) wait on `<-span.Done()` for all stores, and (4) check `span.Err()` for the first error. The implementation may **trust or validate** that the given hash matches the given block; the two are passed separately to avoid redundant hashing. `Weigh` returns the subtree block count (leaf = 1, zero hash = 0) and may be lazily memoized with **0 as the "not yet computed" sentinel** since every real block weighs ≥ 1. `CollectibleStore` adds the GC primitives `List` and `Delete`.

`Store` is the interface for storing blocks by their hash.

Store implementations extract a **Span** from the context (via `tel.SpanFromContext`) to track async completion. If no span is present, a **nop span** is used. The `Store` method calls `span.Add(1)` before enqueuing, and `span.Add(-1)` on completion (or `span.Fail(err)` then `Sub(1)` on error). This allows callers to:

1. Create a span and attach it to context via `tel.WithContext`.
2. Call `Store` (possibly many times, possibly across `caskdir`/`caskblob`).
3. Wait on `<-span.Done()` for all stores to complete.
4. Check `span.Err()` for the first error.

It is the prerogative of the implementation to either **trust or validate** that the given hash corresponds to the given block, but they are accepted separately to avoid redundant hashing. The metadata parameter contains the 12-byte metadata footer.

Interface methods:

- `Store(ctx, Hash, *Block, []byte) error` — enqueues a block for storage; the span tracks completion (`Add(1)` before enqueue, `Add(-1)` on completion, `Fail` on error).
- `Load(ctx, Hash, *Block, []byte) error` — retrieves a block, or fails if the context deadline is reached first; the metadata output parameter receives the 12-byte footer.
- `Weigh(ctx, Hash) (uint64, error)` — returns the **total number of blocks in the subtree** rooted at the hash, including the block itself. A leaf has weight 1; the zero hash has weight 0. Implementations may compute lazily and memoize; the sentinel value **0 means "not yet computed"** since every real block has weight ≥ 1.

`CollectibleStore` is a `Store` that supports garbage-collection primitives:

- `List(ctx, func(Hash) error) error` — calls `fn` for each hash in the store; if `fn` returns an error, iteration stops and that error is returned; context cancellation is respected.
- `Delete(ctx, Hash) error` — removes a stored block.

This is the contract `caskdbstore`, the in-memory store, and the network `Peer` all implement; the span discipline is the same one the `casktel` package (`cask--trace2--span-as-storage-completion-abstraction`) provides from the producer side via `SpanDriver`/`StoreWrapper`.

Source: [cask.go](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/cask.go#L192-L235) at commit `cdb975d8`.
