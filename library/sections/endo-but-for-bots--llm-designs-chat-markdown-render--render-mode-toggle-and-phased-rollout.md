---
title: Per-message render mode toggle, phased rollout, and design decisions
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
notes: Phases 0, 1, and most of 2-3 have shipped as of 2026-05-15. `packages/markmdown/` exists with a flanking-rule state-machine scanner in `parse-inline.js` (Phase 1), GFM table parsing + blockquotes + horizontal rules in `parse-blocks.js` (Phases 2-3 partially), and a fixture-driven test runner using `happy-dom` matching the design's `.md`+`.html` fixture-pair convention. `packages/chat/markdown-render.js` is now a thin wrapper importing from `@endo/markmdown`. **The per-message render-mode toggle (Markdown/Literal/Preformatted) has NOT shipped** — `inbox-component.js` carries no `WeakMap<Element, Mode>` and no mode-switching UI. The design's `Status:` row is still `Proposed` upstream despite the implementation being substantially further along. See cycle 64's result entry for divergence detail; consider flagging to boatman for a status-row refresh + a remaining-work pointer to the render-mode toggle.
kind: index
section_count: 7
---

> Abstract: A per-message render mode toggle adds a `</>` segmented control to each message's timestamp tooltip, letting the recipient flip between **Markdown** (the default), **Literal** (raw text, no formatting), and **Preformatted** (`<pre>` monospace). The mode is per-message and ephemeral (a `WeakMap<Element, Mode>`), not persisted. The implementation rolls out in four phases: **Phase 0** scaffolds `packages/markmdown` and extracts the existing parser/renderer (the existing tests must still pass); **Phase 1** rewrites the inline scanner with flanking rules and multi-backtick spans (Gaps 1, 2, 3, 5, 6, 8); **Phase 2** adds GFM tables and links (Gaps 4, 7); **Phase 3** adds blockquotes, nested lists, horizontal rules, and the render-mode toggle (Gaps 9, 10, 11). The eight design decisions name the load-bearing choices: extract to a standalone package; align with CommonMark for delimiter semantics; drop underline; retire `/slash/` italic; state-machine over layered regexes; keep `\n`-as-hard-break; DI for code highlighting; no raw HTML.

Sections:

- [Per-message render mode toggle](endo-but-for-bots--llm-designs-chat-markdown-render--render-mode-toggle-and-phased-rollout--per-message-render-mode-toggle.md)
- [Phased implementation](endo-but-for-bots--llm-designs-chat-markdown-render--render-mode-toggle-and-phased-rollout--phased-implementation.md)
- [The eight design decisions](endo-but-for-bots--llm-designs-chat-markdown-render--render-mode-toggle-and-phased-rollout--the-eight-design-decisions.md)
- [Known gaps and TODOs](endo-but-for-bots--llm-designs-chat-markdown-render--render-mode-toggle-and-phased-rollout--known-gaps-and-todos.md)
- [Translation](endo-but-for-bots--llm-designs-chat-markdown-render--render-mode-toggle-and-phased-rollout--translation.md)
- [Implications for Endo](endo-but-for-bots--llm-designs-chat-markdown-render--render-mode-toggle-and-phased-rollout--implications-for-endo.md)
- [See also](endo-but-for-bots--llm-designs-chat-markdown-render--render-mode-toggle-and-phased-rollout--see-also.md)

Source: [designs/chat-markdown-render.md](https://github.com/endojs/endo-but-for-bots/blob/5e6dbb533c9b9853c681588541362dbdda3a91c6/designs/chat-markdown-render.md) at commit `5e6dbb53`.
