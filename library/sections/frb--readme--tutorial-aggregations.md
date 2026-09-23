---
title: FRB tutorial — incremental aggregations (sum, average, last, only)
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

> Abstract: The reduce-style aggregation operators (Sum, Average, Last, Only). Each maintains its result incrementally: when values are added or removed from the source array, only the delta is folded into the last known result rather than recomputing from scratch. `sum()` adjusts the running total by the added/removed values; `average()` adjusts a running sum and count; `last()` tracks the final element without jittering to null or a penultimate value when the collection mutates non-atomically; `only()` emits the single element of a one-element collection (null otherwise) and, as a binder, forces the bound collection to contain only the assigned value.

These are one-way (and, where noted, two-way) bindings from a collection that update by the delta of each change.

**Sum.** When values are added or removed, the sum of only those values is taken and added to or removed from the last known sum.

```javascript
var object = {array: [1, 2, 3]};
bind(object, "sum", {"<-": "array.sum()"}); // object.sum === 6
```

**Average.** Each change adjusts the last known sum and count of values, so the arithmetic mean updates incrementally.

```javascript
var object = {array: [1, 2, 3]};
bind(object, "average", {"<-": "array.average()"}); // object.average === 2
```

**Last.** Watches the last value in an array. When the dust settles, `array.last()` equals `array[array.length - 1]`, but the `last` observer guarantees it will not jitter between the ultimate value and null or the penultimate value when the underlying array does not change its content and length atomically.

```javascript
var array = [1, 2, 3];
var object = {array: array, last: null};
Bindings.defineBinding(object, "last", {"<-": "array.last()"}); // object.last === 3
array.push(4); // object.last === 4
// unshift+splice that leave the tail unchanged fire no change event:
array.unshift(0); array.splice(3, 0, 3.5); // object.last still 4, listener not called
array.pop();   // object.last === 3
array.clear(); // object.last === null
```

**Only.** The `only` observer emits the single value of a one-element collection, or null/undefined if there are zero or multiple values.

```javascript
var object = {array: [], only: null};
Bindings.defineBindings(object, {only: {"<->": "array.only()"}});
object.array = [1];       // object.only === 1
object.array.pop();       // object.only === undefined
object.array = [1, 2, 3]; // object.only === undefined
```

As a **binder**, `only` watches a value: when non-null it updates the bound collection so that the value is its only element (adding it to an empty collection, replacing the contents otherwise); when null it does nothing. Regardless of means, the end result is that a non-null value becomes the only value in the collection.

```javascript
object.only = 2;            // object.array === [2]
object.only = null;
object.array.push(3);      // object.array === [2, 3]
```

Source: [README.md](https://github.com/kriskowal/frb/blob/131db347355789cf2dbb79e49b10881d9716b449/README.md) at commit `131db347`.
