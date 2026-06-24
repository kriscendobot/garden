---
title: Reference — the programmatic module API (Bindings, Bind, Compute, Observe, Evaluate, Stringify)
source: README.md
source_repo: kriskowal/frb
source_commit: 131db347355789cf2dbb79e49b10881d9716b449
source_date: 2013-09-15
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [reactive-bindings]
status: current
notes: Reference-shape catalog of the per-module entry points. Soft-overlaps the tutorial sections frb--readme--tutorial-bindings-interface (Bindings) and frb--readme--tutorial-observer-interface (Observe); the tutorial sections teach, this one enumerates the modules and the binding-descriptor field list. The Reference section's own six-adjectives overview and four-layer Architecture restatement (README lines 1768-1828) duplicate frb--readme--properties and frb--readme--architecture and are not re-ingested.
---

> Abstract: FRB's reference layer is a stack of single-purpose modules, each exporting one function. `frb` (top) declares objects and bindings with extended ES5-style property descriptors and lists the full **binding-descriptor field set** (`target`, `targetPath`, `targetSyntax`, `source`, `sourcePath`, `sourceSyntax`, `twoWay`, `parameters`, `convert`, `revert`, `converter`, `serializable`, `cancel`). `frb/bind` exposes `bind(target, path, descriptor)` directly and is built on `parse`, `compileBinder`, and `compileObserver`. `frb/compute` makes computed properties (`args` + `compute`). `frb/observe` exposes `observe(source, path, callback|descriptor)` returning a cancelation hierarchy, built on `parse` and `compileObserver`. `frb/evaluate` and `frb/compile-evaluator` produce one-shot values from a path or syntax tree against a `Scope`, without setting up incremental observers. `frb/stringify` renders a syntax tree back to its normal-form path string.

### Bindings

The highest level interface for FRB resembles the ES5 Object constructor and can be used to declare objects and define and cancel bindings on them with extended property descriptors.

```javascript
var Bindings = require("frb");

var object = Bindings.defineBindings({
    foo: 0,
    graph: [ {numbers: [1,2,3]}, {numbers: [4,5,6]} ]
}, {
    bar: {"<->": "foo", enumerable: false},
    numbers: {"<-": "graph.map{numbers}.flatten()"},
    sum: {"<-": "numbers.sum()"},
    reversed: {"<-": "numbers.reversed()"}
});

// the identity of the bound numbers array never changes, because all
// of the changes to that array are incrementally updated
var numbers = object.numbers;
expect(object.sum).toEqual(21);
object.graph.push({numbers: [7, 8, 9]});   // sum() increments by [7,8,9].sum()
expect(object.sum).toEqual(45);
object.graph[0].numbers.unshift(1);        // sum() increments by [1].sum()
expect(object.sum).toEqual(46);
object.graph = [{numbers: [1,2,3]}];       // cancels the observer hierarchy, attaches a new one
expect(object.sum).toEqual(6);
expect(object.numbers).toBe(numbers);      // still the same object
Bindings.cancelBindings(object);           // cancels all bindings and their transitive observers
```

The methods: `Bindings.defineBindings(object, descriptors)`, `Bindings.defineBinding(object, name, descriptor)`, `Bindings.getBindings(object)`, `Bindings.getBinding(object, name)`, `Bindings.cancelBindings(object)`, `Bindings.cancelBinding(object, name)`.

A binding descriptor contains:

- `target`: the target object.
- `targetPath`: the target path.
- `targetSyntax`: the syntax tree for the target path.
- `source`: the source object, which defaults to `target`.
- `sourcePath`: the source path, from either `<-` or `<->`.
- `sourceSyntax`: the syntax tree for the source path.
- `twoWay`: whether the binding goes in both directions, if `<->` was the source path.
- `parameters`: the parameters, which default to `source`.
- `convert`: a function that converts the source value to the target value (coercing strings to dates, for example).
- `revert`: a function that converts the target value to the source value, useful for two-way bindings.
- `converter`: an object with `convert` and optionally also a `revert` method. The implementation binds these methods to their converter and stores them in `convert` and `revert`.
- `serializable`: a note from the Montage Deserializer to the Montage Serializer, indicating that the binding came from a serialization and must return to one.
- `cancel`: a function to cancel the binding.

