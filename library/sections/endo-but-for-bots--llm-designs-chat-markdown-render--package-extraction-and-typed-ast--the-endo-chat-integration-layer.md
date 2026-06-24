---
title: The `@endo/chat` integration layer
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

`packages/chat` becomes a thin consumer of `@endo/markmdown`:

- `markdown-render.js` shrinks to a wrapper that calls `parseBlocks` and `renderBlocks` from `@endo/markmdown`, then walks the resulting DOM to find placeholder characters and replace them with `md-chip-slot` spans.
- It injects a Monaco-backed `highlightCode` into `renderBlocks` for rich syntax highlighting across all languages Monaco supports.
- `prepareTextWithPlaceholders` stays in `@endo/chat` (chat-specific).
- `renderPlainText` stays in `@endo/chat` but delegates inline parsing to `@endo/markmdown`.

`@endo/chat` adds `"@endo/markmdown": "workspace:^"` to its dependencies.

Source: [designs/chat-markdown-render.md](https://github.com/endojs/endo-but-for-bots/blob/5e6dbb533c9b9853c681588541362dbdda3a91c6/designs/chat-markdown-render.md) at commit `5e6dbb53`.
