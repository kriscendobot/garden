---
title: equals operator
source: packages/equals/README.md
source_repo: kriskowal/collections
source_commit: 4688abadf04b3bda247c61bc64ad38e2d3363809
source_date: 2020-11-06
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures]
status: current
---

> Abstract: `@collections/equals` exports a deep, *polymorphic* equality operator. `equals(left, right)` performs deep equality on objects and arrays and delegates to an `equals` method on either argument, favoring the left. Core principle: every value is equal to itself, including NaN, so it is suitable for verifying equivalent keys/values for storage and retrieval in collections; boxed values equal their unboxed equivalents. Unlike `compare`, `equals` *can* be used on cyclic object graphs: it memoizes already-seen objects in a `MiniMap` by default, and the memo (any structure implementing `set`/`has`, including a reusable `Map`/`WeakMap`) can be overridden. Plain objects are equal when they have the same keys and values regardless of order; arrays are equal to any object with the same length and owned entries (sparse arrays included). Signature: `equals(left, right, equalsChild?, memo?)`.

This package exports an equality operator that accepts arbitrary objects and performs deep equality checks on objects and arrays, as well as delegating to the `equals` method of other objects.

As a core principle, every value is equal to itself, including NaN, making this suitable for verifying equivalent keys or values for storage or retrieval in collections. A boxed value, like `new Number(10)`, is always equal to its unboxed equivalent.

This operator can be safely used on object graphs that contain reference cycles. By default, `equals` uses a `MiniMap` to recall objects it has already seen, but this `memo` can be overridden.

```js
var cycle = {};
cycle.cycle = cycle;
equals(cycle, cycle, null, new Map());
```

`equals` accepts:

- left side value
- right side value
- `equals`, optional alternate equality checker for children
- `memo`, optional alternate map for memoizing already-visited values (a `Map`, `WeakMap`, or any memo implementing `set` or `has`). These maps can be reused if the equivalent objects remain equivalent between calls.

Objects, so long as they are direct descendants of the Object prototype, are equivalent if they have the same keys and same respective values; order is not significant. An array, regardless of left or right position, is equivalent to any object with the same length and owned properties, so sparse arrays with the same length and the same entries are equivalent.

## Polymorphic operator

The equals operator delegates to the `equals` method of either the left or right value, favoring the left, if either implements `equals`. It passes the other argument and forwards the alternate `equals` and `memo`. Custom `equals` methods are expected to accept and use these arguments, or at least forward them in any recursive equality checks. (This is the same polymorphic-operator discipline `compare` uses: cover for higher architectural layers, defer to method names defined later.)

(Originally copyright Montage Studio Inc., BSD 3-Clause.)

Source: [packages/equals/README.md](https://github.com/kriskowal/collections/blob/4688abadf04b3bda247c61bc64ad38e2d3363809/packages/equals/README.md) at commit `4688abad`.
