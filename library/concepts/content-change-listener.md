---
id: content-change-listener
aliases: ["observable", "@collections/observable", "content change", "change notification", "range change", "map change", "property change", "ObservableArray", "ObservableObject", "ObservableRange", "ObservableMap", "addRangeChangeListener", "dispatchRangeChange", "will-change", "child observer", "observePropertyChange"]
topics: [data-structures]
status: draft
---

# content-change-listener

The synchronous content-change observation interface that `kriskowal/collections` (and the reactive-bindings library `frb`) build on. `@collections/observable` defines three kinds of change, each with a *will-change* (before) and a *change* (after) variant: **property change** dispatches `(plus, minus, name, object)` when a named property's value changes; **range change** dispatches `(plus, minus, index, object)` when ordered values are removed (the `minus` array) then added (the `plus` array) at an index; **map change** dispatches `(plus, minus, key, object)` when a key's value changes. Distinguishing design points: the observed object is the last notification argument so one handler can service many objects; a handler method may return a *child observer* that is implicitly cancelled before the next change, so observers stack; observer objects are pooled (a `cancel()` returns them to a free list) and expose their state for debugging; and the library never mutates `Array.prototype`, instead promoting an observed array instance to an ObservableArray (gaining `set` and `swap`). Handlers may be functions or objects; the observer binds the most specific handler method available at creation (`handle<Name>RangeChange`, else `handleRangeChange`). Custom types gain the interface by mixing in `ObservableObject` / `ObservableRange` / `ObservableMap` and dispatching notifications from their mutators when `dispatchesRangeChanges` / `dispatchesMapChanges` is set.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [collections--pkg-observable-readme--change-observation-model](../sections/collections--pkg-observable-readme--change-observation-model.md) | The three change kinds, before/after, child observers, array promotion, custom-type mixins. |
| [collections--pkg-observable-readme--interface-and-handler-dispatch](../sections/collections--pkg-observable-readme--interface-and-handler-dispatch.md) | The observe/dispatch method catalog, specific-then-general handler dispatch, observer-object fields. |
| [collections--pkg-generic-map-readme--overview](../sections/collections--pkg-generic-map-readme--overview.md) | Every generic map is observable: mutators dispatch map-change notifications when observers exist. |

## See also

- [[generic-collection-mixin-protocol]] — the mixin family; `generic-map` requires the ObservableMap methods.
- [[functional-reactive-bindings]] — frb consumes this change-notification protocol to bind expressions to collections.
- [[generic-collections]] — the structure library whose mutators dispatch these notifications.
