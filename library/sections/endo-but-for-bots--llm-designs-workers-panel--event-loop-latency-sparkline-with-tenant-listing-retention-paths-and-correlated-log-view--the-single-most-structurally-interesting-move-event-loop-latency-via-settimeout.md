---
section: event-loop-latency-sparkline-with-tenant-listing-retention-paths-and-correlated-log-view
source: endo-but-for-bots--llm-designs-workers-panel
topics: [daemon, chat-ui, tooling]
status: current
title: The §single most structurally interesting move — §event-loop-latency-via-setTimeout(0) probe
parent: endo-but-for-bots--llm-designs-workers-panel--event-loop-latency-sparkline-with-tenant-listing-retention-paths-and-correlated-log-view
---

> *Instrument each worker with a periodic `setTimeout(0)`
> probe that measures scheduling delay. This is the single
> most informative metric for a single-threaded JS worker: if
> the event loop is blocked, everything queued behind it
> stalls.*

The §setTimeout(0)-as-scheduling-delay-probe discipline. The
*setTimeout(0)* idiom schedules a zero-delay callback; the
delta between the scheduled time and the actual fire time
*is* the event-loop scheduling delay. For a single-threaded
JS worker, this is the *load-bearing latency signal*.

The §the-single-most-informative-metric-for-a-single-threaded-JS-worker
thesis: in a multi-threaded system you'd look at CPU, thread
contention, lock waits. In a single-threaded JS worker, *the
event loop is the bottleneck*; everything else is downstream
of it. A blocked event loop is *the* observable that
correlates with user-visible latency.

§Three-color thresholds with §green-yellow-red mapping:

- **Green** < 10ms: healthy
- **Yellow** < 100ms: noticeable, may degrade UX
- **Red** > 100ms: blocking, work is piling up

The §threshold-as-product-discipline (not configurable per
worker): consistent thresholds across the panel let the user
recognize *unhealthy* without per-worker interpretation. The
§1-second-default-probe-interval (configurable) gives 60
samples/minute — enough granularity to spot spikes without
adding measurable overhead.

§Streaming API: `E(worker).followMetrics()` returns an async
iterator of `{ timestamp, eventLoopLatencyMs }`. The
§iterator-not-event-bus shape: each worker exposes *its* own
followMetrics; the UI subscribes per-worker. Composes with
cycle 137's daemon-message-streaming for the
*progressive-text-delivery* substrate.
