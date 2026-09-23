---
title: The 14 gaps
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

| # | Gap | Priority | Implement? | Phase |
|---|---|---|---|---|
| 1 | `**bold**` double-asterisk syntax | High | Yes | 1 |
| 2 | Delimiter semantics divergence | High | Yes | 1 |
| 3 | Word-boundary awareness | High | Yes | 1 |
| 4 | Tables (GFM) | High | Yes | 2 |
| 5 | Multi-backtick code spans + N-character code fences | Medium-High | Yes | 1 |
| 6 | Escape sequences | Medium | Yes | 1 |
| 7 | Links `[text](url)` | Medium-High | Yes | 2 |
| 8 | Inline formatting nesting | Medium | Yes | 1 |
| 9 | Blockquotes | Medium | Yes | 3 |
| 10 | Nested lists | Medium | Yes | 3 |
| 11 | Horizontal rules | Low | Yes | 3 |
| 12 | Images | Low | Defer | — |
| 13 | Line breaks (`\n`) | — | Keep as-is | — |
| 14 | Raw HTML and entities | — | No | — |

### High-priority gaps (1–3): the inline-parser rewrite

- **Gap 1** — current `^\*([^*]+)\*` matches `**bold**` as `<strong>*bold</strong>`, garbling the most common bold syntax in Markdown and LLM output.
- **Gap 2** — `*` = bold and `_` = underline conflict with universal Markdown muscle memory. Aligning fully with CommonMark requires retiring `/slash/` italic (which produces too many URL false positives), dropping underline (`<u>`) entirely (no standard delimiter for it), and accepting that existing messages using `*single*` for bold will re-render as italic. The user base is small enough that the break is acceptable.
- **Gap 3** — the current regex-per-delimiter approach fires on any adjacent pair, so `1*2*3` becomes bold, `snake_case_name` becomes underline (soon: italic), and `a~b~c` becomes strikethrough. The fix is a state-machine scanner enforcing CommonMark flanking-delimiter-run rules; details in the *delimiter-realignment-and-flanking-rules* sibling section.

### Tables (Gap 4)

LLM responses frequently include pipe-delimited tables. Without support, tables render as broken paragraph text. The design adds a `'table'` block type detected by a separator-row regex (`/^\|?\s*:?-+:?\s*(\|\s*:?-+:?\s*)*\|?\s*$/`); each cell's content runs through `parseInline` so chips, bold, italic, code, and links work inside cells. Rendered as `<table class="md-table">` with `<thead>` and `<tbody>`. Column alignment from the separator row (`:--` left, `--:` right, `:--:` center).

### Multi-backtick spans and N-character fences (Gap 5)

CommonMark §6.1 (inline code) opens a span with N backticks and closes with exactly N; everything between is content, with leading/trailing single space stripped if content is not all spaces. CommonMark §4.5 (code fences) opens with `N >= 3` backticks-or-tildes, closes with the same character and at least N. The current parser supports only single backticks and exactly three. The design lifts both restrictions.

### Escape sequences and inline nesting (Gaps 6, 8)

Backslash escapes (Gap 6) are needed so literal `*`, `_`, `` ` ``, `[`, and `\` can be emitted. Inline nesting (Gap 8) means `**bold *italic* inside**` parses as a `<strong>` containing an `<em>`, which the regex approach cannot do; the state-machine scanner produces nested `Token` trees, and `renderInlineTokens` recurses.

### Links, blockquotes, nested lists, rules, images (Gaps 7, 9, 10, 11, 12)

- **Links** (Gap 7) — `[text](url)` syntax. Inline scanner detection. URL passes through `textContent` for safety; no `javascript:` filtering needed at the parser level because the renderer uses `textContent`.
- **Blockquotes** (Gap 9) — `>`-prefixed lines aggregated into a `<blockquote>` block.
- **Nested lists** (Gap 10) — indent-based descent in the block parser.
- **Horizontal rules** (Gap 11) — `---`, `***`, `___` on a line alone.
- **Images** (Gap 12) — deferred indefinitely; chat has its own blob/attachment system, and `![alt](url)` (when implemented) should render as a clickable link rather than an inline image to avoid layout disruption.

### Deliberate divergences from CommonMark (Gaps 13, 14)

- **Line breaks (Gap 13)** — CommonMark treats paragraph-internal newlines as soft breaks rendered as spaces; the chat parser converts every `\n` to `<br>`. The current behavior is correct and expected for chat (users expect Enter to produce a visible line break) and is preserved as a deliberate, documented divergence.
- **Raw HTML and entities (Gap 14)** — raw HTML in chat messages is an XSS risk. The renderer uses `textContent` exclusively for user-supplied strings. Do not implement raw-HTML passthrough.

Source: [designs/chat-markdown-render.md](https://github.com/endojs/endo-but-for-bots/blob/5e6dbb533c9b9853c681588541362dbdda3a91c6/designs/chat-markdown-render.md) at commit `5e6dbb53`.
