---
title: FRB tutorial — order and grouping (sorted, sortedSet, min/max, group)
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

> Abstract: The order- and equivalence-class operators (Sorted, Unique and Sorted, Min and Max, Group). A `sorted{expression}` block maintains a sorted array, responding to a changed sort key by removing the element at its old position and reinserting it at the new one. `sortedSet{key}` produces a `SortedSet` of unique values for fast sorted lookup/insert/delete. `min{}`/`max{}` track the extreme value incrementally via an internal binary heap and accept a comparison expression. `group{key}` tracks equivalence classes as a nested array of `[key, class]` pairs; it is implemented as `groupMap{key}` (a `Map`, no range-change events) followed by an `entries()` observer, and `groupMap` can be used directly. Both group blocks respect the source collection type (a `SortedSet` source yields sorted-set classes).

**Sorted.** A `sorted` block maintains a sorted array of all source values. The block may name a property or expression to compare by; the binding responds to changes in the sort key by removing the element at its former place and re-adding it at its new position.

```javascript
var object = {numbers: [5, 2, 7, 3, 8, 1, 6, 4]};
bind(object, "sorted", {"<-": "numbers.sorted{}"}); // [1..8]

var object2 = {arrays: [[1,2,3], [1,2], [], [1,2,3,4], [1]]};
bind(object2, "sorted", {"<-": "arrays.sorted{-length}"}); // by descending length
```

**Unique and Sorted.** `sortedSet{key}` produces a `SortedSet` (not an `Array`) of unique values, useful for fast lookups, inserts, and deletes on sorted unique data. A sorted array of unique values can be composed from other operators instead: `folks.group{id}.sorted{.0}.map{.1.last()}`.

```javascript
Bindings.defineBindings({folks: [/* {id, name}, ... with a redundant entry */]}, {
    inOrder: {"<-": "folks.sortedSet{id}"},
    byId:    {"<-": "folks.map{[id, this]}.toMap()"},
    byName:  {"<-": "inOrder.toArray().group{name}.toMap()"}
});
```

**Min and Max.** A binding can observe the minimum or maximum, tracked incrementally via an internal binary heap. Min/max blocks accept an expression on which to compare values.

```javascript
var object = Bindings.defineBindings({}, {
    loser:  {"<-": "rounds.min{score}.player"},
    winner: {"<-": "rounds.max{score}.player"}
});
object.rounds = [{score:0,player:"Luke"}, {score:100,player:"Obi Wan"}, {score:250,player:"Vader"}];
// loser === "Luke", winner === "Vader"
object.rounds[1].score = 300; // winner === "Obi Wan"
```

**Group.** A `group{key}` block tracks equivalence classes, producing a nested array of `[key, class]` pairs where each class is an array of the members with that key.

```javascript
var store = Bindings.defineBindings({}, {clothingByColor: {"<-": "clothing.group{color}"}});
store.clothing = [{type:'shirt',color:'blue'}, {type:'pants',color:'red'}, {type:'blazer',color:'blue'}, {type:'hat',color:'red'}];
// [['blue', [shirt, blazer]], ['red', [pants, hat]]]
```

Tracking every key's and value's positions can be expensive. Internally `group` is a `groupMap` block (which produces a `Map` and emits no range-change events) followed by an `entries()` observer projecting the map into the nested array. `groupMap{key}` can be used directly to get the live `Map` of classes. Both blocks respect the source collection type: a `SortedSet` source yields sorted-set classes, where replacing values wastes much less than in a large array.

Source: [README.md](https://github.com/kriskowal/frb/blob/131db347355789cf2dbb79e49b10881d9716b449/README.md) at commit `131db347`.
