---
title: Structural tags — repeat.html, reveal.html, choose.html
source: README.md
source_repo: gutentags/gutentag
source_commit: 38cdebb355f9c09ffbc9b0dcc8bb13a9421dfc88
source_date: 2017-03-07
source_authors: [Kris Kowal]
ingested: 2026-07-06
ingested_by: scholar
topics: [html-modules]
status: current
---

Abstract: The three structural building blocks, each of which creates a child scope on demand and reacts to changes in its `value`. `repeat.html` repeats its content once per entry of a `value` array, exposing each iteration as an `<id>:iteration` component with `index` and `value`, creating and destroying iterations as the array changes. `reveal.html` instantiates its inner content in a `<id>:revelation` scope whenever `value` is truthy and removes it when falsy. `choose.html` reveals one of several named child options based on `value`, constructing the chosen child on demand in a fresh `<id>:<value>` scope named from the component id and the current value.

### repeat.html

Repeats its content based on the values in the given `value` array.

```html
<!doctype html>
<html>
    <head>
        <link rel="extends" href="./list">
        <link rel="tag" href="gutentag/repeat.html">
        <link rel="tag" href="gutentag/text.html">
    </head>
    <body>
        <ul><repeat id="items">
            <li id="item" type="a"><text id="text"></text></li>
        </repeat></ul>
    </body>
</html>
```

The repetition creates a scope for each of its iterations. In that scope, the
iteration object is accessible by a name constructed from the id of the
iteration, plus ":iteration". The iteration object has an `index` and a `value`
property.

```js
'use strict';
module.exports = List;
function List() {}
List.prototype.hookup = function hookup(id, component, scope) {
    var components = scope.components;
    if (id === "items:iteration") {
        components.text.value = component.value;
    }
};
```

The repetition creates new iterations on demand and reacts to changes to the
given values array. Take a peek at `essays/repeat`.

### reveal.html

Reveals its content based on whether `value` is truthy.

```html
<!doctype html>
<html>
    <head>
        <link rel="extends" href="./blink">
        <link rel="tag" href="gutentag/reveal.html">
        <meta accepts="[body]" as="argument">
    </head>
    <body>
        <reveal id="content"><argument></argument></reveal>
    </body>
</html>
```

```js
'use strict';
module.exports = Blink;
function Blink() {}
Blink.prototype.hookup = function hookup(id, component) {
    if (id === "content") {
        setInterval(function () {
            component.value = !component.value;
        }, 1000);
    }
}
```

A `<reveal id="content">` tag instantiates its inner content in a
`content:revelation` scope each time it reveals that content. Take a peek at
`essays/reveal`.

### choose.html

Reveals one of its options, as expressed by named child tags, based on its
`value`. Constructs the children on demand.

```html
<!doctype html>
<html>
    <head>
        <link rel="extends" href="./essay">
        <link rel="tag" href="../../choose.html">
        <link rel="tag" href="../../repeat.html">
        <link rel="tag" href="../../text.html">
    </head>
    <body>
        <repeat id="buttons">
            <button id="button">
                <text id="buttonLabel">—</text>
            </button>
        </repeat>
        <choose id="options">
            <a>Police</a>
            <b>Officer</b>
            <c>Wolves</c>
            <d>Old Witch</d>
            <e>Going to Sleep</e>
        </choose>
    </body>
</html>
```

```js
choose.value = "e";
```

A `<choose id="options">` tag instantiates one of its choices in a fresh scope
each time its value changes. The name of that scope comes from the identifier of
the component and the given value, so the iteration would be called "options:e"
in this case. Take a peek at `essays/choose`.

Source: [README.md](https://github.com/gutentags/gutentag/blob/38cdebb355f9c09ffbc9b0dcc8bb13a9421dfc88/README.md) at commit `38cdebb`.
