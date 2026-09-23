---
title: Span as the storage-completion abstraction (Store vs StoreWithSpan, SpanDriver)
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

> Abstract: How CASK's storage systems lean on `casktel.Span` to track completion of large fire-and-forget tasks (storing many blocks). The Span is the single completion point: a caller does `Span.Add(1)` per queued store and the store does `Span.Add(-1)` per ack (`Span.Fail(err)` on failure), then `<-Span.Done()` (whose first call finalizes) and `Span.Err()`. The design names **two layered store methods**: synchronous **`Store(ctx, hash, block, meta)`** (the base, blocks until stored) and asynchronous **`StoreWithSpan(ctx, span, hash, block, meta)`** (does `Add(1)`, enqueues, returns; completion does `Add(-1)`). Sync stores gain the async path by **embedding `casktel.SpanDriver`**, an embeddable struct that provides `StoreWithSpan` and runs a goroutine draining the queue into the embedder's sync `Store()` then `span.Add(-1)`; when there is no real network, async drives sync. **`casktel.StoreWrapper(store, span)`** is the fallback for sync-only stores. **Peer** implements `StoreWithSpan` directly (its `inflight` holds `[]Span`, acked by `Add(-1)`); **dir**, **blob**, and **io Writer** use the store's async path when a Span is in context. Includes the progress numerator/denominator semantics (`Add(n)`/`Add(-n)`/`Progress()`).

## Span as the completion abstraction

Storage systems track completion of large tasks (many stores) with a **Span**: `Add(n)` when queuing `n` units, `Add(-n)` when `n` complete. The caller who created the Span calls `Done()` when done adding work and then waits `<-span.Done()`; that call both finalizes (no more positive Add) and returns the channel. `Err()` reports failure. The Span also carries Trace, SpanID, TrafficClass, and Priority for the wire and for load-shedding.

## Peer (cask/net)

- **`Store(ctx, hash, block, metadata)`** — if `casktel.SpanFromContext(ctx)` returns a Span: do `Span.Add(1)` before enqueueing (or a wrapper does it); on ack or failure do `Span.Add(-1)` and, on failure, `Span.Fail(err)`. Do not block the caller; return nil after enqueue. The caller waits on `<-Span.Done()` then reads `Span.Err()`.
- For a duplicate hash (the same hash stored twice with the same Span), attach the same pending count: `Add(1)` once per logical store, `Add(-1)` once per ack. **inflight** holds `spans []casktel.Span` (or `[]*BufferSpan`): one Span per distinct `Store()` call to notify on ack.
- **Priority for the send queue** — use `Span.Priority()` (or TrafficClass + Trace) to enqueue, via `queuePriorityFromSpan(span)` or from Trace+TrafficClass in the packet.

## Sync vs async store methods; the embeddable driver

- **`Store` (sync)** and **`StoreWithSpan` (async)** are the correct layering. Sync is the base: `Store(ctx, hash, block, meta)` blocks until the block is stored. Async uses a Span: `StoreWithSpan(ctx, span, hash, block, meta)` does `Span.Add(1)`, enqueues, and returns; on completion the store calls `Span.Add(-1)` (and `Span.Fail(err)` on failure). When there is no effective latency (in-process), async drives sync: the async path enqueues and a goroutine calls the sync `Store()`, then `Span.Add(-1)`.
- **Embeddable `casktel.SpanDriver`** — sync stores (memstore, diskstore) embed it to turn synchronous behavior into async without a separate wrapper type. The embeddable provides `StoreWithSpan`: it does `Span.Add(1)`, enqueues `(hash, block, meta, span)`, and returns; a goroutine drains the queue and for each item calls the embedder's sync `Store(ctx, hash, block, meta)` then `span.Add(-1)` (or `span.Fail(err)`). The embedder only implements `Store`; the embeddable adds `StoreWithSpan` and drives `Store` internally, holding a reference to the embedder (or a `SyncStore` interface).
- **`dir.Store`** (and similar) call `store.StoreWithSpan(ctx, span, hash, block, meta)` when the store implements it (Peer, or a sync store that embeds `SpanDriver`). So a store may expose both `Store` (sync) and `StoreWithSpan` (async); dir uses `StoreWithSpan` when ctx has a Span.

