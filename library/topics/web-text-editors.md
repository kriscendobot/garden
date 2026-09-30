# web-text-editors

Building or embedding a **text / code editor inside a web page** — the "how do we add something like Monaco to a web app" question. Organized around the substrate choice, because every other decision follows from it: an **editor library** that renders a DOM of `<div>`s (Monaco, the VS Code editor; CodeMirror and others are not yet covered by any ingested source), or a from-scratch editor built on **`<canvas>`**, **`contenteditable`** (`plaintext-only`), or **`<textarea>`**, each trading rendering control against what the browser gives for free (selection, undo, IME input, accessibility) and against large-document performance. Also collects the cross-cutting editor techniques: syntax highlighting (overlay layers, the CSS Custom Highlight API, OpaqueRange, Tree-sitter), scrolling/virtualization, input-latency pitfalls, and UTF-16 versus grapheme-cluster text indexing. Start at the [web-text-editor-approaches](../concepts/web-text-editor-approaches.md) concept for the options-and-tradeoffs table. Distinct from `web-frontend` (general CSS/HTML styling technique, which the editor sections also file under) and `chat-ui` (a product UI).

## Sections

| Section | One-line summary |
|---|---|
| [Overview: why build a web text editor, and Monaco as the div-soup baseline](../sections/web--dbushell-text-editor--overview.md) | Motivation for a from-scratch web editor and Monaco (VS Code's editor) as the "`<div>` soup" incumbent baseline. |
| [Canvas: rendering the editor on a <canvas> element](../sections/web--dbushell-text-editor--canvas.md) | A canvas-rendered editor gives full control but nothing for free (selection, undo, paste, scrolling) and is entirely inaccessible; abandoned. |
| [Content editable: a contenteditable="plaintext-only" editing surface](../sections/web--dbushell-text-editor--content-editable.md) | `contenteditable="plaintext-only"` gives native selection, undo, and accessibility; disable spellcheck for latency; unpredictable large-document slowdown. |
| [Textarea: a <textarea> editor with a separate syntax-highlight layer](../sections/web--dbushell-text-editor--textarea.md) | `<textarea>` is fastest on long text but needs an overlay layer for highlighting; OpaqueRange, EditContext, Tree-sitter, inverse-sticky virtualization. |
| [UTF-16 code units versus grapheme clusters in editor text ranges](../sections/web--dbushell-text-editor--utf-16-and-grapheme-clusters.md) | JS strings and text ranges index by UTF-16 code units; step cursors by grapheme cluster with `Intl.Segmenter`. |

## See also

- web-frontend — cross-cutting CSS/HTML technique (`::highlight`, `::selection`, `caret-color` live there too).
- chat-ui — the garden's own web UI product, a likely consumer of an embedded editor.
- Concepts: [web-text-editor-approaches](../concepts/web-text-editor-approaches.md), [code-editor-syntax-highlighting](../concepts/code-editor-syntax-highlighting.md), [grapheme-cluster-text-indexing](../concepts/grapheme-cluster-text-indexing.md).
