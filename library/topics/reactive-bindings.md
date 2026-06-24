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
| [frb--readme--tutorial-parameters-and-components](../sections/frb--readme--tutorial-parameters-and-components.md) | frb README | `$` parameters as a second source, `#` DOM elements, `@` Montage components; reaching outside the source object. |
| [frb--readme--tutorial-observer-interface](../sections/frb--readme--tutorial-observer-interface.md) | frb README | `observe()` with beforeChange/contentChange flags; callbacks return cancelers, which is how observers nest. |
| [frb--readme--tutorial-bindings-interface](../sections/frb--readme--tutorial-bindings-interface.md) | frb README | `defineBindings`/`cancelBindings`/`getBindings`; a `<-`/`<->` descriptor is a binding descriptor recorded per object. |
| [frb--readme--tutorial-converters-computed-and-traces](../sections/frb--readme--tutorial-converters-computed-and-traces.md) | frb README | convert/revert converters, reverters, `args`+`compute` computed properties, and `trace` console logging. |
| [frb--readme--reference-programmatic-api](../sections/frb--readme--reference-programmatic-api.md) | frb README | The per-module entry points (frb, bind, compute, observe, evaluate, stringify) and the binding-descriptor field list. |
| [frb--readme--reference-grammar](../sections/frb--readme--reference-grammar.md) | frb README | The precedence-climbing expression grammar; each term names the syntax-node type it produces. |
| [frb--readme--reference-semantics](../sections/frb--readme--reference-semantics.md) | frb README | Normative per-operator observation behavior plus the binder-side (left-hand-side) semantics and the `.*` content target. |
| [frb--readme--reference-syntax-tree-and-language-interface](../sections/frb--readme--reference-syntax-tree-and-language-interface.md) | frb README | parse/compileObserver/compileBinder and the JSON-serializable syntax-tree node types. |
| [frb--readme--reference-observers-and-binders](../sections/frb--readme--reference-observers-and-binders.md) | frb README | The `observers`/`binders` module function catalog and the incremental combinators (makeNonReplacing, autoCancelPrevious). |

## Concepts

- [[functional-reactive-bindings]] — the library as a whole.
- [[frb-incremental-update]] — delta-not-recompute consistency; bound-collection identity is stable.
- [[frb-compiled-observer-tree]] — the query language compiles once to a tree of observer/binder functions.

## See also

- [`data-structures`](data-structures.md): the collections library frb observes; FRB's "generic" property is the contract those collections satisfy.
- [`eventual-send`](eventual-send.md): the asynchronous counterpart (E(), promise pipelining) — FRB is the synchronous, in-process side.
- [`async-flow`](async-flow.md): durable-replay async consistency, a different point in the consistency-maintenance design space.