## casktel.StoreWrapper

- **`StoreWrapper(store, span)`** wraps a store that only has sync `Store` plus a `casktel.Span`: its `Store()` does `Span.Add(1)` then `Inner.Store(Span.Context(), ...)`. Used when the inner store is already async (Peer) and drives the Span from context; Peer does `Span.Add(-1)` on ack. For sync-only stores that do not embed the driver, StoreWrapper remains an option (sync delegation, no pipelining). Prefer embedding `SpanDriver` so the store implements `StoreWithSpan` and dir can call it directly.

## dir, blob, io

- **dir (cask/dir)** — `StoreWithOptions(ctx, store, fs, path, opts)` takes a Span from context. If present, dir calls `store.StoreWithSpan(...)` per block (when the store implements it) or uses `casktel.StoreWrapper(store, span)` and `store.Store` when it does not. `StoreWithSpan(ctx, store, fs, path, opts, tracer)` creates a span via `tracer.Trace(ctx, "dir.Store", ...)`, runs `StoreWithOptions`, then `<-span.Done()` and returns `span.Err()`.
- **blob (cask/blob)** — `Store(ctx, store, reader, opts)`: if ctx has a Span, each block store uses `store.StoreWithSpan(...)` so `Add(1)`/`Add(-1)` are driven by the store; the tree builder uses the store as usual. Optionally blob can `Add(estimated total)` up front (from chunk count); the design prefers `Add(1)`/`Add(-1)` per block for accuracy.
- **cask/io Writer** — `Flush` and `Sum` call `store.Store` (sync) or `store.StoreWithSpan` when a Span is present; each call adds one and completion subtracts one. No change to Writer itself beyond passing the Span when available.

## Summary table

| Component        | Behavior |
|------------------|----------|
| Store (sync)    | Blocks until the block is stored. Base for all stores. |
| StoreWithSpan (async) | `Span.Add(1)`, enqueue, return; completion does `span.Add(-1)`. Async drives sync when in-process (embeddable driver calls `Store()`). |
| SpanDriver (embeddable) | Sync stores embed it; provides `StoreWithSpan`; goroutine drains the queue and calls `embedder.Store()` then `span.Add(-1)`. |
| Peer             | Implements `StoreWithSpan`; Span in context; `inflight` has `[]Span`; ack does `span.Add(-1)`. |
| StoreWrapper     | Fallback when a store only has `Store`: `Span.Add(1)`; `store(Span.Context(), …)`. Prefer stores that implement `StoreWithSpan` (or embed `SpanDriver`). |
| dir.StoreWithSpan | `tracer.Trace` → Span, `store.StoreWithSpan` (or wrapper), `<-Done` (Done finalizes). |
| Progress         | `Span.Progress()` (0.0–1.0 or NaN), Completed/Planned. |

## Progress: Add, Sub, Progress()

- **`Add(n int64)`** — adds `n` to total work (denominator); call when queuing `n` units.
- **`Add(-n)`** — marks `n` units completed (adds to numerator); call when `n` acks/stores complete. The implementation caps numerator at denominator.
- **`Progress() float64`** — `Completed / Planned` when Planned > 0; NaN otherwise.
- **`Completed()` / `Planned()`** — work units, for UI or an aggregator.

So "store 100 blocks" fire-and-forget: the caller (or StoreWrapper) does `Add(1)` per `Store` call (100 times); the peer does `Add(-1)` per ack (100 times); `Progress()` goes 0.0 → 0.01 → … → 1.0. If the total is known in advance (dir knows the block count), `Add(total)` once plus `Add(-1)` per ack is accurate without 100 `Add(1)` calls.

Source: [doc/design/trace2.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/trace2.md) at commit `cdb975d8`.
