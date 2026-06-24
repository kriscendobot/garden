---
title: FRB tutorial — two-way bindings, direction, property paths, structure changes
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

> Abstract: The foundational tutorial subsections (Two-way Bindings, Right-to-left, Properties, Structure changes). A one-way binding (`<-`) reassigns the target whenever the source changes; a two-way binding (`<->`) keeps both sides intertwined. On a two-way binding the right-to-left assignment runs first at setup, so the target's initial value is lost. Bindings follow deeply nested property paths on either side, and they survive structural change: when an intermediate object in the path is replaced, orphaned listeners are canceled and observers reattach to the new graph automatically.

A one-way binding reassigns the target any time the source changes; the returned cancel function recursively detaches the binding from everything it observes.

```javascript
var bind = require("frb/bind");
var model = {content: "Hello, World!"};
var cancelBinding = bind(document, "body.innerHTML", {"<-": "content", source: model});
model.content = "Farewell.";
// document.body.innerHTML === "Farewell."
cancelBinding();
model.content = "Hello again!"; // doesn't take
```

**Two-way bindings.** Declare one-way bindings with `<-`, two-way with `<->`. With `<->` the two properties are inexorably intertwined: a change on either side propagates to the other.

```javascript
var object = {};
var cancel = bind(object, "foo", {"<->": "bar"});
object.bar = 10; // object.foo === 10
object.foo = 20; // object.bar === 20
```

**Right-to-left precedence.** Even with a two-way binding, the right-to-left binding precedes the left-to-right at setup. So when both sides have initial values, the source (right) value wins and the target's (left) initial value is lost.

```javascript
var object = {foo: 10, bar: 20};
var cancel = bind(object, "foo", {"<->": "bar"});
// object.foo === 20, object.bar === 20  (bar→foo ran first)
```

**Property paths.** Bindings follow deeply nested chains on both the left and the right side.

```javascript
var foo = {a: {b: 10}};
var bar = {a: {b: 10}};
var cancel = bind(foo, "a.b", {"<->": "a.b", source: bar});
bar.a.b = 20; // foo.a.b === 20
foo.a.b = 30; // bar.a.b === 30
```

**Structure changes.** Changes to the structure of either side are no matter: orphaned event listeners are automatically canceled, and the binders and observers reattach to the new object graph. Replacing the intermediate `a` object orphans the old `b` and adopts the new one in its place.

```javascript
var a = foo.a; // a.b === 30
foo.a = {};    // orphan a and replace
foo.a.b = 40;  // bar.a.b === 40 (updated)
bar.a.b = 50;  // foo.a.b === 50 (new one updated)
// a.b === 30  (the orphaned object stops tracking)
```

Source: [README.md](https://github.com/kriskowal/frb/blob/131db347355789cf2dbb79e49b10881d9716b449/README.md) at commit `131db347`.
