---
section: event-loop-latency-sparkline-with-tenant-listing-retention-paths-and-correlated-log-view
source: endo-but-for-bots--llm-designs-workers-panel
topics: [daemon, chat-ui, tooling]
status: current
title: The §five-feature panel — concrete-affordance enumeration
parent: endo-but-for-bots--llm-designs-workers-panel--event-loop-latency-sparkline-with-tenant-listing-retention-paths-and-correlated-log-view
---

The design enumerates **five concrete features** the Workers
panel surfaces. Each gets its own H3 subsection in the source:

1. **Event Loop Latency Sparkline** — `setTimeout(0)` probe.
2. **Tenant Capabilities** — formulas with `worker` field
   matching this worker's identifier.
3. **Pet Name Retention Paths** — trace from worker back to
   GC roots.
4. **Per-Worker Logs** — filter the global log to a specific
   worker.
5. **Correlated View** — shared X-axis (time) with latency
   sparkline + log entries.

The §enumerate-features-not-architecture discipline: this is a
*product spec*, not an architectural design. Each feature
maps to a chat-UI render and a CLI command.
