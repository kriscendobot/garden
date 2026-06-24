---
title: zip and unzip transposition operators
source: packages/zip/README.md
source_repo: kriskowal/collections
source_commit: 4688abadf04b3bda247c61bc64ad38e2d3363809
source_date: 2020-11-06
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures]
status: current
---

> Abstract: `@collections/zip` provides `zip`, `unzip`, and polymorphic variants of both. `zip(...arrays)` accepts any number of arrays and returns an array of the respective values from each. `unzip` is identical but takes an array of arrays and is behaviorally a matrix transpose for matrices modeled as nested arrays. The polymorphic variants (the [[polymorphic-operator]] pattern) accept arrays or richer collections: other collections are expected to implement `toArray`, which zip and unzip use to funnel the object into the non-polymorphic `unzip`. Released in the small-modules spirit; distinguished from `array-zip` (zip-only, V8-deoptimizing) and `transpose` (unzip-only, strictly rectangular).

This package provides zip, unzip, and "polymorphic" versions of these operators. Zip is a function that accepts any number of arrays and returns an array of the respective values from each of the given arrays.

```js
var zip = require("pop-zip/zip");
expect(zip(
    ['a', 'b', 'c'],
    [1, 2, 3],
    ['x', 'y', 'z']
)).toEqual([
    ['a', 1, 'x'],
    ['b', 2, 'y'],
    ['c', 3, 'z']
]);
```

Unzip is identical but accepts an array of arrays. Unzip is behaviorally identical to a matrix transpose for matrices modeled as nested arrays.

```js
var unzip = require("pop-zip/unzip");
expect(unzip([
    ['a', 'b', 'c'],
    [1, 2, 3],
    ['x', 'y', 'z']
])).toEqual([
    ['a', 1, 'x'],
    ['b', 2, 'y'],
    ['c', 3, 'z']
]);
```

## Polymorphic operator

This package also exports polymorphic versions of zip and unzip, for when you may be working with an array or some more sophisticated collection. Other collection objects are expected to implement `toArray`, and both zip and unzip use these methods to funnel the resulting object array of arrays into the non-polymorphic unzip. See [[polymorphic-operator]] for the shared dispatch discipline.

```js
var zip = require("pop-zip");
var unzip = require("pop-zip/pop-unzip");
```

## Alternatives

The [array-zip](https://github.com/frozzare/array-zip) package is similar, but focuses on an implementation of `zip` alone, not based on unzip, using a straightforward approach with functional idioms; it suffers from a V8 deoptimization (on passing arguments objects) and some garbage collector churn of throw-away closures.

The [transpose](https://github.com/ttrfstud/transpose) package is similar, focusing on an implementation of `unzip`, but only works for strictly rectangular arrays of arrays. This implementation of `unzip` scans forward for the longest nested array to determine the length of the whole array, and builds the transpose in row major order instead of column major.

Most other alternatives bundle unzip into a larger collection of functions, chainable methods, or monkey patches on Array. This package is released in the spirit of small modules, coherent with other polymorphic operator packages.

(Copyright 2015 Kristopher Michael Kowal and contributors, MIT License.)

Source: [packages/zip/README.md](https://github.com/kriskowal/collections/blob/4688abadf04b3bda247c61bc64ad38e2d3363809/packages/zip/README.md) at commit `4688abad`.
