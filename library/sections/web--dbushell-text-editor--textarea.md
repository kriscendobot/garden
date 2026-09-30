---
title: Textarea: a <textarea> editor with a separate syntax-highlight layer
source_kind: web
source_url: https://dbushell.com/2026/09/01/text-editor/
source_content_sha256: 3ab555a041ecba3f68f8a791498911288079554457b7b26ddc478e0dd7630e20
source_authors: [David Bushell]
source_date: 2026-09-01
ingested: 2026-09-30
ingested_by: scholar
topics: [web-text-editors, web-frontend]
status: current
---

**Abstract.** The third and best-performing approach: a plain `<textarea>` is "far more performant for longer text" than `contenteditable`. Because a `<textarea>` cannot take CSS Custom Highlights (`::highlight`), syntax highlighting needs a third layer — a `<div>` overlay of the visible lines, highlighted with MicroLighter in the demo — with two post-publication pointers: the new OpaqueRange API unlocks custom highlights for `<textarea>`, and EditContext improves `<canvas>` input. Many CSS highlights are themselves a bottleneck; the robust path is Tree-sitter parsing with highlights generated for visible lines only, optionally with virtualized scrolling via the "inverse sticky technique". The author ends at "90% of a text editor with 1% of the features" (tab indentation is still a hijacked key inserting two spaces) and shelves the project.

Instead of plaintext `contenteditable` would a simple `<textarea>` be viable? In short: yes. Turns out a `<textarea>` is far more performant for longer text.

In this final demo I've added syntax highlighting too.

My original plan was to use [custom `::highlight`](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Selectors/::highlight) on the `contenteditable` element. `<textarea>` can't use CSS highlights so a third layer was required. For demo purposes I added some `<div>` soup for the visible lines to apply [MicroLighter](https://davatron5000.github.io/microlighter/).

*Edit:* I'm told the new [OpaqueRange API](https://olliewilliams.xyz/blog/opaquerange/) unlocks custom highlights for `<textarea>` — neat!

*Edit 2:* and the [EditContext API](https://developer.mozilla.org/en-US/docs/Web/API/EditContext_API) improves `<canvas>` input.

Too many CSS highlights are another performance bottleneck. A more robust solution would be to use [Tree-sitter](https://tree-sitter.github.io/tree-sitter/) to generate a syntax tree and walk that to generate highlights for only visible lines. I was hoping to avoid virtualised scrolling entirely but I could improve it using the [inverse sticky technique](https://pierre.computer/writing/on-rendering-diffs) (from "On rendering diffs", a write-up on CodeView). Or I can go back to `contenteditable` because the file sizes I'd be editing don't hit the performance wall.

Looks like 90% of a text editor with 1% of the features. From here it's pretty straight forward to draw the rest of the owl. I'm tempted to keep drawing but then I think about all the little things like tab indentation. Right now I just hijack the tab key to insert two spaces…

My demos above are unoptimised and far from perfectly accessible but at least I'm not starting from a losing position. Rendering on `<canvas>` would be a nightmare. I'm filing this project away for a rainy day.

**Tradeoff summary (scholar).** Best raw performance on long text and native form-control accessibility/undo, at the cost of an extra synchronized overlay layer for any rich rendering (highlighting, decorations) until OpaqueRange-backed `::highlight` on `<textarea>` is broadly available. The remaining "rest of the owl" the post names or implies: tab/indent handling, virtualized rendering for very large files, incremental parsing, and correct UTF-16/grapheme handling (see [the UTF-16 coda](web--dbushell-text-editor--utf-16-and-grapheme-clusters.md)).

Source: [Fine, I’ll build my own text editor!](https://dbushell.com/2026/09/01/text-editor/) by David Bushell, 2026-09-01 (content SHA-256 `3ab555a0`, retrieved 2026-09-30).
