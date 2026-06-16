---
title: Implications for Endo
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

The flanking-rule + delimiter-stack design is *the* lingua franca for inline parsers across the Markdown ecosystem (CommonMark reference, `markdown-it`, `remark`, `pulldown-cmark`). Endo's `@endo/markmdown` adopts the same shape rather than rolling a new approach, which means future contributors who already know CommonMark internals can read the scanner without translation.

The placeholder-as-regular-character classification is a small but important decision: it lets the chat layer's chip mechanism compose with the parser without either side knowing about the other. The chat layer marks chip slots before the parser runs and walks the parsed DOM afterward; the parser sees only the runes and treats them like any other letter. This is the parser equivalent of *consumers own rendering, producers own typed shape* — the chip semantics are the *consumer's* concern, and the parser owns the typed shape (the AST) that the consumer post-processes.

Source: [designs/chat-markdown-render.md](https://github.com/endojs/endo-but-for-bots/blob/5e6dbb533c9b9853c681588541362dbdda3a91c6/designs/chat-markdown-render.md) at commit `5e6dbb53`.
