---
title: Common confusions
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
parent: endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules
---

- *"`\n` is a hard break in CommonMark"* — no. CommonMark renders paragraph-internal `\n` as a space (soft break); hard breaks require two trailing spaces or a backslash before the newline. The chat parser treats every `\n` as `<br>` (hard break), which is a deliberate, documented divergence preserved by the redesign (Gap 13, "Keep as-is").
- *"strikethrough is in CommonMark"* — no. Strikethrough (`~text~`, `~~text~~`) is a GFM extension on top of CommonMark. The chat parser already supported `~text~`; the redesign keeps it and adds `~~text~~`.

Source: [designs/chat-markdown-render.md](https://github.com/endojs/endo-but-for-bots/blob/5e6dbb533c9b9853c681588541362dbdda3a91c6/designs/chat-markdown-render.md) at commit `5e6dbb53`.
