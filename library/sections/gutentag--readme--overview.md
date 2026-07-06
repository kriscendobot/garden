---
title: Overview — components as functions, tags as invocations
source: README.md
source_repo: gutentags/gutentag
source_commit: 38cdebb355f9c09ffbc9b0dcc8bb13a9421dfc88
source_date: 2017-03-07
source_authors: [Kris Kowal]
ingested: 2026-07-06
ingested_by: scholar
topics: [html-modules, reactive-bindings]
status: current
---

Abstract: Guten Tag's thesis — an HTML component should be as simple and powerful as a function, a tag is an invocation of a web component, and the fragment between a start and end tag is that invocation's argument. The result is a component tree governing a fragment of a document, and — like a cell in a spreadsheet that re-evaluates when one of its dependencies changes — that fragment adapts *incrementally* to changes in the bound data rather than re-rendering wholesale.

HTML components should be as simple and as powerful as functions:

```js
greet(subject("Guten Tag"), ", ", object("Welt"), "!")
```

A tag is an invocation of a web component and the fragment between the start
and end tag is its argument.

```html
<greet>
    <subject>Guten Tag</subject>,
    <object>Welt</object>!
</greet>
```

The result is a component tree that governs a fragment of a document. However,
components must also be reactive, adapting their output to changes to their
input. So, like a cell in a spreadsheet, as its value gets incrementally
re-evaluated whenever one of its dependent variables changes, the fragment of
the document it governs adapts *incrementally* to changes to the bound data.

Furthermore, an HTML module is a component declaration. Like a function
declaration, it describes how it will receive its arguments and how to assemble
the resulting component from other, constituent components. Like a module, it
describes the tags it depends upon to assemble its own body.

Source: [README.md](https://github.com/gutentags/gutentag/blob/38cdebb355f9c09ffbc9b0dcc8bb13a9421dfc88/README.md) at commit `38cdebb`.
