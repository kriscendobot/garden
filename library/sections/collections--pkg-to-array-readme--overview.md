---
title: to-array operator
source: packages/to-array/README.md
source_repo: kriskowal/collections
source_commit: 4688abadf04b3bda247c61bc64ad38e2d3363809
source_date: 2020-11-06
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures]
status: current
---

> Abstract: `@collections/to-array` exports a `toArray` operator that coerces various types into arrays. Falsy values become an empty array; collections implementing `toArray` or `forEach` are delegated to (in that order); array-like objects (a `length` plus numbered properties) are copied; everything else throws. It iterates a given array-like object itself rather than passing it through `arguments`, which would deoptimize the calling function. Delegation to `toArray`/`forEach` is the [[polymorphic-operator]] dispatch pattern.

This package exports a toArray operator that accepts various types and coerces them into arrays.

- Falsy values are coerced to an empty array.
- Delegates to the `toArray` method of collections that implement that method.
- Delegates to the `forEach` method of other collections that implement that method.
- Objects that have a length and numbered properties are coerced into an array. Note that passing `arguments` as an argument to toArray will probably deoptimize the calling function. However, arrayify defends itself from being deoptimized in this fashion by iterating the given object itself.
- Throws an exception for all other cases.

## Examples

```
npm install @collections/to-array
```

```js
"use strict";
var toArray = require("@collections/to-array");
```

Copies arrays.

```js
var array = [1, 2, 3];
var arrayed = toArray(array);
expect(arrayed).not.toBe(array);
expect(arrayed).toEqual(array);
```

Copies objects that implement `toArray`.

```js
var List = require("collections/list");
var list = new List([1, 2, 3]);
expect(toArray(list)).toEqual([1, 2, 3]);
```

Copies objects that implement (synchronous) `forEach`.

```js
expect(toArray({
    forEach: function (callback, thisp) {
        callback.call(thisp, 1);
        callback.call(thisp, 2);
        callback.call(thisp, 3);
    }
})).toEqual([1, 2, 3]);
```

Coerces array-like objects:

```js
expect(toArray({
    length: 3,
    0: 1,
    1: 2,
    2: 3
})).toEqual([1, 2, 3]);
```

Coerces falsy values to empty arrays.

```js
expect(toArray(null)).toEqual([]);
```

Supports no other cases.

```js
expect(function () {
    toArray({});
}).toThrow();
```

## Polymorphic operator

`toArray` delegates first to a `toArray` method and then to a `forEach` method on the operand. See [[polymorphic-operator]] for the shared dispatch discipline.

(Copyright 2015 Kristopher Michael Kowal and contributors, MIT License.)

Source: [packages/to-array/README.md](https://github.com/kriskowal/collections/blob/4688abadf04b3bda247c61bc64ad38e2d3363809/packages/to-array/README.md) at commit `4688abad`.
