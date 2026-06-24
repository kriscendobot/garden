---
title: Package casktel — Tracer and Span interfaces
source: doc/design/trace2.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [networking]
status: current
supersedes: [cask--trace--tracer-interface-and-telemetry-buffer]
notes: The comprehensive successor to the trace.md interface sketch. Supersedes the interface half of cask--trace--tracer-interface-and-telemetry-buffer; the buffer half is superseded by the sibling cask--trace2--buffercasktel-sampling-buffer-and-eviction section.
---

> Abstract: The interface layer of CASK's telemetry design (package `casktel`), the comprehensive successor to the `trace.md` sketch. Defines the **Tracer** (`Trace(ctx, label, ...Option)` starts a root span or a child span inheriting the parent's Trace with a fresh Span ID; `Nice(ctx, n)` shifts priority right for lower-priority derived work) and the **Span**, which is the abstraction storage systems use to track completion of large tasks (storing many blocks). A Span combines identity (`Trace() [16]byte`, `SpanID() [8]byte`, `TrafficClass() uint8`, `Priority()`), cancellation (`Context()`, `Cancel()`), **progress as a numerator/denominator** (`Add(n)` queues work, `Add(-n)` completes it, `Progress()` returns Completed/Planned or NaN), a **Done channel** whose first call finalizes the span, error recording (`Err()`, `Fail(err)`), and optional Zap-style logging. The context key, the `casktel.Option` (Dave-Cheney variadic) family, `DefaultTrafficClass = 5`, the ack-class offset, and the `PriorityFromTraceAndClass` helper round out the package. No default implementation: callers use `nopcasktel` or `buffercasktel`.

## Context key

`casktel` carries a Span in a `context.Context`:

- **`casktel.SpanKey`** (or an unexported `spanKey struct{}`) — the value type used for context keys carrying a Span.
- **`SpanFromContext(ctx) (Span, bool)`** — returns the Span attached to the context, if any.
- **`WithContext(ctx, span) context.Context`** — returns a context that carries the given Span.

## Tracer interface

```go
type Tracer interface {
    // Trace starts or continues a trace. If ctx has no Span, creates a root span
    // (new Trace, new Span). If ctx has a Span, creates a child span that
    // inherits Trace and has a fresh Span ID. Inherits context deadline and
    // cancellation. Options (e.g. TrafficClass) are applied; default TrafficClass is 5.
    Trace(ctx context.Context, label string, opts ...Option) (context.Context, Span)

    // Nice returns a new context and span with priority shifted n bits right,
    // largely inheriting from the current span (e.g. for acks: lower numeric
    // priority so acks are preferred). Optional; not all implementations need it.
    Nice(ctx context.Context, n uint) (context.Context, Span)
}
```

**Options (Dave Cheney style variadic):**

- **`TrafficClass(uint8) Option`** — set traffic class 0–128; default 5.
- **`Label(string) Option`** — override or set span label.
- Other options (sampling, attributes) as needed.

## Span interface

Span is the abstraction used across storage systems for tracking completion of large tasks (storing many blocks). It combines identity, cancellation, progress, and optional logging.

**Identity and priority**

- **`Trace() [16]byte`** — 128-bit trace ID (OpenTelemetry-sized).
- **`SpanID() [8]byte`** — 64-bit span ID (OpenTelemetry-sized).
- **`TrafficClass() uint8`** — 0–128.
- **`Priority() uint256` or `[32]byte`** — computed from Trace and TrafficClass for queue/eviction ordering (see the TrafficClass-and-Priority section; lower value = higher priority).

**Cancellation**

- **`Context() context.Context`** — the span's context; cancelled when the span is cancelled.
- **`Cancel()`** — cancel this span and all derived contexts. Idempotent.

**Progress (numerator/denominator)**

Progress represents "completed / total" for long-running work. Storage systems call `Add(n)` when they queue `n` units of work and `Add(-n)` when `n` units complete. This follows the `sync.WaitGroup` / `atomic.Int64` convention.

- **`Add(n int64)`** — adjusts work tracking. Positive `n` adds to total work (denominator); negative `n` marks work complete (adds `|n|` to the numerator).
- **`Progress() float64`** — `Completed / Planned` when Planned > 0; NaN when Planned == 0 (indeterminate progress).
- **`Completed() int64`** — completed work units.
- **`Planned() int64`** — total planned work units. Control loops can track how Planned changes over time to estimate confidence in Progress.

Semantics: `Add(n)` = "n more units of work"; `Add(-n)` = "n units finished". So "store 100 blocks" → `Add(100)`; each ack → `Add(-1)`. `Progress()` = 1.0 when numerator == denominator.

**Done**

- **`Done() <-chan struct{}`** — returns a channel that closes when the span is finished: (`Completed() == Planned()` and no more positive `Add` will be called) or `Cancel()` was called. The **first** call to `Done()` marks the span as finalized (no more positive `Add()` will be called); the caller who created the Span is responsible for calling `Done()` when they are done adding work and intend to wait. The act of calling `Done()` conflates "I'm done adding" and "give me the channel to wait on": responsibility stays in the context where the Span was created. No separate `Finalize()`.
- **`Err() error`** — first error recorded (e.g. via `Fail(err)`); nil until set.
- **`Fail(err error)`** — record the first error, cancel the context, and close Done so waiters unblock.

**Logging (optional)**

Methods analogous to `go.uber.org/zap`: **Debug**, **Info**, **Warn**, **Error**, **DPanic**, **Panic**, **Fatal**, with **Msg(string)** and **Fields(... Field)**. No-op on `nopcasktel`; `buffercasktel` appends to a per-span log buffer (subject to eviction by priority).

## Constants and helpers

- **`DefaultTrafficClass = 5`**.
- **`AckTrafficClassOffset`** (e.g. 5) — traffic classes 0..5 reserved for acks; the ack class for traffic class `T` is `T - 5`.
- **`PriorityFromTraceAndClass(trace [16]byte, tc uint8)`** — helper for queues and buffers.

Source: [doc/design/trace2.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/trace2.md) at commit `cdb975d8`.
