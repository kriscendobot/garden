---
title: Placeholder handling
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

The `` Private-Use-Area placeholder character is not special to `@endo/markmdown`. The inline parser treats it as a regular non-whitespace non-punctuation character, which means it passes through the parse tree as literal text. This is correct: the chat layer is responsible for placeholder *semantics*, and it post-processes the rendered DOM to find placeholder runs and replace them with `md-chip-slot` spans.

The clean separation is the parser equivalent of *consumers own rendering, producers own typed shape* (the [`producer-typed-shape-consumer-rendering`](../concepts/producer-typed-shape-consumer-rendering.md) concept): the parser owns the typed AST (and the rendered DOM is a faithful image of that AST), and the chat layer's chip semantics are a separate consumer concern that the parser never knows about. A future consumer that renders Markdown to terminal text, JSON, or a different DOM dialect inherits the same AST and renders its own way.

Source: [designs/chat-markdown-render.md](https://github.com/endojs/endo-but-for-bots/blob/5e6dbb533c9b9853c681588541362dbdda3a91c6/designs/chat-markdown-render.md) at commit `5e6dbb53`.
