---
title: On-the-fly translation and the provided tags
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

Abstract: A guten tag translates to JavaScript on-the-fly in the browser during development, or in Node.js as a build step; the markup imports other tags with `<link rel="tag">` and can extend a JavaScript implementation with `<link rel="extends">`. Guten Tag itself provides only five building-block tags — `<text>`, `<html>`, `<repeat>`, `<reveal>`, `<choose>` — plus the system for loading tags; everything else (bindings, shims, data, animation, a virtual document) is bring-your-own. The framework is deliberately minimal: the "Guten Tag, Welt!" application is about 15K, and 3K after uglify and gzip.

A guten tag is an HTML or XML file that defines a template for instantiating a
combination of JavaScript components and DOM elements. Guten tags export a
component constructor and can import other component constructors, binding them
to tag names in the scope of a document. The markup translates to JavaScript,
on-the-fly in the browser during development, or in Node.js as a build step.

```html
<head>
    <link rel="extends" href="./list">
    <link rel="tag" href="gutentag/repeat.html">
    <link rel="tag" href="gutentag/text.html">
</head>
```

Guten tags have a lexical scope for component and element identifiers, and can
introduce components into caller scopes under the identifier of the caller. In
this example, there is a repetition with an id of "items" that introduces
"items:iteration" in the iteration scopes from the body of the repetition.

```html
<ul><repeat id="items">
    <li id="item" type="a"><text id="text"></text></li>
</repeat></ul>
```

Guten tag only provides the `<text>`, `<html>`, `<repeat>`, `<reveal>`, and
`<choose>` tags and the system for loading tags. Bring your own bindings, shims,
data, animation, or virtual document if you need them. The "Guten Tag, Welt!"
application is about 15K and 3K after uglify and gzip.

A tag is defined in HTML or XML and can import tags from other HTML modules.
This `list.html` tag produces a list at whatever point in a document you
incorporate it. An instance of a tag is a component.

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

Source: [README.md](https://github.com/gutentags/gutentag/blob/38cdebb355f9c09ffbc9b0dcc8bb13a9421dfc88/README.md) at commit `38cdebb`.
