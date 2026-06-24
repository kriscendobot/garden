# Topic: reactive-bindings

> Abstract: Synchronous, incremental binding of object properties and collection contents, as practiced by `kriskowal/frb` (Functional Reactive Bindings). A binding gives the illusion that two properties are the same value; FRB extends that to long property paths, collection contents, and incrementally-maintained query chains (map, filter, flatten, sum, average, sorted, group) declared in a small query language with `<-` (one-way) and `<->` (two-way) operators. Seeded 2026-06-24 from the frb README's conceptual sections. Distinct from `eventual-send` (asynchronous message-passing to remote objects) and from `async-flow` (durable-replay async functions): FRB is synchronous and in-process, restoring consistency in the same statement that caused the change.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [frb--readme--overview](../sections/frb--readme--overview.md) | frb README | Bindings as the illusion two properties share a value; extended to paths, collection contents, and incremental query chains. |
| [frb--readme--properties](../sections/frb--readme--properties.md) | frb README | The six design adjectives: functional, generic, reactive, synchronous, incremental, unwrapped. |
| [frb--readme--architecture](../sections/frb--readme--architecture.md) | frb README | The four layers: collection change events → compiled observer function-trees → binders → declarative graph. |
| [frb--readme--bindings-and-query-language](../sections/frb--readme--bindings-and-query-language.md) | frb README | The `Bindings` API, the binding-descriptor fields, and the bound-collection-identity-never-changes guarantee. |

## See also

- [`data-structures`](data-structures.md): the collections library frb observes; FRB's "generic" property is the contract those collections satisfy.
- [`eventual-send`](eventual-send.md): the asynchronous counterpart (E(), promise pipelining) — FRB is the synchronous, in-process side.
- [`async-flow`](async-flow.md): durable-replay async consistency, a different point in the consistency-maintenance design space.
