---
title: FRB tutorial — map and collection lookups (has, get, keys/values/entries, toMap)
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

> Abstract: The membership and key-value-mapping operators (Has, Get, Keys/Values/Entries, Coerce to Map). `has(value)` reflects whether a collection contains a value, reacting to both the collection and the sought value; it is not incremental but is cheap on the right data structure, and as a binder requires the target to implement `has`/`contains`, `add`, and `delete`/`remove` (FRB shims `Array` to provide these). `get(key)` observes a key-to-value mapping in an array or map collection (the key may itself be a variable). `keys()`/`values()`/`entries()` project a map's changes onto incrementally-updated arrays. `toMap()` coerces records, entry arrays, or maps into an incrementally-updated `Map`, preserving insertion order and letting the last entry win on duplicate keys.

**Has.** Binds a property to reflect whether a collection contains a value; reacts to changes in the collection and in the sought value. It is not incremental, but with the right data structure (Lists, Sets, OrderedSets from the [Collections][] package) updates are cheap. It can be one-way or bidirectional.

```javascript
var object = {haystack: [1, 2, 3], needle: 3};
bind(object, "hasNeedle", {"<-": "haystack.has(needle)"}); // true
object.haystack.pop(); // false  (3 removed)
object.needle = 2;     // true   (reacts to the value too)
```

As a **binder**, the left-hand collection must implement `has` or `contains`, `add`, and `delete` or `remove`. FRB shims `Array` to have `has`, `add`, and `delete`. A DOM element's `classList` implements `add`/`remove`/`contains` (so it works as a binder target) but not the content-change listeners (so it cannot be a right-hand source or be bidirectional).

**Get.** Observes changes in key-to-value mappings in arrays and map collections; the key may be a variable.

```javascript
bind(object, "second", {"<->": "array.get(1)"}); // tracks array[1] both ways
bind(object, "selected", {"<-": "source.get(key)"}); // source: a Map/Dict/SortedMap; key may change
```

The source may be a Map, Dict, MultiMap, SortedMap, SortedArrayMap, or anything implementing `get` and `addMapChangeListener`. You can also bind the whole content of one map-like collection to another with `mapContent()` (the source's content replaces the target's initially).

**Keys, Values, Entries.** When the source is a map, FRB projects map changes onto incrementally-updated arrays.

```javascript
Bindings.defineBindings({}, {
    keys:    {"<-": "map.keys()"},
    values:  {"<-": "map.values()"},
    entries: {"<-": "map.entries()"}  // [[k, v], ...]
});
```

**Coerce to Map.** `toMap()` coerces records (fixed-shape objects), arrays of entries, or maps into an incrementally-updated `Map`. The output map persists across changes to the input and maintains insertion order of keys; on duplicate keys the last entry wins (managed internally as `entries.group{.0}.map{.1.last()}`). If the input map is replaced, the output is cleared and repopulated.

Source: [README.md](https://github.com/kriskowal/frb/blob/131db347355789cf2dbb79e49b10881d9716b449/README.md) at commit `131db347`.
