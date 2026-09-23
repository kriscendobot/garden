---
title: FRB tutorial — windowing and structural operators (view, enumerate, range, flatten, concat, reversed)
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

> Abstract: The windowing and structural reshaping operators (View, Enumerate, Range, Flatten, Concat, Reversed). `view(start, length)` projects a sliding window over a large collection (such as a `SortedSet`) and reacts to changes in the collection and in the window's position and length. `enumerate()` produces `[index, value]` pairs (the prefix dot distinguishes the zeroth property `.0` from the literal `0`). `range(length)` produces consecutive integers `[0..length)`. `flatten()` projects a nested array of arrays into one flat array, reacting to both inner and outer changes. `concat(...)` observes the concatenation of dynamic arrays (equivalent to flattening the tuple of operands). `reversed()` binds an array's reversal and supports two-way bindings. As with every array-producing binding, the output array's identity is never replaced, only incrementally updated.

**View.** Projects a sliding window from a large source (e.g. a `SortedSet`) as an array, reacting to collection changes and to the window's `start` and `length`.

```javascript
var controller = {index: SortedSet([1,2,3,4,5,6,7,8]), start: 2, length: 4};
bind(controller, "view", {"<-": "index.view(start, length)"}); // [3,4,5,6]
controller.length = 3;       // [3,4,5]
controller.start = 5;        // [6,7,8]
controller.index.add(0);     // [5,6,7]  (content shifts the window)
```

**Enumerate.** Produces `[index, value]` pairs; bind to the index or value in later stages. The prefix dot distinguishes the zeroth property from the literal zero.

```javascript
bind(object, "lettersAtEvenIndexes", {"<-": "letters.enumerate().filter{!(.0 % 2)}.map{.1}"});
```

**Range.** Observes a length and produces (and incrementally updates) an array of consecutive integers from zero.

```javascript
Bindings.defineBinding({}, "stack", {"<-": "&range(length)"});
// length = 3 → [0, 1, 2];  length = 1 → [0]
```

**Flatten.** Projects a nested array of arrays into a flat array; changes to inner and outer arrays both project in.

```javascript
var arrays = [[1,2,3], [4,5,6]];
bind(object, "flat", {"<-": "flatten()", source: arrays}); // [1..6]
arrays.push([7,8,9]); arrays[0].unshift(0); // [0,1,2,3,4,5,6,7,8,9]
// the flat array is never replaced, only updated in place
```

**Concat.** Observes the concatenation of a collection of dynamic arrays; `[head].concat(tail)` is equivalent to `[[head], tail].flatten()`.

```javascript
Bindings.defineBinding({head: 10, tail: [20, 30]}, "flat", {"<-": "[head].concat(tail)"}); // [10, 20, 30]
```

**Reversed.** Binds the reversal of an array, and supports two-way bindings: changes to either side update the other.

```javascript
var object = {forward: [1, 2, 3]};
bind(object, "backward", {"<->": "forward.reversed()"}); // backward === [3,2,1]
object.forward.push(4);  // backward === [4,3,2,1]
object.backward.pop();   // forward === [2,3,4]
```

Source: [README.md](https://github.com/kriskowal/frb/blob/131db347355789cf2dbb79e49b10881d9716b449/README.md) at commit `131db347`.
