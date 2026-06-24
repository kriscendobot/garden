---
section: event-loop-latency-sparkline-with-tenant-listing-retention-paths-and-correlated-log-view
source: endo-but-for-bots--llm-designs-workers-panel
topics: [daemon, chat-ui, tooling]
status: current
title: The §reuse-graph.js for retention path
parent: endo-but-for-bots--llm-designs-workers-panel--event-loop-latency-sparkline-with-tenant-listing-retention-paths-and-correlated-log-view
---

> *Reuse the GC graph from `packages/daemon/src/graph.js`
> which already implements union-find and reachability
> analysis.*

The §graph.js-already-does-this observation. Cycle 145's
formula-inspector and this design both reach into
`packages/daemon/src/graph.js` for retention-path computation.
The §union-find-and-reachability discipline: GC must compute
*which formulas are still reachable from a root*; retention-
path is the trace.

§API: `E(agent).retentionPath(petName)` returns `Array<{
name, formulaType }>` from target back to root.

The §why-is-this-worker-alive question: a worker that won't
GC has *some retention path* back to a root (PINS directory
or agent pet store). The panel shows the chain so the user
can identify *which removal* would release it.

The §pairs-with-formula-inspector observation: cycle 145's
formula-inspector design surfaces retention paths *generically*
for any capability; this design *specializes* the surface for
workers (the user wants to know *why this worker is alive*).
