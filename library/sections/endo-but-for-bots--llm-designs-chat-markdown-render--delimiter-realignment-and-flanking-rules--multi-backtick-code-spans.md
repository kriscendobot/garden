---
title: Multi-backtick code spans
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

CommonMark §6.1 lets an inline code span be opened by a run of N backticks and closed by a matching run of exactly N. The state-machine scanner already counts run length when it encounters a backtick; the only additional work is the forward scan for an N-run closer and the content-stripping rule:

- ` `` code with `backtick` `` ` — double-backtick span contains a literal single backtick.
- ` ``` code with `` two `` ``` ` — triple-backtick span contains literal double backticks.

Leading and trailing single spaces are stripped if the content is not entirely spaces, so `` ` ` `` produces a literal backtick.

No further inline parsing happens inside code spans — no bold, no italic, no placeholder detection.

Source: [designs/chat-markdown-render.md](https://github.com/endojs/endo-but-for-bots/blob/5e6dbb533c9b9853c681588541362dbdda3a91c6/designs/chat-markdown-render.md) at commit `5e6dbb53`.
