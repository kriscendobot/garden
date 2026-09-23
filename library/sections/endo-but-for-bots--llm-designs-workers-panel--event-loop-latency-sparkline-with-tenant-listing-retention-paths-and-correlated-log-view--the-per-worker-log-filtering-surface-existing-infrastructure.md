---
section: event-loop-latency-sparkline-with-tenant-listing-retention-paths-and-correlated-log-view
source: endo-but-for-bots--llm-designs-workers-panel
topics: [daemon, chat-ui, tooling]
status: current
title: The §per-worker-log-filtering — surface existing infrastructure
parent: endo-but-for-bots--llm-designs-workers-panel--event-loop-latency-sparkline-with-tenant-listing-retention-paths-and-correlated-log-view
---

> *The daemon already has per-formula logging (the `endo log`
> command accesses it); it needs to be filterable by worker
> formula identifier.*

§Existing-infrastructure-needs-surfacing discipline (parallel
to formula-inspector's §existing-API-leverage observation):
the daemon already logs per-formula; the panel just adds a
filter and a UI viewer.

§API: `E(agent).followWorkerLog(workerPetName)` returns async
iterator of log entries.
