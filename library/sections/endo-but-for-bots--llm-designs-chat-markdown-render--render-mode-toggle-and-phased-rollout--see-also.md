---
title: See also
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
parent: endo-but-for-bots--llm-designs-chat-markdown-render--render-mode-toggle-and-phased-rollout
---

- [endo-but-for-bots--llm-designs-chat-markdown-render--motivation-and-gap-analysis](endo-but-for-bots--llm-designs-chat-markdown-render--motivation-and-gap-analysis.md) — what the phases address.
- [endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules](endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules.md) — what Phase 1 implements.
- [endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast](endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast.md) — the package the phases land into.
- [endo-but-for-bots--llm-designs-chat-color-schemes--implementation-and-monaco-bridge](endo-but-for-bots--llm-designs-chat-color-schemes--implementation-and-monaco-bridge.md) — same visually-invisible-baseline-then-feature-phases shape.
- [endo-but-for-bots--llm-designs-base64-native-fallthrough](../sources/endo-but-for-bots--llm-designs-base64-native-fallthrough.md) — same shape applied to a vetted-shim rollout.

Source: [designs/chat-markdown-render.md](https://github.com/endojs/endo-but-for-bots/blob/5e6dbb533c9b9853c681588541362dbdda3a91c6/designs/chat-markdown-render.md) at commit `5e6dbb53`.
