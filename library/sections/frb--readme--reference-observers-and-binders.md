---
title: Reference — Observers and Binders (the function-tree building blocks)
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

> Abstract: The lowest layer of FRB: the `observers` and `binders` modules whose functions are the nodes the compiler assembles into a tree. Every observer is or returns a function of the form `observe(emit, value, parameters)` that returns `cancel()`; the module supplies primitives (`observeValue`, `observeParameters`, `makeLiteralObserver`, `makeElementObserver`, `makeComponentObserver`) and maker functions per operator (`makePropertyObserver`, `makeGetObserver`, `makeMapBlockObserver`, `makeFilterBlockObserver`, `makeSortedBlockObserver`, `makeFlattenObserver`, `makeReversedObserver`, `makeSumObserver`, `makeAverageObserver`, `makeTupleObserver`, and so on), plus combinator utilities that are the heart of incrementality: `makeNonReplacing` (emit the array target once then update it in place, used by all array observers), `makeArrayObserverMaker` (build sum/average-style incremental reducers from a `setup(source, emit)` returning `{contentChange, cancel}`), `makeUniq` (forward only changed values), `autoCancelPrevious` (call the prior canceler before producing a new one, the mechanism behind nested-observer teardown), and `once`. The `binders` module mirrors this for the write side: `makePropertyBinder`, `makeGetBinder`, `makeHasBinder`, `makeEqualityBinder`, `makeRangeContentBinder`, `makeMapContentBinder`, `makeReversedBinder`, each of the form `bind(observeValue, source, target, parameters)` returning `cancel()`.

### Observers

The `observers` module contains functions for making all of the different types of observers, and utilities for creating new ones. All of these functions are or return an observer function of the form `observe(emit, value, parameters)` which in turn returns `cancel()`.

- `observeValue`, `observeParameters`
- `makeLiteralObserver(value)`, `makeElementObserver(id)`, `makeComponentObserver(label)`
- `makeRelationObserver(callback, thisp)` is unavailable through the property binding language; it translates a value through a JavaScript function.
- `makeComputerObserver(observeArgs, compute, thisp)` applies arguments to the computation function to get a new value.
- `makeConverterObserver(observeValue, convert, thisp)` calls the converter function to transform a value.
- `makePropertyObserver(observeObject, observeKey)`, `makeGetObserver(observeCollection, observeKey)`
- `makeMapFunctionObserver(observeArray, observeFunction)`, `makeMapBlockObserver(observeArray, observeRelation)`
- `makeFilterBlockObserver(observeArray, observePredicate)`, `makeSortedBlockObserver(observeArray, observeRelation)`
- `makeEnumerationObserver(observeArray)`, `makeFlattenObserver(observeOuterArray)`
- `makeTupleObserver(...observers)`, `makeObserversObserver(observers)`, `makeReversedObserver(observeArray)`
- `makeWindowObserver` is not presently available through the language and is subject to change; it watches a length from an array starting at an observable index.
- `makeSumObserver(observeArray)`, `makeAverageObserver(observeArray)`, `makeParentObserver(observeExpression)`, and others.

Utilities for making observer functions:

- `makeNonReplacing(observe)` accepts an array observer (emitted values must be arrays) and returns one that emits the target once and then incrementally updates that target. All array observers use this decorator to handle the source value getting replaced.
- `makeArrayObserverMaker(setup)` generates an observer that uses an array as its source and incrementally updates a target value, like `sum` and `average`. The `setup(source, emit)` function must return `{contentChange, cancel}` and arrange for `emit` to be called with new values when `contentChange(plus, minus, index)` receives incremental updates.
- `makeUniq(callback)` wraps an emitter callback so it only forwards new values; repeated values are ignored.
- `autoCancelPrevious(callback)` accepts an observer callback and returns one that arranges for the previous canceler to be called before producing a new one, and for the last canceler to be called when the whole tree is done.
- `once(callback)` accepts a canceler and ensures the cancelation routine is only called once.

### Binders

The `binders` module contains similar functions for binding an observed value to a bound value. All binders are of the form `bind(observeValue, source, target, parameters)` and return a `cancel()` function.

- `makePropertyBinder(observeObject, observeKey)`
- `makeGetBinder(observeCollection, observeKey)`
- `makeHasBinder(observeCollection, observeValue)`
- `makeEqualityBinder(observeLeft, observeRight)`
- `makeRangeContentBinder(observeTarget)`
- `makeMapContentBinder(observeTarget)`
- `makeReversedBinder(observeTarget)`

Source: [README.md](https://github.com/kriskowal/frb/blob/131db347355789cf2dbb79e49b10881d9716b449/README.md) at commit `131db347`.
