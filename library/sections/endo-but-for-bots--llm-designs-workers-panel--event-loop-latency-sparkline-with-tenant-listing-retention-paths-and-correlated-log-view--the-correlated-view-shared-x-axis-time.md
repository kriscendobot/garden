---
section: event-loop-latency-sparkline-with-tenant-listing-retention-paths-and-correlated-log-view
source: endo-but-for-bots--llm-designs-workers-panel
topics: [daemon, chat-ui, tooling]
status: current
title: The §correlated-view — §shared-X-axis-time
parent: endo-but-for-bots--llm-designs-workers-panel--event-loop-latency-sparkline-with-tenant-listing-retention-paths-and-correlated-log-view
---

> *A timeline-aligned view where log entries and latency
> spikes can be viewed together: Shared X-axis (time). Top
> lane: sparkline of event loop latency. Bottom lane: log
> entries as markers/rows at their timestamps. Clicking a
> latency spike scrolls to the nearest log entries.*

The §correlated-view-via-shared-time-axis idiom. Two
information streams (continuous latency + discrete log
events) sharing one axis. The §click-spike-to-find-log
affordance: latency spikes are *anomalies*; the user wants to
know *what was happening* at the spike. Clicking the spike
jumps to the contemporaneous log entries.

The §discrete-events-as-markers-on-continuous-axis discipline
is the *flame-graph-without-the-flame* idiom: information-
dense observability without architectural commitment to a
heavier framework.
