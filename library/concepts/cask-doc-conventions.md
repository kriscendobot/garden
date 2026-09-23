---
id: cask-doc-conventions
aliases: ["cask style guide", "cask CONTRIBUTING", "cask contributing", "cask markdown style", "one sentence per line", "sentence per line wrap", "80 column wrap", "regular english plurals", "indexes not indices", "matrixes not matrices", "vertexes not vertices", "appendixes not appendices", "Latin plural avoidance", "Mermaid over ASCII art", "Markdown tables over ASCII columns"]
topics: [repository-governance]
status: current
---

# cask-doc-conventions

CASK's documentation-hygiene conventions, stated across `doc/design/style.md` (the design-corpus style guide) and the repository-root `CONTRIBUTING.md`. **Markdown style** (CONTRIBUTING.md): wrap prose at approximately 80 columns and begin every sentence on a new line, so a diff to one sentence does not cascade into rewrapping the rest of the paragraph; avoid leaving honorifics or abbreviations at a line end (a period at a line break reads as a sentence end); break long sentences at a natural clause boundary; prefer Markdown tables over hand-aligned ASCII columns and Mermaid fences over ASCII art (both render well on GitHub and are easier to maintain). **Spelling / pluralization** (both files): prefer regular English plurals over Latin or Greek forms (indexes not indices, matrixes not matrices, vertexes not vertices, appendixes not appendices) to be more welcoming to non-native English speakers, in both code and prose. CASK's `CONTRIBUTING.md` specifies no PR-process or commit-message rules; it is purely about document hygiene. Note the one-sentence-per-line convention is CASK's own project rule and is independent of the garden's house style.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [cask--contributing--markdown-and-spelling-conventions](../sections/cask--contributing--markdown-and-spelling-conventions.md) | The 80-column one-sentence-per-line wrap discipline, line-end punctuation caution, tables-over-ASCII / Mermaid-over-ASCII-art, and regular-plurals spelling. |
| [cask--style--pluralization](../sections/cask--style--pluralization.md) | The standalone design-corpus style guide: prefer regular English plurals (indexes/matrixes/vertexes/appendixes) in code and prose. |

## See also

- [[content-addressed-block-store]] — the CASK project these conventions govern.
