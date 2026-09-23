---
title: Package buffercasktel — sampling buffer, priority eviction, and flush
source: doc/design/trace2.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [networking, data-structures]
status: current
supersedes: [cask--trace--tracer-interface-and-telemetry-buffer]
notes: Supersedes the buffer half of the trace.md interface sketch (cask--trace--tracer-interface-and-telemetry-buffer); the interface half is superseded by the sibling cask--trace2--casktel-package-interfaces section.
---

> Abstract: The sampling `casktel.Tracer` implementation, which an aggregator periodically flushes at a sustainable pace. `buffercasktel` uses the same **fixed-size parallel-array structure** as the sendbuffer/CoDel buffers: columns for trace, spanID, trafficClass, priority (the heap key), numerator, denominator, label, context/cancel, done channel, and a log-buffer index. A **BufferSpan** references its slot and updates the shared arrays. **Eviction** is by priority: when the buffer is full and a new span arrives, the span with the **highest Priority value (lowest importance)** is evicted along with all its log blocks; logging from a high-priority span can "parasitically" evict a lower-priority span's log data when the global log buffer is bounded. **`Flush(ctx) ([]SpanSnapshot, error)`** hands an aggregator an immutable snapshot (Trace, SpanID, TrafficClass, Label, Completed, Planned, Progress, Err, log lines, times) and optionally rotates buffers. A **SampleRate** option records only a fraction of spans; unsampled spans behave like NopSpan for logging but still provide Progress/Cancel.

## Structure

- **BufferTracer** — implements `Tracer`. Holds:
  - A fixed-capacity buffer of spans (a slice of `*BufferSpan` or indexes into parallel arrays).
  - Parallel arrays: `trace [16]byte`, `spanID [8]byte`, `trafficClass`, `priority` (for the heap), `numerator`, `denominator`, `label`, `context/cancel`, `done` channel, log-buffer index, and so on.
  - A heap (or heap index) by priority so the "lowest" priority span can be evicted when the buffer is full.
  - A mutex (or internal synchronization) for concurrent `Trace`/`Sub`/`Add`/`Flush`.
- **BufferSpan** — implements `Span`. References its slot in the BufferTracer; `Add`/`Progress`/`Completed`/`Planned` update the shared arrays; `Log` appends to a per-span log block (or chunk list) that is evicted when the tracer evicts the span.

## Eviction

- When the buffer is full and a new span is created, evict the span with the **highest** Priority value (lowest importance). Evict all log blocks associated with that span, then allocate the new span.
- Logging from a high-priority span can "parasitically" evict a lower-priority span's log data when the total log buffer is bounded: a global log buffer with span tags drops or compacts the logs for the lowest-priority span when full.

## Flush

- **`Flush(ctx) ([]SpanSnapshot, error)`** — called by an aggregator at a pace it can sustain. Returns a snapshot of finished or active spans (and their log buffers) that the aggregator sends to a telemetry backend. Optionally clears or rotates buffers after flush so the tracer can reuse space.
- **SpanSnapshot** — immutable snapshot: Trace, SpanID, TrafficClass, Label, Completed, Planned, `Progress()`, Err, log lines (or an opaque blob), and start/end time if available.

## Sampling

- The Tracer or Span may accept a **SampleRate** option; only a fraction of spans are recorded in the buffer (e.g. 1 in N). The rest behave like NopSpan for logging/storage but still provide Progress/Cancel for the caller.

Source: [doc/design/trace2.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/trace2.md) at commit `cdb975d8`.
