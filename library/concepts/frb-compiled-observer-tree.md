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
| [frb--grammar--token-tables-and-precedence-climbing](../sections/frb--grammar--token-tables-and-precedence-climbing.md) | The PEG source: one rule per precedence level, the token→type tables, the `!=`→`not(equals)` and `<`-lookahead edge cases. |
| [frb--grammar--path-expressions-pipe-and-tail](../sections/frb--grammar--path-expressions-pipe-and-tail.md) | `tail`/`chain` return `previous => node` functions; `pipe` left-folds them, so a path string builds the left-leaning node tree. |
| [frb--grammar--literals-strings-numbers-records-tuples](../sections/frb--grammar--literals-strings-numbers-records-tuples.md) | Literal/collection productions; the tuple-args-array vs record-args-object split originates here. |
| [frb--grammar--mcs-sheet-and-statement-extensions](../sections/frb--grammar--mcs-sheet-and-statement-extensions.md) | The README-undocumented declarative sheet grammar: `@label { target <- source; on event -> handler }`. |
| [frb--compile-observer--compilers-table-and-visitor](../sections/frb--compile-observer--compilers-table-and-visitor.md) | The ~50-entry type→maker dispatch table and the recursive bottom-up visitor that builds the observer tree. |
| [frb--compile-observer--open-world-method-and-operator-fallback](../sections/frb--compile-observer--open-world-method-and-operator-fallback.md) | Unknown types become method observers; operators auto-register from `operators.js`; the `toString` non-enumerable patch. |
| [frb--compile-binder--invertible-roots-and-binder-table](../sections/frb--compile-binder--invertible-roots-and-binder-table.md) | The small invertible-roots table and the fail-loud `"Can't compile binder"` that enforces which expressions are two-way. |
| [frb--compile-binder--algebraic-binders-equals-if-and-or](../sections/frb--compile-binder--algebraic-binders-equals-if-and-or.md) | `equals`/`if`/`and`/`or`/`everyBlock` bind by `algebra.js`'s `solve`: the literal mechanism behind "automatic algebraic inversion." |
| [frb--language--operator-precedence-and-token-tables](../sections/frb--language--operator-precedence-and-token-tables.md) | The stringifier's precedence and token↔type tables; the parse↔compile assembly actually lives in `bind.js`/`observe.js`. |
| [frb--parse--parse-entry-and-tuple-shorthand](../sections/frb--parse--parse-entry-and-tuple-shorthand.md) | `frb/parse`: array-input tuple overload, error position annotation, the `collections/shim` side effect the compilers depend on. |

## See also

- [[frb-incremental-update]] — what the tree carries: the per-change delta, stage to stage.
- [[functional-reactive-bindings]] — the library whose query language compiles to this tree.

## Common confusions

- The query language is compiled to functions **once**, ahead of observation; it is not interpreted on every change. The runtime cost during watching is function calls over the tree, not parsing.
- An observer is distinct from a binder: the observer watches a source graph and emits change records; the binder applies change records to a target. A two-way binding pairs them in both directions.

## Source coverage

The model is now ingested at both levels. The README prose is captured under source `frb--readme` (the Reference and tutorial sections above), and the **source** behind it is captured under five source files (`grammar.pegjs`, `compile-observer.js`, `compile-binder.js`, `language.js`, `parse.js`), ingested cycle 4 (`scholar-ingest-frb-3`, 2026-06-24). The source sections add what the prose elides: the implicit-`mapBlock` rewrite and `inline` bare-function flag in the grammar, the README-undocumented declarative *sheet* grammar, the open-world method/operator fallback in the observer compiler, the enumerated invertible-roots set in the binder compiler, and the `algebra.js` `solve` routine behind "automatic algebraic inversion." One low-stakes prose-vs-source drift was noticed and recorded (the unary `+` node is `toNumber` in the source but labeled `number` in the README; see [frb--grammar--token-tables-and-precedence-climbing](../sections/frb--grammar--token-tables-and-precedence-climbing.md)), and one job-framing correction (`language.js` is the stringifier's table, not the parse/compile orchestrator; the assembly is in `bind.js`/`observe.js`; see [frb--language--operator-precedence-and-token-tables](../sections/frb--language--operator-precedence-and-token-tables.md)). `kriskowal/frb` is now fully ingested; no further `scholar-ingest-frb-*` follow-on is needed.
