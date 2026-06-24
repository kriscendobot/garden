---
section: event-loop-latency-sparkline-with-tenant-listing-retention-paths-and-correlated-log-view
source: endo-but-for-bots--llm-designs-workers-panel
topics: [daemon, chat-ui, tooling]
status: current
title: The §three-affected-packages partition — sister to cycle 145
parent: endo-but-for-bots--llm-designs-workers-panel--event-loop-latency-sparkline-with-tenant-listing-retention-paths-and-correlated-log-view
---

§Affected Packages:

> - `packages/daemon` — worker metrics probe, tenant listing,
>   retention path API, filtered log streaming
> - `packages/chat` — workers panel UI, sparkline rendering,
>   log viewer
> - `packages/cli` — new `endo workers` and `endo worker`
>   commands

**Identical partition** to cycle 145's formula-inspector:
daemon (data sources + APIs) → chat (UI panel) + cli (CLI
mirror). Two cohabiting designs adopt the same architectural
shape. The §thin-API-thick-UI discipline: each panel adds a
small number of `E(agent).*` methods; UI rendering carries
the weight.
