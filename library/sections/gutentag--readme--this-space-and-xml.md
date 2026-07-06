---
title: This, Space, and XML — recursion, significant whitespace, and the XML escape hatch
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

Abstract: Three additional facilities. **This** — the `<this></this>` tag stands for the current component, giving components self-recursion, which is useful for trees. **Space** — unlike normal HTML, whitespace is insignificant by default (all-space text nodes are trimmed and discarded), and the built-in `<sp>` tag explicitly marks regions where sequences of space are preserved. **XML** — Guten Tag supports XML for cases where the HTML5 parser gets in the way, most notably the HTML5 rule forbidding a `<repeat>` inside a `<table>`, which XML permits.

### This

Components support self recursion. This is useful for creating trees. The
``<this></this>`` tag stands for this component.

```html
<!doctype html>
<html>
    <head>
        <link rel="extends" href="./tree">
        <link rel="tag" href="../../text.html">
        <link rel="tag" href="../../repeat.html">
        <meta accepts="[body]">
    </head>
    <body>
        <argument></argument>
        <ul>
            <repeat id="children">
                <li><this id="child"><argument></argument></this></li>
            </repeat>
        </ul>
    </body>
</html>
```

### Space

Unlike normal HTML, by default, white space is treated as insignificant. All
text nodes are trimmed and thrown away if they only contain spaces. However,
there is a built in ``<sp>`` tag that explicitly marks parts of the document
where white space is significant. In these regions, sequences of space are
preserved. In the following example, the string "Guten Tag, Welt!" is repeated
for every value of the greetings iteration. The ``<sp>`` tag ensures that these
greetings are delimited by space.

```html
<!doctype html>
<html>
    <head>
        <link rel="tag" href="../../repeat.html">
    </head>
    <body>
        <repeat id="greetings"><sp>Guten Tag, Welt! </sp></repeat>
    </body>
</html>
```

### XML

Guten Tag supports XML for cases where the HTML5 parser gets in your way. For
example, the HTML5 parser does not allow a ``<repeat>`` tag to exist within a
``<table>``. XML does.

```xml
<html>
    <head>
        <link rel="extends" href="./grid"/>
        <link rel="tag" href="gutentag/repeat.html"/>
        <link rel="tag" href="gutentag/text.html"/>
    </head>
    <body>
        <table>
            <thead>
                <tr id="columnRow">
                    <th></th>
                    <repeat id="columns">
                        <th><text id="ch"/></th>
                    </repeat>
                </tr>
            </thead>
            <tbody>
                <repeat id="rows">
                    <th><text id="rh"/></th>
                    <repeat id="cells">
                        <td><text id="cd"/></td>
                    </repeat>
                </repeat>
            </tbody>
        </table>
    </body>
</html>
```

Source: [README.md](https://github.com/gutentags/gutentag/blob/38cdebb355f9c09ffbc9b0dcc8bb13a9421dfc88/README.md) at commit `38cdebb`.
