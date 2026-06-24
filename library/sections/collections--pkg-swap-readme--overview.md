---
title: swap operator
source: packages/swap/README.md
source_repo: kriskowal/collections
source_commit: 4688abadf04b3bda247c61bc64ad38e2d3363809
source_date: 2020-11-06
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures]
status: current
---

> Abstract: `@collections/swap` is an allocation-frugal alternative to `Array.prototype.splice` for very long array changes. `swap(array, index, length, values?)` removes `length` values after `index` and inserts the optional `values`, returning nothing. Unlike `splice` it (1) does not allocate an array of removed values, (2) can add values beyond the end of a sparse array, and (3) is not variadic, so it never overflows the stack on a large change (`splice` projects its variadic arguments onto the stack). It is the underlying operator for operational transforms and the foundation of observable arrays: `splice`, `pop`, `push`, `shift`, `unshift`, and `clear` can all channel through `swap`. It also delegates to a `swap` method per the [[polymorphic-operator]] pattern. (The same Swap primitive underlies cask's parallel-arrays in-memory pattern; see [[parallel-arrays-columnar]].)

Swap is an alternative method for splicing arrays that avoids unnecessary allocations and works for very long array changes.

## Rationale

At first blush, every method of an array that modifies its content can be implemented in terms of `splice`.

```
pop(): splice(length - 1, 1)[0]
push(...values): splice(length, 0, ...values)
shift(): splice(0, 1)[0]
unshift(...values): splice(0, 0, ...values)
clear(): splice(0, length)
```

Splice always returns an array of the values removed, which is not useful for modeling all of these methods. Splice, at first blush, is also the appropriate operator to apply operational transforms. An operational transform either adds values at a position, or removes values from a position. For this purpose, splice has some disadvantages.

1. For sparse arrays, splice cannot be used to add new values beyond the end of the array; splice shifts the change to the end of the array.
2. Because splice is variadic, accepting any number of arguments, those arguments get projected onto the stack. For a sufficiently large change, splice will throw a stack overflow RangeError.

## Swap rather than Splice

Swap has no return value and accepts an optional array of values to add. It is well-suited as the underlying operator for operational transforms since it wastes nothing for addition only and removal only, can add sparse arrays beyond the end of a sparse array, and does not deal with the arguments object.

```js
var swap = require("@collections/swap/array");
swap(array, index, length, values?);
```

Swap accepts an array, an index, the number of values to remove after that index, then the values to add after that index. The added values are optional. The array or array of values to add may be sparse. Swap returns nothing.

It is also suitable for implementing the remaining array methods, if you need to implement all of those array methods in a way that channels through swap. This is the story behind observable arrays.

```
splice(index, minus, ...values):
    index = Math.min(index, this.length);
    var result = this.slice(index, index + minus);
    swap(index, minus, values);
    return result;
pop():
    var last = this[this.length - 1];
    swap(this.length - 1, 1);
    return last;
push(...values)
    swap(this.length, 0, values);
shift():
    var first = this[0];
    swap(0, 1);
    return first;
unshift(...values):
    swap(0, 0, values);
clear();
    swap(0, this.length);
```

## Polymorphic operator

Swap delegates to a `swap` method on the operand, so a proxy can route content changes through the operator. See [[polymorphic-operator]] for the shared dispatch discipline.

```js
var swap = require("@collections/swap");
var array = ['Hello', 'World!'];
swap(array, 0, 1, ['Farewell']);

var proxy = {
    array: ['Hello', 'World!'],
    swap: function (start, minusLength, plus) {
        swap(this.array, start, minusLength, plus);
    }
};
swap(proxy, 0, 1, ['Farewell']);
```

(Copyright 2015 Kristopher Michael Kowal and contributors, MIT License.)

Source: [packages/swap/README.md](https://github.com/kriskowal/collections/blob/4688abadf04b3bda247c61bc64ad38e2d3363809/packages/swap/README.md) at commit `4688abad`.
