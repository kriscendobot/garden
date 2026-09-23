---
section: event-loop-latency-sparkline-with-tenant-listing-retention-paths-and-correlated-log-view
source: endo-but-for-bots--llm-designs-workers-panel
topics: [daemon, chat-ui, tooling]
status: current
title: The §reverse-lookup-on-formula-graph for tenant capabilities
parent: endo-but-for-bots--llm-designs-workers-panel--event-loop-latency-sparkline-with-tenant-listing-retention-paths-and-correlated-log-view
---

> *List the pet names of capabilities whose formulas
> reference a given worker. Specifically, formulas with a
> `worker` field matching this worker's formula identifier.*

Three formula types carry a `worker` field:

- `eval` — evaluated expressions
- `make-bundle` — bundled plugins
- `make-unconfined` — unconfined caplets

(Cycle 145's formula-inspector cited six total formula types
that surface metadata; here only three carry the *worker*
back-reference.)

§Reverse-lookup-on-formula-graph: the design notes that
*daemon's `graph.js` already tracks formula references for
GC; this information needs to be surfaced*. The §existing-
GC-graph-as-tenant-source discipline: GC needs the same
references; expose them.

§API: `E(agent).listWorkerTenants(workerPetName)` returns
`Array<{ petName, formulaType }>`. The §pet-name-plus-formula-
type return shape lets the UI render *what kind* of tenant
each is (eval-style code, bundled plugin, unconfined caplet).
