---
title: File layout and implementation order
source: doc/design/trace2.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [networking]
status: current
---

> Abstract: The package/file layout and the staged build order for casktel. Three packages: `casktel` (interfaces, context key, priority helper — `tracer.go`, `span.go`, `priority.go`), `nopcasktel` (`NopTracer`, `NopSpan`), and `buffercasktel` (`BufferTracer`, `BufferSpan`, `buffer.go` for the fixed-size span+log buffer with priority heap and eviction, `flush.go`). The implementation order builds interfaces first, then the no-cost path, then wires the storage layer onto Span (Peer using a context Span with `[]Span` inflight, the embeddable `SpanDriver`, the `StoreWrapper` fallback, `dir.StoreWithSpan`), and adds `buffercasktel` last, only when sampling and flush-to-aggregator are needed.

## File layout

```
cask/
  casktel/
    doc.go
    tracer.go    # Tracer interface, Option, Trace/Nice
    span.go      # Span interface, context key, WithContext, SpanFromContext
    priority.go  # PriorityFromTraceAndClass, constants
  nopcasktel/
    doc.go
    tracer.go    # NopTracer
    span.go      # NopSpan (Add, Sub, Progress, Done, Cancel, no-op Log)
  buffercasktel/
    doc.go
    tracer.go    # BufferTracer
    span.go      # BufferSpan (delegates to buffer slot)
    buffer.go    # fixed-size span + log buffer, heap by priority, eviction
    flush.go     # Flush() for aggregator
```

## Implementation order

1. Add **casktel** (interfaces + context key + priority helper).
2. Add **nopcasktel** (NopTracer, NopSpan with Add/Sub/Progress/Done/Cancel; Done finalizes on first use).
3. Update **Peer** to use the Span from context; `inflight` holds `[]Span`; on ack call `Span.Add(-1)` and `Span.Fail(err)` on failure.
4. Add **casktel.SpanDriver** (the embeddable struct): provides `StoreWithSpan`; enqueues and a goroutine calls the embedder's `Store()` then `span.Add(-1)`. Sync stores (memstore, diskstore) embed it to get async + Span behavior without a separate wrapper.
5. Add **casktel.StoreWrapper(store, span)** as the fallback when a store only has sync `Store`; use at call sites (dir, tests) when the store does not implement `StoreWithSpan`.
6. Add **dir.StoreWithSpan(ctx, store, fs, path, opts, tracer)** using `tracer.Trace`; dir calls `store.StoreWithSpan` when implemented, else `StoreWrapper(store, span)` and `store.Store`.
7. Add **buffercasktel** when sampling and flush-to-aggregator are needed; plug it in as the Tracer where appropriate.

Source: [doc/design/trace2.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/trace2.md) at commit `cdb975d8`.
