---
title: The argument calling conventions (meta accepts)
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

Abstract: A tag declares how it receives the content between its start and end tags with a `<meta accepts="...">` header, and reads that content off `caller.argument`. The four conventions: `[body]` packs the whole fragment as a component constructor, read via `caller.argument.component` and instantiable in HTML as `<argument>`; `[entries]` packs each child node as a named argument component, read via `caller.argument.children` (a name → constructor map); `[text]` packs the fragment's innerText, read via `caller.argument.innerText`; `[html]` packs the innerHTML, read via `caller.argument.innerHTML`. The `caller.argument` object also carries a `tagName`, with attribute and DOM-pattern matching noted as future work.

Invoking a tag in another tag may use the content between the start and end tag
in various ways to pass an argument into the called tag. Tags must express how
they receive their argument.

-   ``<meta accepts="[body]">`` receive the entire argument as a component. The
    argument is instantiable in HTML tag definitions as the ``<argument>`` tag.
    Use `caller.argument.component`, which is a component constructor.

-   ``<meta accepts="[entries]">`` receive each of the child nodes as a named
    argument component. The component constructor will receive an object with
    named properties for each component. Use `caller.argument.children`, which
    is an object mapping the name of the child tag to a component constructor.

-   ``<meta accepts="[text]">`` receives the entire argument as a string from its
    `innerText`. Use `caller.argument.innerText` to access the caller template's
    inner text.

-   ``<meta accepts="[html]">`` receives the entire argument as a string from its
    `innerHTML`. Use `caller.argument.innerHTML` to access the caller template's
    inner HTML.

For example, this tag parenthesizes its argument.

```html
<!doctype html>
<html>
    <head>
        <meta accepts="[body]">
    </head>
    <body>(<argument></argument>)</body>
</html>
```

The `caller.argument` object will also have a `tagName`. In a future version, it
may also support attributes and a language for matching other DOM patterns.

Source: [README.md](https://github.com/gutentags/gutentag/blob/38cdebb355f9c09ffbc9b0dcc8bb13a9421dfc88/README.md) at commit `38cdebb`.
