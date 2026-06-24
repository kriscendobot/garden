---
title: has operator
source: packages/has/README.md
source_repo: kriskowal/collections
source_commit: 4688abadf04b3bda247c61bc64ad38e2d3363809
source_date: 2020-11-06
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures]
status: current
---

> Abstract: `@collections/has` exports a `has(object, value, equals?)` operator that tests whether an object, array, or collection contains an equivalent value. Equivalence defaults to `@collections/equals` but a custom equality function can be passed (an identity test, a NaN-aware `===`, or any predicate). On arrays and objects it uses a `for/in` loop with ownership checks, so it is safe on large sparse arrays and searches owned property values of an object. For any object implementing a `has` method it delegates per the [[polymorphic-operator]] pattern, forwarding the sought value and the equality operator.

This package exports a has operator that accepts JavaScript objects, arrays, and collections and returns whether the object contains an equivalent value.

```js
var has = require("@collections/has");
expect(has([1, 2, 3], 2)).toBe(true);
expect(has({a: 10}), 10).toBe(true);
expect(has(new Set([10]), 10)).toBe(true);
epxect(has([[1], [2], [3]], [2])).toBe(true);
```

The has operator accepts an object, a sought value, and an optional alternate equality operator. By default, `has` uses `@collections/equals` to determine whether values are equivalent. Thus, you can alternately use an identity function or whatever you find suitable for determining equivalence.

```js
function is(x, y) {
    // The latter term is for NaN is NaN
    return x === y || (x !== x && y !== y);
}
expect(has([{}], {}, is)).toBe(false);
expect(has([1, 2, NaN], NaN, is)).toBe(true);
```

This operator can be safely used on large sparse arrays since it uses a for/in loop with ownership checks on arrays and objects by default. Thus, it is also suitable for searching values of the owned properties of an object.

## Polymorphic operator

The has operator delegates to the `has` method of any object that implements it. That method receives the sought value and the appropriate equals operator. See [[polymorphic-operator]] for the shared dispatch discipline.

(Copyright 2015 Kristopher Michael Kowal and contributors, MIT License.)

Source: [packages/has/README.md](https://github.com/kriskowal/collections/blob/4688abadf04b3bda247c61bc64ad38e2d3363809/packages/has/README.md) at commit `4688abad`.
