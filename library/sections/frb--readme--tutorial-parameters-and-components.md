---
title: Parameters, Elements and Components
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

> Abstract: How an FRB binding reaches values outside its source object. **Parameters** are a second source, addressed by a `$` prefix in the query language (`$a`, or bare `$` for the whole parameters object); the parameters object defaults to the source, which defaults to the target, and bindings react to parameter changes too. **Elements** are DOM nodes reached with a `#` prefix (`#fahrenheit.value`), resolved through a `document` supplied in the parameters; `frb/dom` is an experiment that monkey-patches DOM elements to make `value`/`checked` observable. **Components** are reached with an `@` prefix (`@fahrenheit.value`), resolved through a Montage `serialization` that implements `getObjectForLabel`. The `#` and `@` notations let one controller object bind views to models.

### Parameters

Bindings can also involve parameters. The source of parameters is by default the same as the source. The source, in turn, defaults to the same as the target object. It can be specified on the binding descriptor. Parameters are declared by any expression following a dollar sign.

```javascript
var object = {a: 10, b: 20, c: 30};
bind(object, "foo", {
    "<-": "[$a, $b, $c]"},
    parameters: object
});
```

Bindings also react to changes to the parameters.

```javascript
object.a = 0;
object.b = 1;
object.c = 2;
expect(object.foo).toEqual([0, 1, 2]);
```

The degenerate case of the property language is an empty string. This is a valid property path that observes the value itself. So, as an emergent pattern, a `$` expression by itself corresponds to the whole parameters object.

```javascript
var object = {};
bind(object, "ten", {"<-": "$", parameters: 10});
expect(object.ten).toEqual(10);
```

### Elements and Components

FRB provides a `#` notation for reaching into the DOM for an element. This is handy for binding views and models on a controller object.

The `defineBindings` method accepts an optional final argument, `parameters`, which is shared by all bindings (unless shadowed by a more specific parameters object on an individual descriptor). The `parameters` can include a `document`, which may be any object that implements `getElementById`.

Additionally, the `frb/dom` is an experiment that monkey-patches the DOM to make some properties of DOM elements observable, like the `value` or `checked` attribute of an `input` or `textarea` element.

```javascript
var Bindings = require("frb");
require("frb/dom");

var controller = Bindings.defineBindings({}, {
    "fahrenheit": {"<->": "celsius * 1.8 + 32"},
    "celsius": {"<->": "kelvin - 272.15"},
    "#fahrenheit.value": {"<->": "+fahrenheit"},
    "#celsius.value": {"<->": "+celsius"},
    "#kelvin.value": {"<->": "+kelvin"}
}, {
    document: document
});

controller.celsius = 0;
```

One caveat of this approach is that it can cause a lot of DOM repaint and reflow events. The Montage framework uses a synchronized draw cycle and a component object model to minimize the cost of computing CSS properties on the DOM and performing repaints and reflows, deferring such operations to individual animation frames.

For a future release of Montage, FRB provides an alternate notation for reaching into the component object model, using its deserializer. The `@` prefix refers to another component by its label. Instead of providing a `document`, Montage provides a `serialization`, which in turn implements `getObjectForLabel`.

```javascript
var controller = Bindings.defineBindings({}, {
    "fahrenheit": {"<->": "celsius * 1.8 + 32"},
    "celsius": {"<->": "kelvin - 272.15"},
    "@fahrenheit.value": {"<->": "+fahrenheit"},
    "@celsius.value": {"<->": "+celsius"},
    "@kelvin.value": {"<->": "+kelvin"}
}, {
    serializer: serializer
});

controller.celsius = 0;
```

Source: [README.md](https://github.com/kriskowal/frb/blob/131db347355789cf2dbb79e49b10881d9716b449/README.md) at commit `131db347`.
