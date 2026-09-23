---
title: Arguments and scopes — how structural child scopes cut through the caller
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

Abstract: The building blocks `<repeat>`, `<reveal>`, and `<choose>` create a child scope for the components they instantiate, which has consequences for arguments instantiated inside that scope. When a `<list>` tag contains a `<repeat>` around an `<argument>`, the repetition cuts through the transitive caller scopes to create a new scope for the instantiated argument. The resulting iteration is named from the caller's id and the list's exported name — a `<list id="items">` whose `list.html` exports `rows:iteration as row` yields an `items:row` iteration in the caller's scope, whose value the caller can bind.

The building block components, `<repeat>`, `<reveal>`, and `<choose>` all create
a child scope for the components instantiated by their inner template. This has
interesting implications for arguments instantiated within that scope. Consider
a `<list>` tag that contains a repetition and accepts an argument component for
each row.

```html
<!doctype html>
<html>
    <head>
        <link rel="extends" href="./list">
        <link rel="tag" href="gutentag/repeat.html">
        <meta accepts="[body]" as="row">
        <meta exports="rows:iteration" as="row">
    </head>
    <body>
        <ul><repeat id="rows">
            <li><row></row></li>
        </repeat></ul>
    </body>
</html>
```

Another component instantiates the list with a text component in each row.

```html
<!doctype html>
<html>
    <head>
        <link rel="extends" href="./essay">
        <link rel="tag" href="gutentag/text.html">
        <link rel="tag" href="./list.html">
    </head>
    <body>
        <list id="items">
            <text id="item"></text>
        </list>
    </body>
</html>
```

In the list component, each row is known as "rows:iteration". However, the
repetition also cuts through the transitive caller scopes creating a new scope
for instantiated arguments. In this case, the list component creates an
"items:row" iteration based on the name of the caller ("items") and the name
exported by the list ("rows:iteration" gets exported as "row").

Thus, from within this essay, we observe the instantiation of "items:row" and
can see the value of the iteration.

```js
module.exports = Essay;
function Essay() {}
Essay.prototype.hookup = function hookup(id, child, scope) {
    var components = scope.components;
    if (id === "items:row") {
        components.item.value = child.value;
    } else if (id === "this") {
        components.items.value = ["Guten Tag, Welt!", "Auf Widerseh'n, Welt!"];
    }
};
```

Source: [README.md](https://github.com/gutentags/gutentag/blob/38cdebb355f9c09ffbc9b0dcc8bb13a9421dfc88/README.md) at commit `38cdebb`.
