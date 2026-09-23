---
title: FRB architecture (collections change events, observers, bindings, declarative)
source: README.md
source_repo: kriskowal/frb
source_commit: 131db347355789cf2dbb79e49b10881d9716b449
source_date: 2013-09-15
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [reactive-bindings]
status: current
---

> Abstract: FRB's four-layer architecture, from the Reference/Architecture section. (1) The **collections** library provides property, mapped-content, and ranged-content change events for objects, arrays, and other collections. (2) **Observer** functions watch an entire object graph for incremental changes and rearrange/cancel themselves as the graph changes; observers can be built directly or compiled from a small query language to a tree of functions (no parsing happens while the graph is watched). (3) **Bindings** combine binder and observer functions for one- and two-way incremental updates. (4) A **declarative** interface builds an object graph with bindings, properties, and computed properties with dependencies.

FRB is layered:

- **Collections** provides **property, mapped content, and ranged content change events** for objects, arrays, and other collections. For objects, this adds a property descriptor to the observed object. For arrays, it either swaps the prototype or mixes in methods so all mutation methods dispatch change events. Caveat: you must use a `set` method on arrays to dispatch property and content change events, and the technique does not work in older Internet Explorers (no prototype assignment, no ES5 property setters).
- **Observer** functions watch an entire object graph for incremental changes and gracefully rearrange and cancel those observers as the graph changes. Observers can be constructed directly or with a very small query language that compiles to a *tree of functions*, so no parsing occurs while the graph is being watched. Compiling the query once and then running a function tree is what keeps observation cheap.
- **Bindings** are one- and two-way bindings using binder and observer functions to incrementally update objects.
- A **declarative** interface creates an object graph with bindings, properties, and computed properties with dependencies.

The layering is the reason FRB can claim both incrementality and composability: changes enter at the collections layer as typed change records, propagate through a compiled tree of observer functions, and land through binder functions, each layer needing only the delta rather than a full recomputation.

Source: [README.md](https://github.com/kriskowal/frb/blob/131db347355789cf2dbb79e49b10881d9716b449/README.md) at commit `131db347`.
