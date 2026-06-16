---
title: Translation
source: designs/chat-markdown-render.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 5e6dbb533c9b9853c681588541362dbdda3a91c6
source_date: 2026-03-27
source_authors: [Kris Kowal]
ingested: 2026-05-15
ingested_by: scholar
topics: [chat-ui, patterns]
status: current
parent: endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast
---

| Paper / CommonMark term | Endo-side surface |
|---|---|
| AST | `Token` / `Block` / `RenderResult` typedefs in `packages/markmdown/src/types.js` |
| renderer | `renderBlocks`, `renderInlineTokens` — DOM-fragment producers in `render-dom.js` |
| highlighter | a `HighlightCode` callback the renderer calls per code fence |
| fixture | a paired `.md` + `.html` file under `packages/markmdown/test/fixtures/{md,html}/` |

Source: [designs/chat-markdown-render.md](https://github.com/endojs/endo-but-for-bots/blob/5e6dbb533c9b9853c681588541362dbdda3a91c6/designs/chat-markdown-render.md) at commit `5e6dbb53`.
