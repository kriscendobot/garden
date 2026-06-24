---
title: "In-memory: `formulaGraph.retentionEdges`"
source: designs/daemon-cross-peer-gc.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 1570e88926e0fe3146b30458b6148f33c76fe02a
source_date: 2026-04-29
source_authors: [Kris Kowal]
topics: [daemon, persistence]
status: current
parent: endo-but-for-bots--llm-designs-dcpg--persistence-and-graph
---

At `graph.js:69`:

```js
formulaGraph.retentionEdges: Map<peerNodeNumber, Set<formulaNumber>>
```

This is the authoritative answer to "for peer P, which formulas of mine
is P currently holding?" It is read on every local GC pass (to decide
whether a formula is releasable) and is mutated by the event sources in
[[endo-but-for-bots--llm-designs-dcpg--event-sources-and-subscription]].
Each mutation is also fed into every active retention-accumulator on
that peer (see
[[endo-but-for-bots--llm-designs-dcpg--wire-and-batching]]).
