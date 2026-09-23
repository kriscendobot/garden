---
source: README.md
source_repo: gutentags/gutentag
source_commit: 38cdebb355f9c09ffbc9b0dcc8bb13a9421dfc88
source_date: 2017-03-07
source_authors: [Kris Kowal]
ingested: 2026-07-06
ingested_by: scholar
section_count: 14
status: current
---

The README of Guten Tag (`gutentags/gutentag`), Kris Kowal's framework for
defining HTML tags using HTML modules. It presents the core thesis — a component
is a function, a tag is its invocation, and the fragment between start and end
tags is its argument — then develops the model: HTML/XML files as
component-declaration modules that translate to JavaScript, per-instance lexical
scopes, a `hookup`-based JavaScript implementation convention, container-free
body nodes over a virtual document (Koerper), the scope object model
(root/parent/this/components/caller/argument), bootstrapping over the System
loader, the five building-block tags (`text`, `html`, `repeat`, `reveal`,
`choose`), the `<meta accepts>` argument calling conventions, and additional
facilities (self-recursion via `<this>`, significant whitespace via `<sp>`, and
an XML escape hatch). The document is the canonical conceptual introduction to
the Guten Tag component model.

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/gutentag--readme--overview.md) | html-modules, reactive-bindings | current |
| [html-modules-and-lexical-scope](../sections/gutentag--readme--html-modules-and-lexical-scope.md) | html-modules | current |
| [translation-and-provided-tags](../sections/gutentag--readme--translation-and-provided-tags.md) | html-modules | current |
| [javascript-implementation-and-hookup](../sections/gutentag--readme--javascript-implementation-and-hookup.md) | html-modules | current |
| [body-nodes-and-no-wrapper-element](../sections/gutentag--readme--body-nodes-and-no-wrapper-element.md) | html-modules, web-frontend | current |
| [scope-object-model](../sections/gutentag--readme--scope-object-model.md) | html-modules | current |
| [bootstrapping](../sections/gutentag--readme--bootstrapping.md) | html-modules, getting-started | current |
| [building-block-tags-text-and-html](../sections/gutentag--readme--building-block-tags-text-and-html.md) | html-modules | current |
| [structural-tags-repeat-reveal-choose](../sections/gutentag--readme--structural-tags-repeat-reveal-choose.md) | html-modules | current |
| [custom-tags-and-packaging](../sections/gutentag--readme--custom-tags-and-packaging.md) | html-modules, node-packaging | current |
| [argument-calling-conventions](../sections/gutentag--readme--argument-calling-conventions.md) | html-modules | current |
| [arguments-and-scopes](../sections/gutentag--readme--arguments-and-scopes.md) | html-modules | current |
| [this-space-and-xml](../sections/gutentag--readme--this-space-and-xml.md) | html-modules | current |
| [virtual-document-koerper](../sections/gutentag--readme--virtual-document-koerper.md) | html-modules, web-frontend | current |
