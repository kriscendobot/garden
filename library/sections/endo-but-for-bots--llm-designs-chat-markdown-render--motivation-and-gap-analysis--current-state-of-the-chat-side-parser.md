---
title: Current state of the chat-side parser
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

The current `parseInline` is a layered-regex implementation. The block parser handles headings, code fences, unordered and ordered lists, and paragraphs.

### Delimiter mapping (current vs CommonMark)

| Delimiter | Current | CommonMark |
|---|---|---|
| `*text*` | bold (`<strong>`) | italic (`<em>`) |
| `**text**` | **broken** — produces `<strong>*text</strong>` | bold (`<strong>`) |
| `/text/` | italic (`<em>`) | not markup |
| `_text_` | underline (`<u>`) | italic (`<em>`) |
| `__text__` | not supported | bold (`<strong>`) |
| `~text~` | strikethrough (`<s>`) | (GFM) strikethrough |
| `` `text` `` | inline code | inline code |

### Block-level support (current)

- Headings (`#` through `######`).
- Code fences (` ``` ` with optional language tag, exactly three backticks).
- Unordered lists (`-` or `*` prefix).
- Ordered lists (`1.` or `1)` prefix).
- Paragraphs (default).

Source: [designs/chat-markdown-render.md](https://github.com/endojs/endo-but-for-bots/blob/5e6dbb533c9b9853c681588541362dbdda3a91c6/designs/chat-markdown-render.md) at commit `5e6dbb53`.
