---
section: event-loop-latency-sparkline-with-tenant-listing-retention-paths-and-correlated-log-view
source: endo-but-for-bots--llm-designs-workers-panel
topics: [daemon, chat-ui, tooling]
status: current
title: The §CLI-mirror — same shape as formula-inspector
parent: endo-but-for-bots--llm-designs-workers-panel--event-loop-latency-sparkline-with-tenant-listing-retention-paths-and-correlated-log-view
---

```
endo workers                  # list active workers
endo worker <name> --logs     # tail logs
endo worker <name> --metrics  # current latency
endo worker <name> --tenants  # tenanted capabilities
```

The §subcommand-flag-shape: one top-level `workers` listing
+ one per-worker `worker <name>` verb taking flags for each
of the three streams. Compositional: same `<name>` is reused
across `--logs`, `--metrics`, `--tenants`.

§Same shape as formula-inspector's `endo inspect <name>` —
both designs share the §thin-API-thick-UI principle (cycle
145's slogan).
