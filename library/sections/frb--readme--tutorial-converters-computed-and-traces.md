---
title: Converters, Computed Properties, Debugging with Traces
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

> Abstract: Three escape hatches for transformations the query language cannot express. A **converter** is a `convert`/`revert` pair (or a `converter` object carrying those methods, useful for reusable, stateful converters) on a binding descriptor: `convert` maps source to target, `revert` maps target back for two-way bindings. A `reverter` slot uses a converter with `convert` and `revert` swapped, for when the binding's types run the other way. A **computed property** declares `args` (an array of source paths) and a `compute` function; the property re-runs the function whenever any argument changes, can take multiple inputs (unlike a converter), and can itself be the source of another binding. **Debugging with traces**: setting `trace: true` on a descriptor instructs the binder to log to the console when the binding changes and why.

### Converters

A binding descriptor can have a `convert` function, a `revert` function, or alternately a `converter` object. Converters are useful for transformations that cannot be expressed in the property language, or are not reversible in the property language.

In this example, `a` and `b` are synchronized such that `a` is always half of `b`, regardless of which property gets updated.

```javascript
var object = Bindings.defineBindings({
    a: 10
}, {
    b: {
        "<->": "a",
        convert: function (a) { return a * 2; },
        revert: function (b) { return b / 2; }
    }
});
expect(object.b).toEqual(20);

object.b = 10;
expect(object.a).toEqual(5);
```

Converter objects are useful for reusable or modular converter types and converters that track additional state.

```javascript
function Multiplier(factor) { this.factor = factor; }
Multiplier.prototype.convert = function (value) { return value * this.factor; };
Multiplier.prototype.revert = function (value) { return value / this.factor; };

var doubler = new Multiplier(2);
var object = Bindings.defineBindings({ a: 10 }, {
    b: { "<->": "a", converter: doubler }
});
expect(object.b).toEqual(20);

object.b = 10;
expect(object.a).toEqual(5);
```

Reusable converters have an implied direction, from some source type to a particular target type. Sometimes the types on your binding are the other way around. For that case, you can use the converter as a reverter. This merely swaps the `convert` and `revert` methods.

```javascript
var uriConverter = { convert: encodeURI, revert: decodeURI };
var model = Bindings.defineBindings({}, {
    "title": { "<->": "location", reverter: uriConverter }
});

model.title = "Hello, World!";
expect(model.location).toEqual("Hello,%20World!");

model.location = "Hello,%20Dave.";
expect(model.title).toEqual("Hello, Dave.");
```

### Computed Properties

A computed property is one that gets updated with a function call when one of its arguments changes. Like a converter, it is useful in cases where a transformation or computation cannot be expressed in the property language, but can additionally accept multiple arguments as input. A computed property can be used as the source for another binding.

In this example, we create an object as the root of multiple bindings. The object synchronizes the properties of a "form" object with the window's search string, effectively navigating to a new page whenever the "q" or "charset" values of the form change.

```javascript
Bindings.defineBindings({
    window: window,
    form: { q: "", charset: "utf-8" }
}, {
    queryString: {
        args: ["form.q", "form.charset"],
        compute: function (q, charset) {
            return "?" + QS.stringify({ q: q, charset: charset });
        }
    },
    "window.location.search": { "<-": "queryString" }
});
```

### Debugging with Traces

A binding can be configured to log when it changes and why. The `trace` property on a descriptor instructs the binder to log changes to the console.

```javascript
Bindings.defineBindings({
    a: 10
}, {
    b: { "<-": "a + 1" }
});
```

Source: [README.md](https://github.com/kriskowal/frb/blob/131db347355789cf2dbb79e49b10881d9716b449/README.md) at commit `131db347`.
