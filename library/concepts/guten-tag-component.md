---
id: guten-tag-component
aliases: [guten tag component, guten tag, gutentag, Guten Tag, component constructor body caller, hookup, "hookup(id, child, scope)"]
topics: [html-modules]
---

# guten-tag-component

In Kris Kowal's Guten Tag framework, a **component** is an instance of a tag —
where a tag is an HTML/XML module declaring how to assemble the component from
other components and DOM elements. Compiled, a tag module exports a
`Component(body, caller)` constructor: `body` is the virtual-document point the
component governs (a container-free body node) and `caller` is the lexical scope
from which the tag was instantiated. A sibling JavaScript module can supply a
`hookup(id, child, scope)` method that the framework calls as each child is
added to the scope; `hookup` is where reactive wiring lives (copying an
iteration's value into a text component, capturing `this`, and so on). Trivial
tags need no JavaScript at all.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [gutentag--readme--overview](../sections/gutentag--readme--overview.md) | A component is a function; a tag is its invocation. |
| [gutentag--readme--javascript-implementation-and-hookup](../sections/gutentag--readme--javascript-implementation-and-hookup.md) | The hookup convention and the compiled `Component(body, caller)` constructor. |
| [gutentag--readme--html-modules-and-lexical-scope](../sections/gutentag--readme--html-modules-and-lexical-scope.md) | HTML modules declare components; each instance gets its own scope. |

## See also

- [[guten-tag-scope]] — the `caller`/scope object a component is constructed against.
- [[guten-tag-body-node]] — the `body` a component governs.
- [[guten-tag-accepts-convention]] — how a component receives its argument.
