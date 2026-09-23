---
source: designs/chat-markdown-render.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 5e6dbb533c9b9853c681588541362dbdda3a91c6
source_date: 2026-03-27
source_authors: [Kris Kowal]
ingested: 2026-05-15
ingested_by: scholar
section_count: 4
status: current
notes: **Status: Proposed** upstream (design's own Status row) but **most of the implementation has shipped** as of 2026-05-15. `packages/markmdown/` exists with a flanking-rule state-machine scanner (Phase 1), GFM table parsing + blockquotes + horizontal rules + fixture-driven `happy-dom` testing (Phases 2-3 partial); `packages/chat/markdown-render.js` is now a thin wrapper. The **only Phase 3 item that has not shipped** is the per-message render-mode toggle (Markdown/Literal/Preformatted) in `inbox-component.js`. The status mismatch (design says Proposed; source says mostly-implemented) is worth a boatman missive — see cycle 64's result entry. The library captures the design's *typed-shape* (the 14 gaps, the flanking rules, the package boundary, the four phases, the eight decisions) which is the part that is stable regardless of which phase has shipped.
---

> Abstract: A gap-analysis design that aligns the chat client's inline-Markdown parser with CommonMark + GFM. Fourteen gaps are enumerated, classified by priority, and assigned to four implementation phases. The two load-bearing structural moves are (a) extracting the parser and renderer from `packages/chat/markdown-render.js` into a new standalone `@endo/markmdown` package whose typed AST is consumer-agnostic, and (b) replacing the layered-regex `parseInline` with a state-machine scanner enforcing CommonMark's flanking-delimiter-run rules. Delimiter semantics realign fully with CommonMark (`*` / `_` = italic, `**` / `__` = bold, `~` / `~~` = strikethrough), underline drops, `/slash/` italic retires, multi-backtick code spans and N-character code fences land, escape sequences land, and inline nesting works through recursive token trees. A per-message render-mode toggle (Markdown / Literal / Preformatted) lands in Phase 3 inside the existing timestamp tooltip. Two deliberate CommonMark divergences are preserved: `\n`-as-hard-break (chat-context expectation) and no-raw-HTML (XSS safety).

## Sections

| Section | Topics | Status |
|---|---|---|
| [motivation-and-gap-analysis](../sections/endo-but-for-bots--llm-designs-chat-markdown-render--motivation-and-gap-analysis.md) | chat-ui | current |
| [delimiter-realignment-and-flanking-rules](../sections/endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules.md) | chat-ui | current |
| [package-extraction-and-typed-ast](../sections/endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast.md) | chat-ui, patterns | current |
| [render-mode-toggle-and-phased-rollout](../sections/endo-but-for-bots--llm-designs-chat-markdown-render--render-mode-toggle-and-phased-rollout.md) | chat-ui | current |

## Cross-references

- [[producer-typed-shape-consumer-rendering]] — applied here at the parser boundary: `@endo/markmdown` owns the typed AST shape, consumers (`@endo/chat` today; future markdown preview, agent-output renderer) own their rendering. The chat-side chip-slot substitution is a post-process step on the rendered DOM, not a parser concern.
- [[token-chip]] — the chip-slot mechanism the chat layer post-processes onto the rendered DOM. The Private-Use-Area placeholder character is classified by the parser as regular non-whitespace non-punctuation, which is what lets the chip mechanism compose with the parser without either side knowing about the other.
- [endo-but-for-bots--llm-designs-chat-invariants](endo-but-for-bots--llm-designs-chat-invariants.md) — the *structured input over text parsing* principle frames why markdown rendering matters specifically for chat output.
- [endo-but-for-bots--llm-designs-chat-components](endo-but-for-bots--llm-designs-chat-components.md) — `packages/chat/markdown-render.js` is one of the file-structure-and-component-map entries; this design transforms it from a 500-line monolith into a thin wrapper around `@endo/markmdown`.
