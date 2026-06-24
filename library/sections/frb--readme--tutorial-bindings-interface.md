---
title: Bindings and Binding Descriptors
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

> Abstract: The `frb` (`frb/bindings`) module is the declarative top-level interface for managing many bindings on an object. It exports `defineBindings`/`cancelBindings` and `defineBinding`/`cancelBinding`, plus inspector methods `getBindings`/`getBinding`, all taking a target object first. `defineBindings` returns the target for convenience. A descriptor whose key is `<-` or `<->` is a **binding descriptor**: FRB creates the binding, annotates the descriptor with a `cancel` function and default values for omitted fields (`source` defaults to `target`, `parameters` to `source`), and records it in an internal per-object table. Non-binding descriptors fall back to `compute` (computed properties) or to defining a permissive ES5 property. Target paths may themselves be expressions like `document.body.classList.has('dark')`, so a binding can drive into a collection method rather than a plain property. This section soft-overlaps the Reference-section `frb--readme--reference-programmatic-api` (reference-shape) with the same API at tutorial shape.

### Bindings

FRB provides utilities for declaring and managing multiple bindings on objects. The `frb` (`frb/bindings`) module exports this interface.

```javascript
var Bindings = require("frb");
```

The `Bindings` module provides `defineBindings` and `cancelBindings`, `defineBinding` and `cancelBinding`, as well as binding inspector methods `getBindings` and `getBinding`. All of these take a target object as the first argument. The `Bindings.defineBindings(target, descriptors)` method returns the target object for convenience.

```javascript
var target = Bindings.defineBindings({}, {
    "fahrenheit": {"<->": "celsius * 1.8 + 32"},
    "celsius": {"<->": "kelvin - 272.15"}
});
target.celsius = 0;
expect(target.fahrenheit).toEqual(32);
expect(target.kelvin).toEqual(272.15);
```

`Bindings.getBindings` in that case would return an object with `fahrenheit` and `celsius` keys. The values would be identical to the given binding descriptor objects, like `{"<->": "kelvin - 272.15"}`, but each also gets annotated with a `cancel` function and the default values for any omitted properties like `source` (same as `target`), `parameters` (same as `source`), and others.

`Bindings.cancelBindings` cancels all bindings attached to an object and removes them from the bindings descriptors object.

```javascript
Bindings.cancelBindings(target);
expect(Bindings.getBindings(object)).toEqual({});
```

### Binding Descriptors

Binding descriptors describe the source of a binding and additional parameters. `Bindings.defineBindings` can set up bindings (`<-` or `<->`), computed (`compute`) properties, and falls back to defining ES5 properties with permissive defaults (`enumerable`, `writable`, and `configurable` all on by default).

If a descriptor has a `<-` or `<->`, it is a binding descriptor. FRB creates a binding, adds the canceler to the descriptor, and adds the descriptor to an internal table that tracks all of the bindings defined on that object.

```javascript
var object = Bindings.defineBindings({
    darkMode: false,
    document: document
}, {
    "document.body.classList.has('dark')": {
        "<-": "darkMode"
    }
});
```

You can get all the binding descriptors with `Bindings.getBindings`, or a single binding descriptor with `Bindings.getBinding`. `Bindings.cancel` cancels all the bindings to an object and `Bindings.cancelBinding` will cancel just one.

```javascript
// Continued from above...
var bindings = Bindings.getBindings(object);
var descriptor = Bindings.getBinding(object, "document.body.classList.has('dark')");
Bindings.cancelBinding(object, "document.body.classList.has('dark')");
Bindings.cancelBindings(object);
expect(Object.keys(bindings)).toEqual([]);
```

Source: [README.md](https://github.com/kriskowal/frb/blob/131db347355789cf2dbb79e49b10881d9716b449/README.md) at commit `131db347`.
