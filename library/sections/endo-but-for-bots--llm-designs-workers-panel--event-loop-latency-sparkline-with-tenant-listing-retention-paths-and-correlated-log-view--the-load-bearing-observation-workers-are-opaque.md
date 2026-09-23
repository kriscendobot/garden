---
section: event-loop-latency-sparkline-with-tenant-listing-retention-paths-and-correlated-log-view
source: endo-but-for-bots--llm-designs-workers-panel
topics: [daemon, chat-ui, tooling]
status: current
title: The §load-bearing-observation — *workers are opaque*
parent: endo-but-for-bots--llm-designs-workers-panel--event-loop-latency-sparkline-with-tenant-listing-retention-paths-and-correlated-log-view
---

The §What-is-the-Problem-Being-Solved paragraph names four
opacity facets:

1. Which worker processes are running
2. What capabilities are tenanted in each worker
3. What their resource consumption looks like
4. How logs and metrics correlate with specific workers

The §observability-essential-for-untrusted-guest-code thesis:
*for a system designed to host potentially untrusted guest
code, observability is essential*. The §host-level-observation-
surface (the maintainer / operator needs to see what's
running; the guests don't get to see this).
