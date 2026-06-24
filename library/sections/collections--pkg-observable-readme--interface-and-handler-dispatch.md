---
title: Observable interface and handler dispatch
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

> Abstract: The method catalog and handler-dispatch rules of `@collections/observable`. Each change kind (property, range, map) exposes paired `observe…`/`observe…WillChange` methods returning an Observer (with `cancel()`), and `dispatch…`/`dispatch…WillChange` methods for manual notification. Manual dispatch is required when a value changes without going through a setter or a collection mutator, which is why ObservableArray adds `set(index, value)`. Handlers may be raw functions or objects with handler methods; the observer picks the *most specific* method available at creation time, falling back to a generic one: a property observer on `length` calls `handleLengthPropertyChange` if present, else `handlePropertyChange`; range/map observers given a name (via `observeRangeChange(handler, name, ...)`) call `handle<Name>RangeChange` / `handle<Name>MapChange`, else the generic form. Observers are reusable, pooled objects whose internal state (object, handler, handlerMethodName, childObserver, note, capture, value/name) is inspectable for debugging.

Each type of observer provides before- and after-change methods for observation and manual dispatch. Manual dispatch is necessary for properties hidden behind a getter/setter when the getter's value changes without the setter being invoked; arrays require manual dispatch only when the value at an index changes without an array mutator (hence ObservableArray's `set(index, value)`). Ranged and map collections must implement manual dispatch when their `dispatchesRangeChanges` / `dispatchesMapChanges` properties are true.

### Method catalog

Property change observers:

- `observePropertyChange(object, handler, note, capture) -> Observer`
- `observePropertyWillChange(object, handler, note) -> Observer`
- `dispatchPropertyChange(object, name, plus, minus, capture)`
- `dispatchPropertyWillChange(object, name, plus, minus)`
- `makePropertyObservable(object, name)`, `preventPropertyObserver(object, name)`

Range change observers:

- `observeRangeChange(object, handler, note, capture) -> Observer`
- `observeRangeWillChange(object, handler, note) -> Observer`
- `dispatchRangeChange(object, plus, minus, index, capture)`
- `dispatchRangeWillChange(object, plus, minus, index)`

Map change observers:

- `observeMapChange(object, handler, note, capture) -> Observer`
- `observeMapWillChange(object, handler, note) -> Observer`
- `dispatchMapChange(object, type, key, plus, minus, capture)`
- `dispatchMapWillChange(object, type, key, plus, minus)`

Every observer has `Observer.prototype.cancel()`.

### Handler dispatch (specific then general)

Handlers may be raw functions or objects with one or more handler methods. At observer-creation time the observer selects the most specific available method, else the general one:

- Property: after change → `handleProperty<Name>Change` else `handlePropertyChange`; before change → `handleProperty<Name>WillChange` else `handlePropertyWillChange`.
- Range: a name supplied via `observeRangeChange(handler, name, note, capture)` selects `handle<Name>RangeChange` else `handleRangeChange` (and `…WillChange` before).
- Map: a name supplied via `observeMapChange(handler, name, note, capture)` selects `handle<Name>MapChange` else `handleMapChange` (and `…WillChange` before).

### Observer objects

Observers are reusable objects capturing observer state; `cancel()` disables the observer and returns it to a free list for reuse. They carry an informational `note` for third-party debugging. State fields include `object`, `propertyName`/`name`, `observers`, `handler`, `handlerMethodName`, `childObserver`, `note`, `capture`, and (for property observers) `value`.

### Implementing observability

`@collections/observable/object`, `/range`, and `/map` export mixable or prototypically inheritable constructors. Objects inheriting the interface must dispatch will-change and change notifications when observed, in every content-mutating method. Each exposes both static `ObservableX.method(object, ...)` and prototype `ObservableX.prototype.method(...)` forms of the observe/dispatch/make-observable methods.

(Originally copyright Motorola Mobility, Montage Studio, and contributors, BSD 3-Clause.)

Source: [packages/observable/README.md](https://github.com/kriskowal/collections/blob/4688abadf04b3bda247c61bc64ad38e2d3363809/packages/observable/README.md) at commit `4688abad`.
