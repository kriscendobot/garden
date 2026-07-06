---
title: Body nodes and the no-wrapper-element property
source: README.md
source_repo: gutentags/gutentag
source_commit: 38cdebb355f9c09ffbc9b0dcc8bb13a9421dfc88
source_date: 2017-03-07
source_authors: [Kris Kowal]
ingested: 2026-07-06
ingested_by: scholar
topics: [html-modules, web-frontend]
status: current
---

Abstract: The `body` handed to a component constructor is a special node in a virtual document representing a point in the actual document that the tag governs. A body can be added to or removed from the virtual document, synchronously adding or removing all of its content from the actual document — but it does *not* introduce a container element like a `<div>`. This container-free property is what makes the structural tags (`<repeat>`, `<reveal>`, `<choose>`) usable inline, inside a `<table>`, under CSS flex/selector constraints, or in semantic markup where a wrapper element would interfere.

The `body` is a special kind of node in a virtual document. It represents a
point in the actual document that the given tag will control. Bodies can be
added and removed from the virtual document, and all of their content will be
(synchronously) added or removed from the actual document. However, bodies do
not introduce a container element, like a `<div>`. This is critical for the
Guten Tag structural tags, `<repeat>`, `<reveal>`, and `<choose>`, since you may
or may not need a container element around them or inside them, and you may want
one or more of these inline.

```html
<table>
    <tr>
        <th><!-- corner --></th>
        <th id="groupOneHeader" colspan=""></th>
        <th id="groupTwoHeader" colspan=""></th>
    </tr>
    <tr>
        <th><text id="rowHeader"></text></th>
        <repeat id="groupOne">
            <td><text id="cell"></text></td>
        </repeat>
        <repeat id="groupTwo">
            <td><text id="cell"></text></td>
        </repeat>
    </tr>
</table>
```

In other cases, having a wrapper element would interfere with CSS selectors,
particularly for the flex model, or would interfere with semantic markup.

```html
<repeat id="stanzas"><p class="stanza">
    <repeat id="lines">
        <text id="line"></text>
        <reveal id="medial"><br></reveal>
    </repeat>
</p></repeat>
```

Sometimes it is useful to compose text without container elements at all.

```html
<sp><text id="hello">, <text id="person">!</sp>
```

Source: [README.md](https://github.com/gutentags/gutentag/blob/38cdebb355f9c09ffbc9b0dcc8bb13a9421dfc88/README.md) at commit `38cdebb`.
