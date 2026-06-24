---
id: functional-reactive-bindings
aliases: ["FRB", "frb", "functional reactive bindings", "reactive binding", "two-way binding", "incremental binding", "data binding"]
topics: [reactive-bindings]
status: draft
---

# functional-reactive-bindings

`kriskowal/frb` (Functional Reactive Bindings): a JavaScript library that keeps object properties and collection contents consistent by declaring **bindings** between them. A binding gives the illusion that two properties are the same value (`<->` two-way, `<-` one-way), extends to long property paths and to the *contents* of collections, and incrementally maintains chains of queries (map, filter, flatten, sum, average, sorted, group) so a derived value updates by the delta of a change rather than by recomputation. FRB describes itself as functional, generic, reactive, synchronous (consistency restored in the statement that caused the change), incremental, and unwrapped (it modifies existing objects/arrays to dispatch change events rather than wrapping them). It was extracted from the Montage web-application framework and observes collections through the same generic change-notification interface the `collections` library implements.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [frb--readme--overview](../sections/frb--readme--overview.md) | Bindings as shared-property illusion, extended to paths, collection contents, and incremental query chains. |
| [frb--readme--properties](../sections/frb--readme--properties.md) | The six adjectives: functional, generic, reactive, synchronous, incremental, unwrapped. |
| [frb--readme--architecture](../sections/frb--readme--architecture.md) | Four layers: collection change events → compiled observer function-trees → binders → declarative graph. |
| [frb--readme--bindings-and-query-language](../sections/frb--readme--bindings-and-query-language.md) | The `Bindings` API, descriptor fields, and the bound-collection-identity-is-stable guarantee. |

## See also

- [[generic-collections]] — the change-notification interface FRB's "generic" property depends on.
- [[eventual-send]] — the asynchronous, cross-vat counterpart to FRB's synchronous in-process consistency.

## Common confusions

- FRB is **synchronous** and in-process: it is not an async dataflow / event-queue system. Consistency is restored in the same statement that caused the change, unlike `eventual-send` / `async-flow` which are asynchronous.
