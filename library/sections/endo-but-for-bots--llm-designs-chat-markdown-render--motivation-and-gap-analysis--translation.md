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
topics: [chat-ui]
status: current
parent: endo-but-for-bots--llm-designs-chat-markdown-render--motivation-and-gap-analysis
---

| Paper / CommonMark term | Endo-side surface |
|---|---|
| inline parser / scanner | `parseInline` in `@endo/markmdown` |
| flanking delimiter run | left-flanking / right-flanking from CommonMark §6.2 |
| code span | inline ` `` ` segment (the design also uses *code span* uniformly) |
| code fence | block-level ` ``` ` segment |
| GFM | GitHub-Flavored Markdown — strikethrough and tables come from this superset |
| placeholder | `` Private Use Area character; the chat layer marks chip slots with this rune before parsing, then walks the parsed DOM to replace runs of placeholders with `md-chip-slot` spans |

Source: [designs/chat-markdown-render.md](https://github.com/endojs/endo-but-for-bots/blob/5e6dbb533c9b9853c681588541362dbdda3a91c6/designs/chat-markdown-render.md) at commit `5e6dbb53`.
