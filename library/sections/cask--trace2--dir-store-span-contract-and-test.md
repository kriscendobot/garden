---
title: dir.Store contract — Span required; the fire-and-forget test
source: doc/design/trace2.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [networking, content-addressed-storage]
status: current
---

> Abstract: trace2.md §8 makes the Span the *mandatory* completion channel for `dir.Store`: there is no other mode. The caller must put a Span in context and use a store that tracks completion on it, or `dir.Store` returns `casktel.ErrSpanRequired`. `dir.Store` does **not** block on completion: it traverses the tree, calls `store.StoreWithSpan` (fire-and-forget, when the store is async) for each block, and returns `(hash, err)` where `err` covers only synchronous failures (a failed `ReadDir`) and the root hash is available because it is computed during traversal. The caller then `<-span.Done()` (whose first call finalizes the span) and inspects `span.Err()`, the returned hash, and optionally `span.Progress()`/`Completed()`/`Planned()`. The Span is the single place for completion and frozen results. A worked test flow uses `nopcasktel.Tracer` and an async store to simulate fire-and-forget plus ack without a real network (`cask/dir/store_span_test.go`, build tag `casktel`).

## Contract

- **`Store(ctx, store, fs, path)`** requires `ctx` to carry a Span (`casktel.SpanFromContext(ctx)` returns a Span). If no Span, `Store` returns an error (`casktel.ErrSpanRequired`). There is no overload or alternate function for storing without a Span.
- The **store** must use that Span: dir calls `store.StoreWithSpan(ctx, span, hash, block, meta)` when the store implements it (Peer, or a sync store that embeds `casktel.SpanDriver`). Each call does `span.Add(1)`, enqueues, and returns; when each block is stored (or fails) the store calls `span.Add(-1)` and, on failure, `span.Fail(err)`. If the store only has sync `Store`, the caller may wrap with `casktel.StoreWrapper(store, span)`; prefer stores that implement `StoreWithSpan` (or embed `SpanDriver`).
- **`Store` does not block** on completion. It traverses the tree, calls `store.Store` for each block (fire-and-forget when the store is async), and returns `(hash, err)`. It does **not** call Finalize; the caller is responsible. `err` is only for synchronous failures (a failed `ReadDir`). The root hash is available at return because it is computed during the traversal.
- The caller then `<-span.Done()` to wait for all blocks to complete (or for the first error). The first call to `Done()` finalizes the span (no more positive Add); the returned channel closes when work is complete. After Done closes, the caller inspects `span.Err()` and uses the returned `hash`. There is no other channel or callback; the Span is the single place for completion and frozen results (Err, Completed, Planned, Progress).

## Example flow (test)

1. **Obtain a Span:** `ctx, span := tracer.Trace(ctx, "dir.Store")`.
2. **Build a store that uses the Span:** one that implements `StoreWithSpan` (Peer, or a sync store embedding `casktel.SpanDriver`), or wrap with `casktel.StoreWrapper(inner, span)` when the store only has sync `Store`.
3. **Call Store once:** `hash, err := dir.Store(ctx, store, fs, path)`. Store returns after queuing all work; it does not block on acks and does not call Finalize.
4. **Watch for completion:** `<-span.Done()`. The first call to `Done()` finalizes the span and returns the channel; the channel closes when all work is complete.
5. **Inspect frozen results:** `span.Err()`, the returned `hash`, and optionally `span.Progress()`, `span.Completed()`, `span.Planned()`.

See `cask/dir/store_span_test.go` (build tag `casktel`) for a full test using `nopcasktel.Tracer` and an async store to simulate fire-and-forget + ack without a real network.

Source: [doc/design/trace2.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/trace2.md) at commit `cdb975d8`.
