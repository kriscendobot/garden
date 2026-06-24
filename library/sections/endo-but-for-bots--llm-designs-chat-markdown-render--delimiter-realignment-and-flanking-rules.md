---
title: Delimiter realignment to CommonMark and the flanking-delimiter scanner
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
section_count: 9
---

> Abstract: The inline-parser rewrite replaces the regex-per-delimiter approach in `parseInline` with a single left-to-right state-machine scanner that enforces CommonMark's flanking-delimiter-run rules. Delimiter semantics realign fully with CommonMark: `*text*` / `_text_` = italic, `**text**` / `__text__` = bold, `~text~` / `~~text~~` = strikethrough (GFM), `` `text` `` = inline code. Underline (`<u>`) drops entirely (no standard CommonMark delimiter for it); `/slash/` italic retires (too many URL false positives). The `_`-vs-`*` intraword distinction is preserved: `foo_bar_baz` does *not* trigger emphasis (CommonMark's intraword-underscore restriction), but `foo*bar*baz` *does* (no equivalent restriction on `*`). The `` Private Use Area placeholder character used for chip slots is classified as a regular character (non-whitespace, non-punctuation) for boundary purposes, so placeholder-adjacent emphasis behaves predictably.

Sections:

- [The state-machine scanner](endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules--the-state-machine-scanner.md)
- [Flanking-delimiter-run rules](endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules--flanking-delimiter-run-rules.md)
- [Multi-backtick code spans](endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules--multi-backtick-code-spans.md)
- [N-character code fences](endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules--n-character-code-fences.md)
- [Escape sequences](endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules--escape-sequences.md)
- [Translation](endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules--translation.md)
- [Implications for Endo](endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules--implications-for-endo.md)
- [Common confusions](endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules--common-confusions.md)
- [See also](endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules--see-also.md)

Source: [designs/chat-markdown-render.md](https://github.com/endojs/endo-but-for-bots/blob/5e6dbb533c9b9853c681588541362dbdda3a91c6/designs/chat-markdown-render.md) at commit `5e6dbb53`.
