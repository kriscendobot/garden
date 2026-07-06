# Topic: html-modules

> Abstract: HTML/XML files as reactive component-declaration modules, as practiced by Kris Kowal's **Guten Tag** framework (`gutentags/gutentag`). A guten tag is an HTML module whose `<head>` imports other tags (`<link rel="tag">`), declares how it receives its argument (`<meta accepts="[body|entries|text|html]">`), and exports iterations; whose `<body>` assembles a component from other components and DOM elements; and which translates to JavaScript (on-the-fly in the browser or as a build step). A tag is an invocation of a web component and the fragment between start and end tags is its argument. Every instance has its own lexical scope (root/parent/this/components/caller/argument), the structural tags (`<repeat>`, `<reveal>`, `<choose>`) create child scopes on demand and react incrementally to `value` changes, and components govern container-free *body nodes* over a virtual document (Koerper). Seeded 2026-07-06 from the Guten Tag README. Distinct from `reactive-bindings` (kriskowal/frb — a synchronous binding *query language* over object properties and collections, not a component framework) and from `web-frontend` (cross-cutting browser/CSS technique); Guten Tag is the component-and-scope framework those techniques and bindings would plug into.

## Sections

| Section | Source | One-line abstract |
|---------|--------|-------------------|
| [gutentag--readme--overview](../sections/gutentag--readme--overview.md) | gutentag README | Guten Tag's thesis: a component is a function, a tag is its invocation, and the governed document fragment updates incrementally like a spreadsheet cell. |
| [gutentag--readme--html-modules-and-lexical-scope](../sections/gutentag--readme--html-modules-and-lexical-scope.md) | gutentag README | HTML/XML files declare components; each instance gets its own lexical scope; arguments evaluate in the caller's scope while instantiated in the callee. |
| [gutentag--readme--translation-and-provided-tags](../sections/gutentag--readme--translation-and-provided-tags.md) | gutentag README | Tags translate to JS on-the-fly or as a build step; the five provided tags plus bring-your-own; ~15K/3K-gzipped footprint. |
| [gutentag--readme--javascript-implementation-and-hookup](../sections/gutentag--readme--javascript-implementation-and-hookup.md) | gutentag README | The `hookup(id, child, scope)` convention where a sibling JS module wires reactive behavior; the compiled `Component(body, caller)` constructor. |
| [gutentag--readme--body-nodes-and-no-wrapper-element](../sections/gutentag--readme--body-nodes-and-no-wrapper-element.md) | gutentag README | Body nodes govern a document fragment without introducing a wrapper element, which is what makes the structural tags usable inline, in tables, and under CSS. |
| [gutentag--readme--scope-object-model](../sections/gutentag--readme--scope-object-model.md) | gutentag README | The scope object: root (DI container), parent, this, components map, caller, argument; child scopes inherit components prototypically. |
| [gutentag--readme--bootstrapping](../sections/gutentag--readme--bootstrapping.md) | gutentag README | Starting an app: npm package, System loader, Koerper, the extensions annotation, the index.html/index.js boilerplate, and the Bundle build step. |
| [gutentag--readme--building-block-tags-text-and-html](../sections/gutentag--readme--building-block-tags-text-and-html.md) | gutentag README | The value-controlling tags: text.html controls a text node from `value`; html.html controls an HTML block (linked as x-html since `html` is reserved). |
| [gutentag--readme--structural-tags-repeat-reveal-choose](../sections/gutentag--readme--structural-tags-repeat-reveal-choose.md) | gutentag README | The scope-creating tags: repeat over a value array, reveal on truthiness, choose among named options; each creates child scopes on demand and reacts to `value`. |
| [gutentag--readme--custom-tags-and-packaging](../sections/gutentag--readme--custom-tags-and-packaging.md) | gutentag README | The packaging convention: a single-tag package is named `<tag>.html` with `main: ./index.html`. |
| [gutentag--readme--argument-calling-conventions](../sections/gutentag--readme--argument-calling-conventions.md) | gutentag README | The four `<meta accepts>` conventions ([body]/[entries]/[text]/[html]) and how each packs `caller.argument`. |
| [gutentag--readme--arguments-and-scopes](../sections/gutentag--readme--arguments-and-scopes.md) | gutentag README | How repeat/reveal/choose child scopes cut through the caller so an instantiated argument surfaces as an `items:row`-style iteration. |
| [gutentag--readme--this-space-and-xml](../sections/gutentag--readme--this-space-and-xml.md) | gutentag README | Three facilities: `<this>` self-recursion for trees, `<sp>` for significant whitespace, and XML as an escape from HTML5 parser restrictions. |
| [gutentag--readme--virtual-document-koerper](../sections/gutentag--readme--virtual-document-koerper.md) | gutentag README | The virtual document: every node has an actualNode and proxies common DOM methods; body-node support comes from the Koerper module. |

## Concepts

- [[guten-tag-component]] — a component as an instance of an HTML-module tag; constructed with `(body, caller)`.
- [[guten-tag-scope]] — the per-instance lexical scope object and its references.
- [[guten-tag-accepts-convention]] — the `<meta accepts>` argument calling conventions.
- [[guten-tag-body-node]] — the container-free document-fragment node a component governs.

## See also

- [`reactive-bindings`](reactive-bindings.md): kriskowal/frb, a synchronous incremental binding query language — the kind of binding layer Guten Tag leaves as bring-your-own.
- [`web-frontend`](web-frontend.md): cross-cutting browser/CSS technique for the garden's web surfaces; Guten Tag is a component framework such techniques would live inside.
- [`node-packaging`](node-packaging.md): npm package layout and conventions; Guten Tag's `<tag>.html`/`index.html` packaging convention is an instance.
