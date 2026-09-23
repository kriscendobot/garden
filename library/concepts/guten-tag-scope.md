---
id: guten-tag-scope
aliases: [guten tag scope, scope.root, scope.parent, scope.this, scope.components, scope.caller, scope.argument, lexical scope guten tag, "items:iteration", nestComponents]
topics: [html-modules]
---

# guten-tag-scope

Every Guten Tag component instance has its own **lexical scope** — a namespace
mapping component identifiers to child components. The scope object inherits
along a prototype chain up to the root scope and exposes: `scope.root` (the root
scope, an ideal dependency-injection container, reachable from any descendant),
`scope.parent` (the immediate parent scope), `scope.this` (the component
instantiated by the containing tag document), `scope.components` (the identifier
→ component-instance map), `scope.caller` (the lexical scope of the tag that
instantiated this component), and `scope.argument` (a template for the
instantiating tag's inner content). The structural tags (`<repeat>`, `<reveal>`,
`<choose>`) create child scopes whose `scope.components` inherits prototypically
from `scope.parent.components`, and name their iterations from the component id
(`items:iteration`, `options:e`, an exported `items:row`). Arguments are
evaluated in the caller's scope even when instantiated inside the callee.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [gutentag--readme--scope-object-model](../sections/gutentag--readme--scope-object-model.md) | root/parent/this/components/caller/argument and prototypical component inheritance. |
| [gutentag--readme--html-modules-and-lexical-scope](../sections/gutentag--readme--html-modules-and-lexical-scope.md) | Per-instance lexical scopes; arguments evaluate in the caller's scope. |
| [gutentag--readme--arguments-and-scopes](../sections/gutentag--readme--arguments-and-scopes.md) | How structural child scopes cut through the caller to name an iteration. |

## See also

- [[guten-tag-component]] — the instance a scope belongs to.
- [[guten-tag-accepts-convention]] — how `scope.argument` is populated.
