---
title: Tracer Interface and the Telemetry Buffer
source: doc/design/trace.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [networking]
status: current
notes: trace.md is an early design-notes sketch (raw interface jottings), not polished prose; ingested as the current statement of the casktel telemetry design. The richer successor trace2.md is deferred to a follow-on cask ingest.
---

> Abstract: CASK's telemetry/tracing design, package `casktel`. A `Tracer.Trace(ctx, label, ...Option) (ctx, Span)` either adopts an existing Span from the context or creates one from whole cloth; given a parent Span it creates a child that inherits the Trace and gets a fresh random Span ID, also inheriting the context's deadline and cancellation. `Nice(ctx, n)` shifts a span's priority `n` bits right to produce a lower-priority child. A Span exposes `Trace()`, `TrafficClass()`, `Priority()`, `Cancel()` (cancelling a span cancels all derived contexts), and Zap-style logging. The default TrafficClass is 5. Two companion packages: `nopcasktel` (a no-op tracer) and `buffercasktel`, whose buffer is a fixed-size parallel-array structure (the same shape as the load-shedding and CoDel buffers) where logging events from high-priority spans **parasitically evict** lower-priority spans and their associated log blocks, with a flush hook for a telemetry server to collect.

## package casktel

- **Tracer interface** — `Trace(context.Context, label string, ...Option) (context.Context, Span)`. If the context has no Span, creates one from whole cloth; if it has a Span, creates a child that inherits the Trace and gets a fresh, random Span, while inheriting other fields, notably the context deadline and cancellation. Accepts Dave-Cheney-style variadic Options. Default TrafficClass is 5.
  - `Nice(ctx, n) (context.Context, Span)` — shift priority `n` bits right and produce a new Span largely inheriting from the parent.
- **`TrafficClass(uint8) TraceOption`**.
- **Span interface** — `Trace()`, `TrafficClass() uint8`, `Priority()`, `Cancel()` (every span can be cancelled and cancels all derived contexts), and logging methods analogous to go.uber.org Zap.
- A `casktextKey` maps `context.Context` to Span.

## package nopcasktel

A `NopTracer` implementation, a `Random(name string) Span`, and a Span implementation — the no-op tracer.

## package buffercasktel

Implements the tracer interface using a fixed-size structure like the existing load-shedding and CoDel buffers, with parallel arrays for allocating and heaping spans and blocks of log data associated with spans, such that logging events from high-priority spans parasitically evict lower-priority spans and all their associated logging blocks. Provides a hook for flushing the buffer when a telemetry server calls to collect.

Source: [doc/design/trace.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/trace.md) at commit `cdb975d8`.
