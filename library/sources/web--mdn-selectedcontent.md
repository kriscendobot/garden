---
source_kind: web
source_url: https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/selectedcontent
source_content_sha256: 3ebe0744a0997a6c9f6b427b345d2a17afb02e6e88fd2b3be87af47b2afeca60
source_authors: [MDN contributors]
source_date: 2026-04-24
retrieved: 2026-06-29
ingested: 2026-06-29
ingested_by: scholar
section_count: 1
status: current
notes: "MDN reference for the <selectedcontent> HTML element. Fetched live via direct curl; idempotency anchor is source_content_sha256. Marked Experimental + Limited availability upstream. One section captures placement rules, cloneNode() clone semantics + the dynamic-staleness warning, inertness, independent styling, and the technical summary."
---

The MDN reference for the `<selectedcontent>` element: the new element that displays a customizable `<select>`'s currently-selected `<option>` inside the closed select's first-child `<button>`. Captures the placement rules (only child of a first-child `<button>`, options after), the `cloneNode()` clone-on-selection-change semantics and the dynamic-content staleness warning, its inertness, that its content is styleable independently of the picker (hide a button-unfriendly icon while keeping it in the drop-down), the implicit un-targetable fallback button when omitted, and the technical summary (`HTMLSelectedContentElement`, no ARIA role).

| Section | Topics | Status |
|---------|--------|--------|
| [The <selectedcontent> element: clone semantics, inertness, and styling](../sections/web--mdn-selectedcontent--element-semantics-and-cloning.md) | web-frontend | current |
