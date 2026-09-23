---
title: clone operator
source: packages/clone/README.md
source_repo: kriskowal/collections
source_commit: 4688abadf04b3bda247c61bc64ad38e2d3363809
source_date: 2020-11-06
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures]
status: current
---

> Abstract: `@collections/clone` exports a deep clone operator for arbitrary object graphs, including graphs with reference cycles. `clone(value, depth?, memo?)` returns a referentially equivalent graph: `depth` defaults to Infinity, and `memo` is an optional map (implementing `has`/`get`) that maps source objects to their clones, so cycles resolve and the finished memo reflects every cloned object. It replicates primitive values, arrays, objects inheriting directly from `Object.prototype`, and objects implementing `clone(depth, memo)`; anything else throws "Can't clone". Method-delegation follows the [[polymorphic-operator]] pattern; objects implementing `clone` receive the remaining depth and the memo (a `MiniMap` by default, overridable with `Map`/`WeakMap` for large graphs).

This package exports a deep clone operator that accepts arbitrary object graphs that may include reference cycles. The clone operator delegates to the `clone` method of any object that implements it. The clone method accepts a value or graph of objects and returns a referentially equivalent graph of objects.

- value
- depth, Infinity by default
- memo, an optional map, implementing `has` and `get`, suitable for mapping objects to objects.

```js
var clone = require("pop-clone");
var object = {};
object.object = object;
var mirror = clone(object);
```

Clone will replicate:

- values
- arrays
- objects that inherit directly from `Object.prototype`.
- objects that implement `clone(depth, memo)`.

Other values will throw a "Can't clone" error. When the clone is finished, the memo will contain the reflection of every object in the given graph.

```js
var memo = new Map();
var graph = {child: {}};
var cloned = clone(graph, null, memo);
expect(memo.get(graph.child)).toBe(cloned.child);
```

## Polymorphic operator

Objects that implement `clone` receive the remaining depth and a memo. If no memo is provided, the memo is a `MiniMap` from the `mini-map` package; it performs well enough for small collections, but a `Map` or `WeakMap` is preferable for a large object graph. See [[polymorphic-operator]] for the shared dispatch discipline.

```js
var object = {
    child: {
        clone: function (depth, memo) {
            expect(memo.has(object)).toBe(true);
            expect(depth).toBe(1);
            return "hello";
        }
    }
};
var cloned = clone(object, 2);
expect(cloned.child).toBe("hello");
```

(Factored out of Montage Studio's Collections; copyright 2014 Montage Studio, Inc. and contributors, BSD 3-Clause License.)

Source: [packages/clone/README.md](https://github.com/kriskowal/collections/blob/4688abadf04b3bda247c61bc64ad38e2d3363809/packages/clone/README.md) at commit `4688abad`.
