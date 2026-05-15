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
---

> Abstract: The chat client's inline-formatting parser (`packages/chat/markdown-render.js`, `parseInline`, line 47) implements a Markdown-like subset with chip interpolation. It diverges from CommonMark in ways that bite daily, especially on LLM-generated output: `*single*` means bold instead of italic, `**bold**` is broken (matches as `<strong>*bold</strong>`), `_text_` means underline rather than italic, `/text/` is repurposed for italic (causing URL false positives), and word-boundary awareness is absent (so `snake_case_name` and `1*2*3` trigger emphasis). The redesign performs a gap analysis against CommonMark + GFM enumerating fourteen gaps, classifies each by priority (High / Medium-High / Medium / Low / not-recommended), assigns each to an implementation phase, and lays the groundwork for a CommonMark-aligned rewrite. Two deliberate divergences from CommonMark are preserved: `\n` remains a hard break (chat-context expectation), and raw HTML passthrough stays disabled (security).

## Current state of the chat-side parser

The current `parseInline` is a layered-regex implementation. The block parser handles headings, code fences, unordered and ordered lists, and paragraphs.

### Delimiter mapping (current vs CommonMark)

| Delimiter | Current | CommonMark |
|---|---|---|
| `*text*` | bold (`<strong>`) | italic (`<em>`) |
| `**text**` | **broken** — produces `<strong>*text</strong>` | bold (`<strong>`) |
| `/text/` | italic (`<em>`) | not markup |
| `_text_` | underline (`<u>`) | italic (`<em>`) |
| `__text__` | not supported | bold (`<strong>`) |
| `~text~` | strikethrough (`<s>`) | (GFM) strikethrough |
| `` `text` `` | inline code | inline code |

### Block-level support (current)

- Headings (`#` through `######`).
- Code fences (` ``` ` with optional language tag, exactly three backticks).
- Unordered lists (`-` or `*` prefix).
- Ordered lists (`1.` or `1)` prefix).
- Paragraphs (default).

## The 14 gaps

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

## Translation

| Paper / CommonMark term | Endo-side surface |
|---|---|
| inline parser / scanner | `parseInline` in `@endo/markmdown` |
| flanking delimiter run | left-flanking / right-flanking from CommonMark §6.2 |
| code span | inline ` `` ` segment (the design also uses *code span* uniformly) |
| code fence | block-level ` ``` ` segment |
| GFM | GitHub-Flavored Markdown — strikethrough and tables come from this superset |
| placeholder | `` Private Use Area character; the chat layer marks chip slots with this rune before parsing, then walks the parsed DOM to replace runs of placeholders with `md-chip-slot` spans |

## Implications for Endo

This is the design corpus's first instance of a CommonMark / GFM compatibility design. Two threads run through it that recur elsewhere in the corpus:

- The **producer-typed-shape, consumer-rendering** discipline (see `[[producer-typed-shape-consumer-rendering]]`) recurs here as parser-AST-shape vs DOM-rendering: the parser owns the typed AST, the renderer owns the DOM. Detail in the *package-extraction-and-typed-ast* sibling section.
- The **gap-driven design** shape — enumerate the gaps against a canonical standard, classify each by priority, assign each to a phase — mirrors the structure of `endo-but-for-bots--llm-designs-hurl` (the URL hardening design) and `endo-but-for-bots--llm-designs-hardened-text-codecs-shim`. Gap analysis is the design pattern for "we have an existing implementation; what would CommonMark / TC39-native / etc. require us to change to align?"

## See also

- [endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules](endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules.md) — the inline-parser substance: flanking-rule semantics, intraword `_` restriction, escape sequences.
- [endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast](endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast.md) — the `@endo/markmdown` extraction, test fixture convention, DI-based code highlighter.
- [endo-but-for-bots--llm-designs-chat-markdown-render--render-mode-toggle-and-phased-rollout](endo-but-for-bots--llm-designs-chat-markdown-render--render-mode-toggle-and-phased-rollout.md) — per-message Markdown / Literal / Preformatted toggle + the four-phase rollout.
- [endo-but-for-bots--llm-designs-chat-invariants--principles](endo-but-for-bots--llm-designs-chat-invariants--principles.md) — the chat client's *visual feedback* and *structured input over text parsing* principles frame why markdown rendering matters for chat output.

Source: [designs/chat-markdown-render.md](https://github.com/endojs/endo-but-for-bots/blob/5e6dbb533c9b9853c681588541362dbdda3a91c6/designs/chat-markdown-render.md) at commit `5e6dbb53`.
