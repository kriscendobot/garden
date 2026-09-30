---
id: code-editor-syntax-highlighting
aliases: ["syntax highlighting", "code highlighting in the browser", "CSS Custom Highlight API", "::highlight", "custom highlights", "OpaqueRange", "OpaqueRange API", "Tree-sitter", "tree-sitter", "MicroLighter", "highlight overlay layer", "inverse sticky technique", "virtualised scrolling", "virtualized scrolling"]
topics: [web-text-editors, web-frontend]
status: current
---

# code-editor-syntax-highlighting

How a web code editor colors its text, and how that interacts with the editing substrate. Options surveyed: (1) the **CSS Custom Highlight API** (`::highlight()` over registered `Range`s) — works on `contenteditable` text without wrapping spans, but not on `<textarea>` unless the new **OpaqueRange API** is available; (2) a **separate overlay layer** of `<div>`/`<span>` markup mirroring the visible lines, positioned over a `<textarea>` (demo used MicroLighter); (3) at scale, parse with **Tree-sitter** and generate highlights for **visible lines only**, since too many CSS highlights are themselves a performance bottleneck — optionally paired with virtualized scrolling (the "inverse sticky technique").

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [content-editable](../sections/web--dbushell-text-editor--content-editable.md) | The original plan: CSS `::highlight` directly on a `contenteditable` element. |
| [textarea](../sections/web--dbushell-text-editor--textarea.md) | `<textarea>` lacks `::highlight` → overlay layer (MicroLighter); OpaqueRange; Tree-sitter visible-lines-only; inverse sticky. |

## See also

- [web-text-editor-approaches](web-text-editor-approaches.md) — which substrate supports which highlighting option.
- Topic: [web-text-editors](../topics/web-text-editors.md).
