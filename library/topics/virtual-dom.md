# Topic: virtual-dom

> Abstract: The light-weight virtual-DOM substrate beneath Kris Kowal's **Guten Tag** framework: **Wizdom** (`gutentags/wizdom`), a very small mutable subset of the DOM (element/text/comment nodes with parent/child/sibling links and an attribute NamedNodeMap, plus a parse5-driven parser and inner-text/inner-html/outer-html serializers), and **Koerper** (`gutentags/koerper`), which builds on Wizdom to add a first-class "body" node type that encapsulates a region of a document *without* a container element and proxies attributes and event listeners through the actual document. Body nodes are what let Guten Tag farm portions of the real document out to components — the enabling substrate behind html-modules' container-free `repeat`/`reveal` tags and flex-box-peer components. Seeded 2026-07-06 from the Koerper and Wizdom READMEs. Distinct from `html-modules` (the component-and-scope framework that *consumes* this DOM) and from `web-frontend` (cross-cutting browser/CSS technique).

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [koerper--readme--overview](../sections/koerper--readme--overview.md) | koerper README | Koerper: a virtual DOM on Wizdom adding a body node type that encapsulates a document region without a container element, so Guten Tag can farm the document out to components. |
| [koerper--readme--body-node-api](../sections/koerper--readme--body-node-api.md) | koerper README | The body-node API: `new Document(actualElement)`, `createBody()`, arbitrarily-nested bodies, and container-free text interpolation and insert/remove within another body. |
| [wizdom--readme--overview](../sections/wizdom--readme--overview.md) | wizdom README | Wizdom: a minimal mutable DOM subset (element/text/comment nodes, parent/child/sibling links, attribute NamedNodeMap) that does nothing to protect its integrity, for the sake of simplicity. |
| [wizdom--readme--parsing-and-stringifying](../sections/wizdom--readme--parsing-and-stringifying.md) | wizdom README | Building Wizdom documents from HTML text via a parse5 driver (`wizdom/parse5`) and serializing them back via inner-text/inner-html/outer-html. |

## Concepts

- [[guten-tag-body-node]] — the container-free document-fragment node a Guten Tag component governs; Koerper is its implementation.

## See also

- [`html-modules`](html-modules.md): the Guten Tag component-and-scope framework that governs its content through Koerper's body nodes.
- [`module-loader`](module-loader.md): `gutentags/system`, the loader that translates Guten Tag's HTML modules to JavaScript.
- [`web-frontend`](web-frontend.md): cross-cutting browser/CSS technique; distinct from this virtual-DOM infrastructure.
