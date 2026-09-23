---
section: event-loop-latency-sparkline-with-tenant-listing-retention-paths-and-correlated-log-view
source: endo-but-for-bots--llm-designs-workers-panel
topics: [daemon, chat-ui, tooling]
status: current
title: The §upgrade-considerations — §backward-compat by graceful-degradation
parent: endo-but-for-bots--llm-designs-workers-panel--event-loop-latency-sparkline-with-tenant-listing-retention-paths-and-correlated-log-view
---

§Upgrade:

- *Existing workers (before upgrade) don't report metrics.
  The UI should handle the absence gracefully (show "no data"
  instead of a sparkline).*
- The latency probe must be added to `worker.js` `main()` —
  *changes the worker process behavior but doesn't affect the
  formula schema*. §process-behavior-changes-not-schema
  discipline.
- *Log entries written before the upgrade won't have worker
  tags; filtered log views will simply not show historical
  entries for those workers.*

The §graceful-degradation discipline: old workers don't show
sparklines; old logs don't filter. The user experience
*degrades smoothly* rather than failing loudly.
