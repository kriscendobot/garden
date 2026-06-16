---
title: N-character code fences
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

The block parser detects fence openers with `/^(`{3,}|~{3,})(\w*)$/`. The fence character (backtick or tilde) and the run length N are recorded. The fence closes when a line starts with at least N of the same character and nothing else follows. This handles the case where a code-fenced block needs to contain a literal ` ``` ` — open with ` ```` ` (four backticks), embed ` ``` ` as content, close with ` ```` ` or more.

Source: [designs/chat-markdown-render.md](https://github.com/endojs/endo-but-for-bots/blob/5e6dbb533c9b9853c681588541362dbdda3a91c6/designs/chat-markdown-render.md) at commit `5e6dbb53`.
