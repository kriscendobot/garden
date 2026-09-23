---
title: Package nopcasktel — the no-cost tracer
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

> Abstract: The no-cost `casktel.Tracer` implementation, used when telemetry is disabled or when only progress and cancellation are needed (no logging, no sampling). **NopTracer** holds no state; `Trace()`/`Nice()` allocate a **NopSpan** and attach it to the context. NopSpan holds Trace, SpanID, TrafficClass, a context and cancel func, and atomic numerator/denominator (int64); it has no log buffer and runs **no background goroutine**. `Add(n)` is an atomic add (positive to denominator, negative to numerator, capped at denominator). The Done channel is closed cheaply inline: the first `Done()` call sets the `finalized` flag (via a stored flag plus `sync.Once`), and after each `Add(-n)` the span checks `numerator >= denominator && finalized` and closes `done` through the `closeOnce`; `Cancel()` also closes it. Log methods are no-ops.

## Types

- **NopTracer** — implements `Tracer`. Holds no state; `Trace()` and `Nice()` allocate a `NopSpan` and attach it to the context.
- **NopSpan** — implements `Span`. Holds: `Trace [16]byte`, `SpanID [8]byte`, `TrafficClass uint8`, a `context.Context` and cancel func, and an atomic numerator/denominator (int64). `Done()` returns a channel; the first call to `Done()` sets finalized; the channel closes when (numerator == denominator && finalized) or on cancel. No log buffer.

## NopTracer behavior

- **`Trace(ctx, label, opts...)`** — if `ctx` already has a Span, create a child: same Trace, new random SpanID, inherit TrafficClass (or take it from an option). Otherwise create a root: random Trace, random SpanID, default or option TrafficClass. New context with cancel; the NopSpan is created with `Add(0)`; `Done()` not yet called (not finalized). The channel closes when the caller has called `Done()` and `Add(-n)` has brought numerator to denominator, or on `Cancel()`.
- **`Nice(ctx, n)`** — from the current Span, produce a new Span with `Priority = parent.Priority() >> n` (same Trace/SpanID or a new child; the design leaves open whether `Nice` creates a child or a priority-shifted "view").

## NopSpan behavior

- **`Add(n)`** — atomic: positive `n` adds to denominator; negative `n` adds `|n|` to numerator (capped at denominator).
- **`Progress()`** — Completed / Planned as float64; NaN if Planned == 0.
- **`Completed()` / `Planned()`** — atomic read.
- **Done** — `Done()` returns a channel. The first call sets finalized (no more positive Add). The channel closes when (finalized && numerator == denominator) or on Cancel(). **No background goroutine**: `Add(-n)` checks after its atomic add and closes the channel if `numerator >= denominator && finalized`; `Cancel()` closes the channel. NopSpan holds `done chan struct{}`, `closeOnce sync.Once`, and `finalized` (set on the first `Done()` call).
- **Log methods** — no-op.

Source: [doc/design/trace2.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/trace2.md) at commit `cdb975d8`.
