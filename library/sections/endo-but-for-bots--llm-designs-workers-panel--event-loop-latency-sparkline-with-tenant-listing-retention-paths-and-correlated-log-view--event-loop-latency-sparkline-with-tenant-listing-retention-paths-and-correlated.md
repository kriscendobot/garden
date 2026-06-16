---
section: event-loop-latency-sparkline-with-tenant-listing-retention-paths-and-correlated-log-view
source: endo-but-for-bots--llm-designs-workers-panel
topics: [daemon, chat-ui, tooling]
status: current
title: Event-loop-latency sparkline with tenant listing, retention paths, and correlated log view
parent: endo-but-for-bots--llm-designs-workers-panel--event-loop-latency-sparkline-with-tenant-listing-retention-paths-and-correlated-log-view
---

> *Workers are opaque. There is no way to see which worker
> processes are running, what capabilities are tenanted in
> each worker, what their resource consumption looks like, or
> to correlate logs and metrics with specific workers.*
>
> — `designs/workers-panel.md` §What is the Problem Being Solved

`workers-panel.md` (158 lines, *Not Started* status, created
2026-02-14 / updated 2026-02-24) is the **observability
sister** to cycle 145's formula-inspector — both 2026-02-14
created by Kris Kowal *(prompted)*, both *Not Started*, both
surface daemon internals to the user via a chat-UI panel +
CLI mirror. The formula-inspector exposes the *static*
formula-graph; this design exposes the *dynamic* worker-state.
