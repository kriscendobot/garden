---
title: Observable content-change model
source: packages/observable/README.md
source_repo: kriskowal/collections
source_commit: 4688abadf04b3bda247c61bc64ad38e2d3363809
source_date: 2020-11-06
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures]
status: current
---

> Abstract: `@collections/observable` provides a system for *synchronously* observing content changes to arrays, objects, and other instances. Three kinds of change exist: **property change** (a named property's value changed), **range change** (ordered values removed then added at an index), and **map change** (the value for a key in a map changed). Each kind has a *will-change* (before) and a *change* (after) variant. Distinguishing design points: change notifications pass the observed object as their last argument so one handler can service many objects; a handler method may return a *child observer* that is implicitly cancelled before the next change, so observers stack (observe a property, and within the handler observe a property of the new value); observer objects are pooled and reused to reduce garbage collection, and expose their internal state for debugging. The library never mutates plain arrays or `Array.prototype`; observing an array promotes that instance to an ObservableArray (gaining `swap` and `set`) by subverting its prototype or adding own properties. This is the change-notification protocol the whole `@collections/*` family (and `frb`) builds on.

This package provides a system for synchronously observing content changes to arrays, objects, and other instances. These observers have a common, composable style, expose their internal state for debugging, and reuse state-tracking objects to reduce garbage collection.

- Changes can be captured before or after they are made.
- The last argument of a change notification is the object observed, so a single handler can service multiple objects.
- Handler methods can return a child observer object, which will be implicitly cancelled before the next change, so observers can be stacked.
- Does not alter the Array base type, but promotes array instances to an ObservableArray when they are observed.

### Examples

Observing the length of an array:

```js
var array = [];
var observer = O.observePropertyChange(array, "length", function (length) {
    expect(length).toBe(1);
});
array.push(10);
observer.cancel();
```

Observing values at indexes dispatches `(plus, minus, index, object)`:

```js
var handler = {
    handlePropertyChange: function (plus, minus, index, object) { /* ... */ }
};
O.observePropertyChange(array, 0, handler);
array.set(0, 10); // plus: 10, minus: undefined, index: 0, object: array
array.set(0, 20); // plus: 20, minus: 10, index: 0, object: array
```

Mirroring an array via range changes (with `@collections/swap`):

```js
O.observeRangeChange(array, function (plus, minus, index) {
    swap(mirror, index, minus.length, plus);
});
```

Stacked observers via a returned child observer (the inner observer is re-cancelled every time the outer value changes):

```js
O.observePropertyChange(a, "b", function (b) {
    return O.observePropertyChange(b, "c", function (c) { value = c; });
});
```

### Change notification arguments

- **Property change** observers dispatch `(plus, minus, name, object)` when the value of a named property changes (old value `minus`, new value `plus`, property `name`, observed `object`). Observing a property of an ordinary object replaces it with a getter/setter.
- **Range change** observers dispatch `(plus, minus, index, object)` when ordered values are removed (captured in the `minus` array) then added (the `plus` array) at a particular index.
- **Map change** observers dispatch `(plus, minus, key, object)` when the value for a specific key in a map changes.

### Behavior on arrays

This library does not alter plain JavaScript arrays or the Array prototype. Observing an array transforms it into an ObservableArray (gaining `swap` and `set` methods) either by subverting its prototype or by adding properties directly to the instance. Property observation dispatches changes for `"length"` or any indexed value; range observation makes all mutators produce range notifications; map observation dispatches changes to the value at a given index.

### Custom types

Arbitrary constructors can mix in or inherit `ObservableObject` (from `@collections/observable/object`) to support the interface with no further work. Constructors mixing in `ObservableRange` (`/range`) or `ObservableMap` (`/map`) must *explicitly* dispatch will-change and change notifications in every content-mutating method when `dispatchesRangeChanges` / `dispatchesMapChanges` is true. Mixing in can also be done by copying own properties off the prototype.

(Originally copyright Motorola Mobility, Montage Studio, and contributors, BSD 3-Clause.)

Source: [packages/observable/README.md](https://github.com/kriskowal/collections/blob/4688abadf04b3bda247c61bc64ad38e2d3363809/packages/observable/README.md) at commit `4688abad`.
