---
title: Implications for Endo
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

The render-mode toggle is a small but instructive example of the *uniform autocomplete list navigation* and *modeline completeness* invariants applied to a tertiary affordance: the existing timestamp tooltip is the keyboard-accessible surface, and the new `</>` toggle lands inside it rather than creating a new modal or menu. The chat-invariants design's *progressive complexity* principle is what justifies the placement: most users never need the toggle; those who need it find it in the natural inspect-this-message gesture.

The phased-rollout shape (Phase 0 visually-invisible scaffold + N feature phases) is a recurring shape across the corpus's larger designs. See `endo-but-for-bots--llm-designs-chat-color-schemes--implementation-and-monaco-bridge` (Step 1 is the visually-invisible rename pass) and `endo-but-for-bots--llm-designs-base64-native-fallthrough` (three S-sized phases) for two other instances. The shape is sound enough to be worth naming on its own; for now the design corpus carries three instances of it.

Source: [designs/chat-markdown-render.md](https://github.com/endojs/endo-but-for-bots/blob/5e6dbb533c9b9853c681588541362dbdda3a91c6/designs/chat-markdown-render.md) at commit `5e6dbb53`.
