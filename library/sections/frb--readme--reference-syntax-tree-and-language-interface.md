---
title: Reference — Language Interface and Syntax Tree
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

> Abstract: The seam between the query language and the runtime. The **language interface** is three functions: `parse(text)` returns a syntax tree; `compileObserver(syntax)` returns `observe(callback, source, parameters)` by visiting each node and building functions from the `observers` module; `compileBinder(syntax)` returns `bind(observeValue, source, target, parameters)` by visiting the root node (which must be a `property` for now, though conceivably any cleanly-invertible function like `map`/`reversed`) and delegating its terms to `compileObserver`. The **syntax tree** is JSON-serializable, each node carrying a `type` and an `args` array (or an `args` object for `record`). Leaf types (`value`, `parameters`, `literal`, `element`, `component`) carry their own fields. Operator nodes map one-to-one from tokens (`**`→`pow`, `<=>`→`compare`, `==`→`equals`, and so on); `!=` has no node, expanding to `not(equals(...))` so the tree rotates algebraically. The `rangeContent`/`mapContent` nodes are binder hints: bind the target's content rather than replace the target.

### Language Interface

```javascript
var parse = require("frb/parse");
var compileObserver = require("frb/compile-observer");
var compileBinder = require("frb/compile-binder");
```

- `parse(text)` returns a syntax tree.
- `compileObserver(syntax)` returns an observer function of the form `observe(callback, source, parameters)` which in turn returns a `cancel()` function. `compileObserver` visits the syntax tree and creates functions for each node, using the `observers` module.
- `compileBinder(syntax)` returns a binder function of the form `bind(observeValue, source, target, parameters)` which in turn returns a `cancel()` function. `compileBinder` visits the root node of the syntax tree and delegates to `compileObserver` for its terms. The root node must be a `property` at this time, but could conceivably be any function with a clear inverse operation like `map` and `reversed`.

### Syntax Tree

The syntax tree is JSON serializable and has a "type" property. Leaf nodes:

- `value` corresponds to observing the source value.
- `parameters` corresponds to observing the parameters object.
- `literal` has a `value` property and observes that value.
- `element` has an `id` property and observes an element from `parameters.document` via `getElementById`.
- `component` has a `label` property and observes a component from `parameters.serialization` via `getObjectForLabel` (supports Montage's serialization format).

All other node types have an "args" property that is an array of syntax nodes (or an "args" object for `record`):

- `property`: observing a property named by the right argument of the left argument.
- `get`: observing the value for a key (second argument) in a collection (first argument).
- `with`: observing the right expression using the left expression as the source.
- `has`: whether the key (second argument) exists within a collection (first argument).
- `mapBlock` / `filterBlock` / `someBlock` / `everyBlock`: left is the input, right is the per-element expression (or predicate / criterion).
- `sortedBlock` / `minBlock` / `maxBlock`: left is the input, right is a relation on each value to compare. `sortedSetBlock` differs only in semantics from `sortedBlock`.
- `groupBlock`: left is the input, right gives the key for an equivalence class per value; the output is an array of `[key, class]` entries. `groupMapBlock` has the same input semantics but outputs a `Map` instead of an array of entries.
- `tuple`: any number of arguments, each an expression observed in terms of the source value.
- `record`: an args object; keys are property names of the result, values are the corresponding syntax nodes.
- `view`: arguments are the input, the start position, and the window length; the input may be any ranged-content collection.
- `rangeContent`: the content of an ordered collection that dispatches indexed range changes (array, sorted set); tells a binder to replace the content of the target rather than replace the target property. A range-content node has no effect on the source.
- `mapContent`: the content of a map-like collection (arrays and all map collections) that dispatches map changes; tells a binder to replace the content of the target map-like collection rather than replace the collection. On the source side it just passes the collection forward.

Operator node types (token → type): unary `+`→`number`, `-`→`neg`, `!`→`not`. Binary `**`→`pow`, `//`→`root`, `%%`→`log`, `*`→`mul`, `/`→`div`, `%`→`mod`, `rem`→`rem`, `+`→`add`, `-`→`sub`, `<`→`lt`, `<=`→`le`, `>`→`gt`, `>=`→`ge`, `<=>`→`compare`, `==`→`equals`, `&&`→`and`, `||`→`or`. `!=` produces unary negation around equality (no dedicated node), which makes the tree easier to rotate algebraically. Ternary `?`/`:`→`if`.

For all function calls, the right hand side is a tuple of arguments: `reversed`, `enumerate`, `flatten`, `sum`, `average`, `startsWith`, `endsWith`, `contains`, `join`, `split`, `range`, `keys`, `values`, `entries`.

Source: [README.md](https://github.com/kriskowal/frb/blob/131db347355789cf2dbb79e49b10881d9716b449/README.md) at commit `131db347`.
