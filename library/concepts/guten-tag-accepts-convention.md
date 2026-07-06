---
id: guten-tag-accepts-convention
aliases: [meta accepts, "accepts=[body]", "accepts=[entries]", "accepts=[text]", "accepts=[html]", caller.argument, caller.argument.component, caller.argument.children, caller.argument.innerText, caller.argument.innerHTML, guten tag calling convention, argument tag]
topics: [html-modules]
---

# guten-tag-accepts-convention

A Guten Tag tag declares how it receives the fragment between its start and end
tags with a `<meta accepts="...">` header, and reads that content off
`caller.argument`. The four conventions:

- `[body]` — the whole fragment as a component constructor
  (`caller.argument.component`); instantiable in HTML tag definitions as the
  `<argument>` tag.
- `[entries]` — each child node as a named argument component
  (`caller.argument.children`, a name → constructor map).
- `[text]` — the fragment's innerText (`caller.argument.innerText`).
- `[html]` — the fragment's innerHTML (`caller.argument.innerHTML`).

The `caller.argument` object also carries a `tagName`; attribute and DOM-pattern
matching are noted as future work. This is Guten Tag's analogue of a function's
parameter-passing calling convention.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [gutentag--readme--argument-calling-conventions](../sections/gutentag--readme--argument-calling-conventions.md) | The four accepts conventions and how each packs `caller.argument`. |
| [gutentag--readme--scope-object-model](../sections/gutentag--readme--scope-object-model.md) | `<meta accepts>` packs `caller.argument`; per-tag examples (text/repeat/choose). |
| [gutentag--readme--arguments-and-scopes](../sections/gutentag--readme--arguments-and-scopes.md) | `accepts="[body]"` arguments instantiated inside a structural child scope. |

## See also

- [[guten-tag-scope]] — `caller.argument` lives on the scope object.
- [[guten-tag-component]] — the component that receives the argument.
