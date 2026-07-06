---
title: HTML modules as component declarations and lexical scope
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

Abstract: A guten tag is an HTML/XML file that declares a component. Its `<head>` imports other tags (`<link rel="tag">`) and declares how it receives its argument (`<meta accepts>`) and what it exports; its `<body>` assembles the component from other components. Every instance of a component has its own lexical scope — a namespace mapping component identifiers to child components, with an optional parent scope and argument scope. Structural tags like `<repeat>` introduce child scopes, and an argument passed into a tag is evaluated in the *caller's* lexical scope even though it is instantiated inside the callee, matching function-like lexical semantics.

In this example, `list.html` declares a list component. It accepts the entire
argument fragment as a single component constructor, indicated by
`accepts="[body]"`. Guten Tag's calling convention arranges for the fragment
between `<list>` and `</list>` to become a component bound to the `<argument>`
tag in the scope of `list.html`. The list can instantiate that component in any
number of locations any number of times.

```html
<!-- list.html -->
<html>
    <head>
        <link rel="tag" href="gutentag/repeat.html">
        <meta accepts="[body]" as="argument">
        <meta exports="items:iteration" as="item">
    </head>
    <body>
        <ul><repeat id="items">
            <li id="item" type="a"><argument id="argument"></argument></li>
        </repeat></ul>
    </body>
</html>
```

Every instance of that component has its own lexical scope. Each scope is a name
space mapping component identifiers to child components and may have a parent
scope and an argument scope. Each tag exists in a scope and some tags, like the
repeat tag, may introduce child scopes. If a tag instantiates its argument, the
arguments are instantiated in their own lexical scope.

```html
<!-- main.html -->
<html>
    <head>
        <link rel="tag" href="./list.html">
        <link rel="tag" href="gutentags/text.html">
    </head>
    <body>
        <list id="list">
            <text id="item"></text>
        </list>
    </body>
</html>
```

Creating a list component passes the text component as an argument. Even though
that argument is instantiated in the `list.html` module, it is evaluated in the
scope of the `main.html` module, the module in which it is declared: its lexical
scope.

The `gutentag/repeat.html` module can create a nested scope for its argument
components. Each such scope gets introduced to `list.html` as an iteration
component with the identifier `items:iteration`, which can be addressed to bind
its `value` or `index`. Because `list.html` uses `<repeat>` around an
`<argument>` tag, it inherits this ability to introduce scopes. By exporting
`items:iteration` as `item`, the `<list>` tag in `main.html` introduces a
`list:item` component in the scope of the text item, with which you can again
bind the `value` or `index`.

With some additional JavaScript (or a binding declaration) to bind the value of
the list to an array and to bind that array to the inner component's repetition,
this component would drive an actual document with a lettered list,
incrementally updating in response to values added and removed from its model.
Guten Tag also supports several other calling conventions, allowing you to pass
multiple argument constructors, raw HTML, raw text, and attributes; components
can also introduce multiple nested scopes for multi-dimensional data.

Source: [README.md](https://github.com/gutentags/gutentag/blob/38cdebb355f9c09ffbc9b0dcc8bb13a9421dfc88/README.md) at commit `38cdebb`.
