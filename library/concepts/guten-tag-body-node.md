---
id: guten-tag-body-node
aliases: [body node, guten tag body, koerper, Koerper, virtual document, actualNode, container-free fragment, no wrapper element, "<sp>", significant whitespace guten tag]
topics: [html-modules, web-frontend]
---

# guten-tag-body-node

A **body node** is the special virtual-document node handed to a Guten Tag
component as its `body`. It represents a point in the actual document that the
component governs and can be added to or removed from the virtual document,
synchronously adding or removing all of its content from the actual document —
but it introduces **no container element** (no wrapping `<div>`). That
container-free property is what lets the structural tags (`<repeat>`,
`<reveal>`, `<choose>`) sit inline, inside a `<table>`, under CSS flex/selector
constraints, or in semantic markup where a wrapper would interfere. Body nodes,
and the virtual document that hosts them (every node has an `actualNode` and
proxies common DOM methods — innerHTML, innerText, get/set/has/removeAttribute),
are provided by the **Koerper** module. Related: whitespace is insignificant by
default, and the built-in `<sp>` tag marks regions where space is preserved.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [gutentag--readme--body-nodes-and-no-wrapper-element](../sections/gutentag--readme--body-nodes-and-no-wrapper-element.md) | Body nodes govern a fragment without a wrapper element; inline/table/CSS use cases. |
| [gutentag--readme--virtual-document-koerper](../sections/gutentag--readme--virtual-document-koerper.md) | The virtual document (actualNode, proxied DOM methods) provided by Koerper. |

## See also

- [[guten-tag-component]] — a component is constructed with a `body` node.
- [[guten-tag-scope]] — the other half of the constructor pair (`caller`).
