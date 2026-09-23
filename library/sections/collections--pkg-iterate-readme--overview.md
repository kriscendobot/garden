---
title: iterate operator
source: packages/iterate/README.md
source_repo: kriskowal/collections
source_commit: 4688abadf04b3bda247c61bc64ad38e2d3363809
source_date: 2020-11-06
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures]
status: current
---

> Abstract: `@collections/iterate` exports an `iterate` operator that accepts an array or any object implementing `iterate` and returns an iterator following the JS iterator protocol with one extension: each iteration carries an `index` property holding the index (for arrays) or key (for objects) of the value. On arrays the `iterate` method accepts optional `start`, `stop`, `step` arguments; it also iterates the owned properties of plain objects. Other types become iterable by implementing `iterate(start, stop, step)`, to which the operator delegates per the [[polymorphic-operator]] pattern. The package also exports its building blocks (`@collections/iterate/iteration`, `/array`, `/object`).

This package exports an iterator operator that accepts arrays and any object that implements iterate. The iterate operator accepts an array, or object that implements iterate, and returns an iterator, as described by the [iterator protocol](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/The_Iterator_protocol), with some extensions. The iterations have an index property with the index (or key) corresponding to the value.

```js
var iterator = iterate([1, 2, 3]);
expect(iterator.next()).toEqual({value: 1, done: false, index: 0});
expect(iterator.next()).toEqual({value: 2, done: false, index: 1});
expect(iterator.next()).toEqual({value: 3, done: false, index: 2});
expect(iterator.next()).toEqual({done: true});
```

Iterating on an array, the iterate method accepts optional start, stop, and step arguments.

```js
var array = [1, 2, 3, 4, 5, 6, 7, 8];
var iterator = iterate(array, 1, 6, 2);
expect(iterator.next()).toEqual({value: 2, done: false, index: 1});
expect(iterator.next()).toEqual({value: 4, done: false, index: 3});
expect(iterator.next()).toEqual({value: 6, done: false, index: 5});
expect(iterator.next()).toEqual({done: true});
```

The iterate operator also iterates the owned properties of an object.

```js
var object = {a: 10, b: 20, c: 30};
var iterator = iterate(object);
expect(iterator.next()).toEqual({value: 10, done: false, index: "a"});
expect(iterator.next()).toEqual({value: 20, done: false, index: "b"});
expect(iterator.next()).toEqual({value: 30, done: false, index: "c"});
expect(iterator.next()).toEqual({done: true});
```

## Polymorphic operator

Any object can be iterable by implementing the `iterate` method, and the iterate operator will defer to it. See [[polymorphic-operator]] for the shared dispatch discipline.

```js
function Collection() {}
Collection.prototype.iterate = function (start, stop, step) {
};
```

This package also exports the individual parts from which it makes iterators.

```js
var Iteration = require("@collections/iterate/iteration");
var ArrayIterator = require("@collections/iterate/array");
var ObjectIterator = require("@collections/iterate/object");
```

(Copyright 2015 Kristopher Michael Kowal and contributors, MIT License.)

Source: [packages/iterate/README.md](https://github.com/kriskowal/collections/blob/4688abadf04b3bda247c61bc64ad38e2d3363809/packages/iterate/README.md) at commit `4688abad`.
