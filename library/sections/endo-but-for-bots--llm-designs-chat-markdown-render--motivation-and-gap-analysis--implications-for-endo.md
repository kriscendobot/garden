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
parent: endo-but-for-bots--llm-designs-chat-markdown-render--motivation-and-gap-analysis
---

This is the design corpus's first instance of a CommonMark / GFM compatibility design. Two threads run through it that recur elsewhere in the corpus:

- The **producer-typed-shape, consumer-rendering** discipline (see `[[producer-typed-shape-consumer-rendering]]`) recurs here as parser-AST-shape vs DOM-rendering: the parser owns the typed AST, the renderer owns the DOM. Detail in the *package-extraction-and-typed-ast* sibling section.
- The **gap-driven design** shape — enumerate the gaps against a canonical standard, classify each by priority, assign each to a phase — mirrors the structure of `endo-but-for-bots--llm-designs-hurl` (the URL hardening design) and `endo-but-for-bots--llm-designs-hardened-text-codecs-shim`. Gap analysis is the design pattern for "we have an existing implementation; what would CommonMark / TC39-native / etc. require us to change to align?"

Source: [designs/chat-markdown-render.md](https://github.com/endojs/endo-but-for-bots/blob/5e6dbb533c9b9853c681588541362dbdda3a91c6/designs/chat-markdown-render.md) at commit `5e6dbb53`.