### Bind

The `bind` module provides direct access to the `bind` function. `bind` is built on top of `parse`, `compileBinder`, and `compileObserver`.

```javascript
var bind = require("frb/bind");
var source = [{numbers: [1,2,3]}, {numbers: [4,5,6]}];
var target = {};
var cancel = bind(target, "summary", {
    "<-": "map{[numbers.sum(), numbers.average()]}",
    source: source
});
expect(target.summary).toEqual([ [6, 2], [15, 5] ]);
cancel();
```

### Compute

The `compute` module provides direct access to the `compute` function, used by `Bindings` to make computed properties.

```javascript
var compute = require("frb/compute");
var source = {operands: [10, 20]};
var target = {};
var cancel = compute(target, "sum", {
    source: source,
    args: ["operands.0", "operands.1"],
    compute: function (a, b) { return a + b; }
});
expect(target.sum).toEqual(30);
source.operands.set(1, 30); // needed to dispatch change notification
expect(target.sum).toEqual(40);
```

### Observe

The `observe` module provides direct access to the `observe` function. `observe` is built on top of `parse` and `compileObserver`; `compileObserver` creates a tree of observers using the methods in the `observers` module.

```javascript
var observe = require("frb/observe");
var source = [1, 2, 3];
var sum;
var cancel = observe(source, "sum()", function (newSum) { sum = newSum; });
expect(sum).toBe(6);
source.push(4);
expect(sum).toBe(10);
source.unshift(0); // no change
expect(sum).toBe(10);
cancel();
source.splice(0, source.length); // would change, but observer is canceled
expect(sum).toBe(10);
```

`observe` produces a cancelation hierarchy. Each time a value is removed from an array, the underlying observers are canceled; each time a property is replaced, the underlying observer is canceled; when new values are added or replaced, the observer produces a new canceler. The cancel function returned by `observe` commands the entire underlying tree. Observers also optionally accept a descriptor in place of a callback, with `set` (the change handler, receiving `value` and also `key`/`object` for property changes), `parameters` (the value for `$` expressions), `beforeChange` (emit the previous value before a change), and `contentChange` (emit an array every time its content changes, since by default arrays are only emitted once).

### Evaluate

The `compile-evaluator` module returns a function that accepts a syntax tree and returns an evaluator function. The evaluator accepts a scope (which may include a value, parent scope, parameters, a document, and components) and returns the corresponding value without all the cost or benefit of setting up incremental observers.

```javascript
var parse = require("frb/parse");
var compile = require("frb/compile-evaluator");
var Scope = require("frb/scope");
var syntax = parse("a.b");
var evaluate = compile(syntax);
var c = evaluate(new Scope({a: {b: 10}}));
expect(c).toBe(10);
```

The `evaluate` module returns a function that accepts a path or syntax tree, a source value, and parameters and returns the corresponding value.

```javascript
var evaluate = require("frb/evaluate");
var c = evaluate("a.b", {a: {b: 10}});
expect(c).toBe(10);
```

### Stringify

The `stringify` module returns a function that accepts a syntax tree and returns the corresponding path in normal form.

```javascript
var stringify = require("frb/stringify");
var syntax = {type: "and", args: [
    {type: "property", args: [ {type: "value"}, {type: "literal", value: "a"} ]},
    {type: "property", args: [ {type: "value"}, {type: "literal", value: "b"} ]}
]};
var path = stringify(syntax);
expect(path).toBe("a && b");
```

Source: [README.md](https://github.com/kriskowal/frb/blob/131db347355789cf2dbb79e49b10881d9716b449/README.md) at commit `131db347`.
