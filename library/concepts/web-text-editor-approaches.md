---
id: web-text-editor-approaches
aliases: ["web text editor", "code editor on the web", "browser code editor", "in-browser text editor", "embed a code editor", "add a text editor to a web app", "Monaco", "Monaco Editor", "CodeMirror", "canvas text editor", "contenteditable editor", "textarea editor", "EditContext"]
topics: [web-text-editors, web-frontend]
status: current
---

# web-text-editor-approaches

The substrate choice for putting a text or code editor in a web page. Each option trades **how much the browser does for you** (selection, undo/redo, paste, IME/composition input, scrolling, accessibility) against **rendering control** and **large-document performance**. Comparison as surveyed by the ingested sources (currently one hands-on source, Bushell 2026; rows marked *uncovered* have no library source yet):

| Approach | What you get free | What you build / pay | Performance | Accessibility | Source verdict |
|---|---|---|---|---|---|
| **Editor library rendering a DOM of `<div>`s** (Monaco, the VS Code editor) | Everything a full IDE editor has | Bundle weight; "`<div>` soup" DOM | Adequate on modern hardware; slow on older (per Bushell) | Library-provided | The incumbent baseline; not evaluated in depth |
| **CodeMirror, Ace, and other libraries** | — | — | — | — | *Uncovered* — no ingested source yet |
| **`<canvas>` rendering** | Nothing ("gives me nothing for free") | Cursor, selection, undo, multi-line paste, scrolling (cheat: hidden native-overflow `<div>` as scroll proxy) | Constant redraw work at 60–120 fps | Entirely inaccessible — the deal-breaker | Abandoned. EditContext API improves canvas *input* only |
| **`contenteditable="plaintext-only"`** | Native selection, undo history, accessibility; single text node; CSS `::highlight` works | Custom cursor via Selection API if wanted; must disable `spellcheck`/`autocorrect`/`autocapitalize`/`translate` (latency spikes) | Unpredictable wall past a certain character count; Chromium worst | Good (native) | Viable for modest file sizes |
| **`<textarea>`** | Native form control: selection, undo, accessibility | Separate overlay layer for syntax highlighting (no `::highlight` until OpaqueRange); tab key handling | Best of the three on long text | Good (native) | Best performer; the post's final demo |

Cross-cutting concerns regardless of substrate: syntax highlighting strategy ([code-editor-syntax-highlighting](code-editor-syntax-highlighting.md)), virtualized rendering of visible lines only for very large files (the "inverse sticky technique"), and indexing text by grapheme cluster rather than UTF-16 code unit ([grapheme-cluster-text-indexing](grapheme-cluster-text-indexing.md)).

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [overview](../sections/web--dbushell-text-editor--overview.md) | Monaco (VS Code's editor) as the "`<div>` soup" incumbent a from-scratch editor is measured against. |
| [canvas](../sections/web--dbushell-text-editor--canvas.md) | Canvas substrate: full control, nothing free, inaccessible; hidden-overflow scroll proxy; EditContext for input. |
| [content-editable](../sections/web--dbushell-text-editor--content-editable.md) | `contenteditable="plaintext-only"` substrate: native selection/undo/a11y; disable spellcheck; large-document perf wall. |
| [textarea](../sections/web--dbushell-text-editor--textarea.md) | `<textarea>` substrate: fastest on long text; needs a highlight overlay layer; the remaining "rest of the owl". |

## See also

- [code-editor-syntax-highlighting](code-editor-syntax-highlighting.md) — the highlighting layer each substrate needs.
- [grapheme-cluster-text-indexing](grapheme-cluster-text-indexing.md) — the text-offset pitfall every custom editor hits.
- Topic: [web-text-editors](../topics/web-text-editors.md).

## Common confusions

- "Monaco" in this library means Microsoft's Monaco Editor (VS Code's editor component), not the principality or other projects of that name.
