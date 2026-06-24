---
id: frb-compiled-observer-tree
aliases: ["compiled observer", "observer function tree", "tree of functions", "compiled observer tree", "function tree observer", "FRB observer model", "binder and observer functions"]
topics: [reactive-bindings]
status: current
---

# frb-compiled-observer-tree

The execution model behind `kriskowal/frb`'s query language: a binding's source path expression is compiled **once** into a tree of small observer functions, and that tree (not a parser) is what runs while the object graph is watched. An **observer** function watches an entire object graph for incremental changes and gracefully rearranges and cancels itself (and re-attaches) as the structure of the graph changes. A **binder** function applies changes to a target. A binding combines a binder and an observer for one- or two-way incremental update. Because the query language compiles to a function tree ahead of time, no parsing happens during observation, which is what keeps watching cheap; the parsed `*Syntax` trees are cached on the binding descriptor. Observers can also be constructed directly without the query language. This is the second of FRB's four architectural layers (collections change events → compiled observer function-trees → binders → declarative graph) and is the structural reason FRB composes: each node in the tree consumes the typed delta from its child and emits a delta to its parent, so a deep query chain propagates one change without recomputing intermediate results.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [frb--readme--architecture](../sections/frb--readme--architecture.md) | Observers compile from the query language to a tree of functions; no parsing while watching. |
| [frb--readme--bindings-and-query-language](../sections/frb--readme--bindings-and-query-language.md) | Binding descriptor caches the `*Syntax` trees; binder + observer functions combine for two-way update. |
| [frb--readme--tutorial-bindings-and-paths](../sections/frb--readme--tutorial-bindings-and-paths.md) | Observers reattach across structural change: orphaned listeners cancel, new graph is observed. |
| [frb--readme--tutorial-order-and-grouping](../sections/frb--readme--tutorial-order-and-grouping.md) | group is a groupMap block followed by an entries() observer — observers compose into pipelines. |
| [frb--readme--tutorial-observer-interface](../sections/frb--readme--tutorial-observer-interface.md) | `observe()` callbacks return cancelers; a returned canceler fires when a new value is observed, which is how the tree nests and tears down. |
| [frb--readme--reference-syntax-tree-and-language-interface](../sections/frb--readme--reference-syntax-tree-and-language-interface.md) | `parse`→`compileObserver`/`compileBinder` build the tree by visiting each JSON-serializable syntax node. |
| [frb--readme--reference-semantics](../sections/frb--readme--reference-semantics.md) | Per-node observation behavior, including the binder-side last-term semantics and the `null`/`undefined` suppression rule. |
| [frb--readme--reference-observers-and-binders](../sections/frb--readme--reference-observers-and-binders.md) | The `observers`/`binders` maker functions that are the tree's nodes, plus the incremental combinators `makeNonReplacing` and `autoCancelPrevious`. |
| [frb--readme--reference-programmatic-api](../sections/frb--readme--reference-programmatic-api.md) | `bind` is built on `parse`+`compileBinder`+`compileObserver`; `observe` on `parse`+`compileObserver`; the module stack that assembles the tree. |

## See also

- [[frb-incremental-update]] — what the tree carries: the per-change delta, stage to stage.
- [[functional-reactive-bindings]] — the library whose query language compiles to this tree.

## Common confusions

- The query language is compiled to functions **once**, ahead of observation; it is not interpreted on every change. The runtime cost during watching is function calls over the tree, not parsing.
- An observer is distinct from a binder: the observer watches a source graph and emits change records; the binder applies change records to a target. A two-way binding pairs them in both directions.

## Deferred

The README's account of this model is now fully ingested (the Reference programmatic-api, grammar, semantics, syntax-tree/language-interface, and observers-and-binders sections, plus the observer-interface tutorial section). What remains is the **source** behind the README's prose: `grammar.pegjs`, `compile-observer.js`, `compile-binder.js`, and `language.js`, to be ingested per the longform-comment / source-file conventions under the follow-on `scholar-ingest-frb-3` job. The README's Grammar / Semantics / Syntax-Tree sections double as the readable spec of those files.
