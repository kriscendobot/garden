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
parent: endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules
---

| Paper / CommonMark term | Endo-side surface |
|---|---|
| flanking delimiter run | left-flanking / right-flanking flags computed per-run by the scanner |
| delimiter stack | the LIFO stack of open delimiter runs waiting to be paired with a closer |
| intraword-underscore restriction | CommonMark §6.4: a left-and-right-flanking `_` run cannot open or close emphasis |
| Private Use Area character | ``, the chip-slot marker; classified as a regular non-whitespace non-punctuation character by the scanner |

Source: [designs/chat-markdown-render.md](https://github.com/endojs/endo-but-for-bots/blob/5e6dbb533c9b9853c681588541362dbdda3a91c6/designs/chat-markdown-render.md) at commit `5e6dbb53`.
