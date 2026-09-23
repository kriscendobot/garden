---
title: FRB bindings, descriptors, and the query language
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

> Abstract: FRB's highest-level interface, `Bindings`, which resembles the ES5 `Object` constructor and declares objects together with their bindings via extended property descriptors. Covers the `Bindings.defineBindings/defineBinding/getBindings/cancelBindings` API, the binding-descriptor fields (`<-` / `<->` source path, `source`, `convert`/`revert`/`converter`, `parameters`, `target`/`targetPath`, the cached `*Syntax` trees, `cancel`), and the key incremental-identity guarantee: the identity of a bound collection never changes, because all changes to it are applied incrementally rather than by reassignment.

The highest-level interface resembles the ES5 `Object` constructor and declares objects, defines and cancels bindings with extended property descriptors:

```javascript
var Bindings = require("frb");
var object = Bindings.defineBindings({
    foo: 0,
    graph: [{numbers: [1,2,3]}, {numbers: [4,5,6]}]
}, {
    bar: {"<->": "foo", enumerable: false},
    numbers: {"<-": "graph.map{numbers}.flatten()"},
    sum: {"<-": "numbers.sum()"},
    reversed: {"<-": "numbers.reversed()"}
});
```

Pushing `{numbers: [7,8,9]}` onto `graph` splices `[7,8,9]` onto `graph.map{numbers}.flatten()`, which increments `sum()` by `[7,8,9].sum()` — none of the intermediate arrays are rebuilt. **The identity of the bound `numbers` array never changes**, because every change to it is incrementally applied; `Bindings.cancelBindings(object)` recursively tears down every binding and its transitive observers and listeners.

The API surface: `Bindings.defineBindings(object, descriptors)`, `defineBinding(object, name, descriptor)`, `getBindings(object)`, `getBinding(object, name)`, `cancelBindings(object)`, `cancelBinding(object, name)`.

A binding **descriptor** contains: `target` / `targetPath` / `targetSyntax` (the target and its cached syntax tree); `source` (defaults to `target`); `sourcePath` and `sourceSyntax` (from `<-` or `<->`); `twoWay` (true when `<->` was used); `parameters` (default `source`); `convert` (source-to-target coercion) and `revert` (target-to-source, for two-way); `converter` (an object bundling `convert` and optional `revert`); `serializable` (a Montage serializer note); and `cancel` (the teardown function). The `<-` operator is a one-way binding, `<->` a two-way binding; the path expression after it is the small query language (property paths, `map{...}`, `flatten()`, `sum()`, `reversed()`, `filter{...}`, `sorted{...}`, `group{...}`, and the rest documented in the README tutorial, deferred to a follow-on ingest).

Source: [README.md](https://github.com/kriskowal/frb/blob/131db347355789cf2dbb79e49b10881d9716b449/README.md) at commit `131db347`.
