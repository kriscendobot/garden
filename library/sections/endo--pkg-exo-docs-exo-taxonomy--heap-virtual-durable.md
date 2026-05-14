---
title: Heap vs Virtual vs Durable
source: packages/exo/docs/exo-taxonomy.md
source_repo: endojs/endo
source_commit: 01ba3f7d57c9
source_date: 2023-01-27
source_authors: [Mark S. Miller]
ingested: 2026-05-14
ingested_by: scholar
topics: [exo, daemon, persistence]
status: current
---

> Abstract: The second axis. Heap: state in regular JS heap, dies with the process. Virtual: state in a virtual-object store, managed by a heap-management layer. Durable: state in durable storage that survives process restarts. Class Cardinality: how many instances each form supports. All three flavors of each Exo form exist.

## Heap vs Virtual vs Durable

### Exo*
As with stores, the default is that exo objects created by `makeExo` or the functions returned by `defineExoClass` or `defineExoClassKit` live in JavaScript's heap. Therefore, the total number of such Exo objects in a given vat must be able to fit into the JavaScript heap of that vat, and will occupy room in that vat's snapshot. We say the total number of instances is *low cardinality* when we expect the total number to remain low enough that this heap representation is not a problem.

### VirtualExo*
Like the big stores, the virtual exo objects created by the functions returned by `defineVirtualExoClass` or `defineVirtualExoClassKit` are written to external storage outside the JavaScript heap. But these are ephemeral -- they do not survive upgrade. Their only purpose is for high cardinality, so we do not provide a convenience for directly making exo instances. IOW, there is no `makeVirtualExo`.

### DurableExo*
The durable exo objects created by the functions returned by `defineDurableExoClass` or `defineDurableExoClassKit` are also written to external storage. These can also survive upgrade, and so can be passed in baggage to a successor vat-incarnation. Note that there is no `makeDurableExo`, although the need is largely covered by `prepareExo`.

### Class Cardinality
The total number of exo classes must be low cardinality, regardless of virtual/durable status. Being virtual or durable only enables class *instances* to be high cardinality.


Source: [packages/exo/docs/exo-taxonomy.md](https://github.com/endojs/endo/blob/01ba3f7d57c9/packages/exo/docs/exo-taxonomy.md) at commit `01ba3f7d`.
