---
source_kind: web
source_url: https://dbushell.com/2026/09/01/text-editor/
source_content_sha256: 3ab555a041ecba3f68f8a791498911288079554457b7b26ddc478e0dd7630e20
source_authors: [David Bushell]
source_date: 2026-09-01
retrieved: 2026-09-30
ingested: 2026-09-30
ingested_by: scholar
section_count: 5
status: current
notes: "Fetched live (direct) via fetch-source.sh; the idempotency anchor is the SHA-256 of the full HTML response. Pre-classified by classify-foreign-content.sh: injection 0.1 (clean), slant neutral/0.6 -> proceed. The post's interactive demos are canvas/JS widgets and were not captured; the prose, code samples, and links were. Ingested so a design-research lookup on adding a text/code editor (Monaco-like) to a web app finds the substrate options and their tradeoffs."
---

David Bushell's 2026-09-01 blog post "Fine, I'll build my own text editor!" — a hands-on comparison of three substrates for a from-scratch in-browser code editor, measured against Monaco (VS Code's "`<div>` soup" editor library) as the incumbent: (1) **`<canvas>`** rendering (full control, but nothing for free and entirely inaccessible — abandoned), (2) **`contenteditable="plaintext-only"`** (native selection, undo, and accessibility; CSS `::highlight`-capable; but an unpredictable large-document performance wall, worst in Chromium), and (3) **`<textarea>`** (fastest on long text, but needs a separate overlay layer for syntax highlighting until OpaqueRange brings `::highlight` to it). Along the way it collects the reusable techniques — a hidden native-overflow `<div>` as scroll proxy, disabling `spellcheck`/`autocorrect` to kill input latency, Selection-API-driven custom cursors, Tree-sitter visible-lines-only highlighting, the "inverse sticky" virtualization technique, EditContext for canvas input — and closes on the UTF-16 versus grapheme-cluster pitfall. The cross-source synthesis lives in the [web-text-editors](../topics/web-text-editors.md) topic and the [web-text-editor-approaches](../concepts/web-text-editor-approaches.md) concept.

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/web--dbushell-text-editor--overview.md) | web-text-editors | current |
| [canvas](../sections/web--dbushell-text-editor--canvas.md) | web-text-editors, web-frontend | current |
| [content-editable](../sections/web--dbushell-text-editor--content-editable.md) | web-text-editors, web-frontend | current |
| [textarea](../sections/web--dbushell-text-editor--textarea.md) | web-text-editors, web-frontend | current |
| [utf-16-and-grapheme-clusters](../sections/web--dbushell-text-editor--utf-16-and-grapheme-clusters.md) | web-text-editors | current |
