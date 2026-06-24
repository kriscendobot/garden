# Topic: reactive-bindings

> Abstract: Synchronous, incremental binding of object properties and collection contents, as practiced by `kriskowal/frb` (Functional Reactive Bindings). A binding gives the illusion that two properties are the same value; FRB extends that to long property paths, collection contents, and incrementally-maintained query chains (map, filter, flatten, sum, average, sorted, group) declared in a small query language with `<-` (one-way) and `<->` (two-way) operators. Seeded 2026-06-24 from the frb README's conceptual sections. Distinct from `eventual-send` (asynchronous message-passing to remote objects) and from `async-flow` (durable-replay async functions): FRB is synchronous and in-process, restoring consistency in the same statement that caused the change.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [frb--readme--overview](../sections/frb--readme--overview.md) | frb README | Bindings as the illusion two properties share a value; extended to paths, collection contents, and incremental query chains. |
| [frb--readme--properties](../sections/frb--readme--properties.md) | frb README | The six design adjectives: functional, generic, reactive, synchronous, incremental, unwrapped. |
| [frb--readme--architecture](../sections/frb--readme--architecture.md) | frb README | The four layers: collection change events → compiled observer function-trees → binders → declarative graph. |
| [frb--readme--bindings-and-query-language](../sections/frb--readme--bindings-and-query-language.md) | frb README | The `Bindings` API, the binding-descriptor fields, and the bound-collection-identity-never-changes guarantee. |
| [frb--readme--tutorial-bindings-and-paths](../sections/frb--readme--tutorial-bindings-and-paths.md) | frb README | One-way vs two-way direction, right-to-left setup precedence, deep property paths, and reattachment across structural change. |
| [frb--readme--tutorial-aggregations](../sections/frb--readme--tutorial-aggregations.md) | frb README | Incremental reductions: sum, average, last (no jitter), only (observer and binder). |
| [frb--readme--tutorial-mapping-and-filtering](../sections/frb--readme--tutorial-mapping-and-filtering.md) | frb README | Per-element operators: map, filter, some/every (two-way, with the equals caveat). |
| [frb--readme--tutorial-order-and-grouping](../sections/frb--readme--tutorial-order-and-grouping.md) | frb README | sorted, sortedSet, min/max (binary heap), group/groupMap equivalence classes. |
| [frb--readme--tutorial-windowing-and-structure](../sections/frb--readme--tutorial-windowing-and-structure.md) | frb README | view windows, enumerate, range, flatten, concat, reversed; output identity never replaced. |
| [frb--readme--tutorial-maps-and-lookups](../sections/frb--readme--tutorial-maps-and-lookups.md) | frb README | has, get (variable key), keys/values/entries projections, toMap coercion. |
| [frb--readme--tutorial-equality-and-content](../sections/frb--readme--tutorial-equality-and-content.md) | frb README | == two-way equality, array-as-map duplicity, rangeContent/mapContent, empty-path-implies-source, context expressions. |
| [frb--readme--tutorial-expression-language](../sections/frb--readme--tutorial-expression-language.md) | frb README | Operators and precedence, string functions, ternary, automatic algebraic inversion, literals, tuples, records. |

## Concepts

- [[functional-reactive-bindings]] — the library as a whole.
- [[frb-incremental-update]] — delta-not-recompute consistency; bound-collection identity is stable.
- [[frb-compiled-observer-tree]] — the query language compiles once to a tree of observer/binder functions.

## See also

- [`data-structures`](data-structures.md): the collections library frb observes; FRB's "generic" property is the contract those collections satisfy.
- [`eventual-send`](eventual-send.md): the asynchronous counterpart (E(), promise pipelining) — FRB is the synchronous, in-process side.
- [`async-flow`](async-flow.md): durable-replay async consistency, a different point in the consistency-maintenance design space.
