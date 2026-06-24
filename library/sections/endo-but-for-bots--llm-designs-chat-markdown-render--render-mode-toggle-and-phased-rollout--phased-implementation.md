---
title: Phased implementation
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

### Phase 0 — Package scaffolding and extraction

Create `packages/markmdown` and move the existing parsing/rendering code out of `packages/chat/markdown-render.js`.

1. Scaffold `packages/markmdown` with `package.json`, `tsconfig.json`, `tsconfig.build.json`, and directory structure.
2. Move `parseInline`, `parseBlocks`, `renderInlineTokens`, `renderBlocks`, `highlightCode`, and type definitions into `packages/markmdown/src/`.
3. Rewrite `packages/chat/markdown-render.js` as a thin wrapper: imports from `@endo/markmdown`, adds placeholder/chip-slot logic.
4. Move and adapt existing tests from `packages/chat/test/unit/markdown-render.test.js` to `packages/markmdown/test/`.
5. Add `"@endo/markmdown": "workspace:^"` to `packages/chat`'s dependencies.
6. Verify the existing chat tests still pass — Phase 0 is the *visually invisible* baseline.

This phase has shipped: as of `llm@HEAD` on 2026-05-15, `packages/markmdown/` exists with `parse-inline.js`, `parse-blocks.js`, `render-dom.js`, and `types.js`, and `packages/chat/markdown-render.js` imports `parseInline as markmdownParseInline` from `@endo/markmdown`. The design's `Status:` row is still `Proposed` upstream, but Phase 0's deliverables exist.

### Phase 1 — Inline parser rewrite

Rewrite `parseInline` in `packages/markmdown` as the state-machine scanner described in the *delimiter-realignment-and-flanking-rules* sibling section.

1. Left-to-right scanner with flanking-delimiter-run rules (Gap 3).
2. Single and double delimiters: `*` / `**`, `_` / `__`, `~` / `~~` (Gaps 1, 2).
3. Multi-backtick inline code spans: run-length matching for `` ` ``, `` `` ``, ` ``` `, etc. (Gap 5).
4. Multi-backtick / tilde code fences: N >= 3 opener, >= N closer of the same character (Gap 5).
5. Produce nested `Token` trees; update `renderInlineTokens` to recurse (Gap 8).
6. Handle `\` escape sequences (Gap 6).
7. Build out test fixtures: `emphasis.md`, `bold.md`, `code-spans.md`, `code-fences.md`, `escapes.md`, `nesting.md`, `boundaries.md` plus the corresponding `.html` files.

### Phase 2 — Tables and links

1. Add GFM table parsing to `parseBlocks` (Gap 4).
2. Add table rendering to `renderBlocks` — `<table class="md-table">` + `<thead>` + `<tbody>`.
3. Add `[text](url)` link parsing to the inline scanner (Gap 7).
4. Add CSS for `md-table` and `md-link` in `packages/chat`.
5. Add `tables.md` / `tables.html` and `links.md` / `links.html` fixtures.

### Phase 3 — Block-level additions and render-mode toggle

1. Blockquote parsing and rendering (Gap 9).
2. Nested-list support (Gap 10).
3. Horizontal-rule detection (Gap 11).
4. Implement the per-message render mode toggle in `packages/chat` (`inbox-component.js`).
5. Add `blockquotes.md`, `nested-lists.md`, `horizontal-rules.md` fixtures.

Source: [designs/chat-markdown-render.md](https://github.com/endojs/endo-but-for-bots/blob/5e6dbb533c9b9853c681588541362dbdda3a91c6/designs/chat-markdown-render.md) at commit `5e6dbb53`.
