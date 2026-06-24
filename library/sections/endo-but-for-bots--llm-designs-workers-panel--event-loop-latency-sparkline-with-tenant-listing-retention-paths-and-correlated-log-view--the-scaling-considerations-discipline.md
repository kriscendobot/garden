---
section: event-loop-latency-sparkline-with-tenant-listing-retention-paths-and-correlated-log-view
source: endo-but-for-bots--llm-designs-workers-panel
topics: [daemon, chat-ui, tooling]
status: current
title: The §scaling-considerations discipline
parent: endo-but-for-bots--llm-designs-workers-panel--event-loop-latency-sparkline-with-tenant-listing-retention-paths-and-correlated-log-view
---

§Three scaling moves:

1. **Streaming overhead is negligible**: *At 1s intervals
   with 10 workers, this is 10 messages/second — negligible*.
2. **Retention path caching**: *Cache the result and update
   incrementally when the graph changes*. The §incremental-
   update-not-recompute discipline.
3. **Tenant reverse-index**: *Consider maintaining a reverse
   index for efficiency*. The §pre-compute-the-reverse-edge
   discipline.

The §sparkline-fixed-size-ring-buffer (60 samples; *bound
memory*) is the §observability-without-unbounded-state
discipline. The panel is a *probe*, not a *recorder*.
