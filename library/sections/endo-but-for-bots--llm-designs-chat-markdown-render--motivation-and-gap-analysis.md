---
title: Motivation and 14-gap analysis against CommonMark / GFM
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
kind: index
section_count: 5
---

> Abstract: The chat client's inline-formatting parser (`packages/chat/markdown-render.js`, `parseInline`, line 47) implements a Markdown-like subset with chip interpolation. It diverges from CommonMark in ways that bite daily, especially on LLM-generated output: `*single*` means bold instead of italic, `**bold**` is broken (matches as `<strong>*bold</strong>`), `_text_` means underline rather than italic, `/text/` is repurposed for italic (causing URL false positives), and word-boundary awareness is absent (so `snake_case_name` and `1*2*3` trigger emphasis). The redesign performs a gap analysis against CommonMark + GFM enumerating fourteen gaps, classifies each by priority (High / Medium-High / Medium / Low / not-recommended), assigns each to an implementation phase, and lays the groundwork for a CommonMark-aligned rewrite. Two deliberate divergences from CommonMark are preserved: `\n` remains a hard break (chat-context expectation), and raw HTML passthrough stays disabled (security).

Sections:

- [Current state of the chat-side parser](endo-but-for-bots--llm-designs-chat-markdown-render--motivation-and-gap-analysis--current-state-of-the-chat-side-parser.md)
- [The 14 gaps](endo-but-for-bots--llm-designs-chat-markdown-render--motivation-and-gap-analysis--the-14-gaps.md)
- [Translation](endo-but-for-bots--llm-designs-chat-markdown-render--motivation-and-gap-analysis--translation.md)
- [Implications for Endo](endo-but-for-bots--llm-designs-chat-markdown-render--motivation-and-gap-analysis--implications-for-endo.md)
- [See also](endo-but-for-bots--llm-designs-chat-markdown-render--motivation-and-gap-analysis--see-also.md)

Source: [designs/chat-markdown-render.md](https://github.com/endojs/endo-but-for-bots/blob/5e6dbb533c9b9853c681588541362dbdda3a91c6/designs/chat-markdown-render.md) at commit `5e6dbb53`.
