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
---

> Abstract: A per-message render mode toggle adds a `</>` segmented control to each message's timestamp tooltip, letting the recipient flip between **Markdown** (the default), **Literal** (raw text, no formatting), and **Preformatted** (`<pre>` monospace). The mode is per-message and ephemeral (a `WeakMap<Element, Mode>`), not persisted. The implementation rolls out in four phases: **Phase 0** scaffolds `packages/markmdown` and extracts the existing parser/renderer (the existing tests must still pass); **Phase 1** rewrites the inline scanner with flanking rules and multi-backtick spans (Gaps 1, 2, 3, 5, 6, 8); **Phase 2** adds GFM tables and links (Gaps 4, 7); **Phase 3** adds blockquotes, nested lists, horizontal rules, and the render-mode toggle (Gaps 9, 10, 11). The eight design decisions name the load-bearing choices: extract to a standalone package; align with CommonMark for delimiter semantics; drop underline; retire `/slash/` italic; state-machine over layered regexes; keep `\n`-as-hard-break; DI for code highlighting; no raw HTML.

## Per-message render mode toggle

The mode selector is a small `</>` icon or segmented control inside the existing timestamp tooltip on each message bubble:

| Mode | Behavior |
|---|---|
| **Markdown** | Default rendered view through `@endo/markmdown`. |
| **Literal** | Raw text, no formatting — useful when the formatting hides what the sender actually typed. |
| **Preformatted** | Entire message in `<pre>` / monospace — useful when the message *is* code or a fixed-width artifact. |

Implementation details:

- Store the mode in a `WeakMap<Element, 'markdown' | 'literal' | 'preformatted'>` keyed on the message-body element.
- On mode change, re-render the message body using the appropriate render function.
- The toggle lands inside the existing timestamp tooltip; the inbox component's keyboard model already has the tooltip as a focusable surface, so no new keyboard-action plumbing is needed.

This is per-message rather than per-space because different messages legitimately want different modes: an LLM-generated code-walkthrough wants Markdown so its tables and bolding render; a debugging dump wants Preformatted so whitespace and column alignment survive; a user explanation of a Markdown-syntax bug wants Literal so the meta-discussion is not itself re-rendered.

## Phased implementation

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

## The eight design decisions

1. **Extract to `@endo/markmdown`.** The parser and renderer are general-purpose and warrant dedicated test fixtures, independent versioning, and potential reuse beyond chat (markdown preview, agent-output rendering). Placeholder / chip interpolation stays in `@endo/chat` as a thin integration layer.

2. **Align `*` / `_` with CommonMark.** Maximizes compatibility with LLM output and user expectations. The cost is a breaking change for existing messages that use `*single*` for bold, but the user base is small enough that the benefit dominates.

3. **`__text__` = bold (full CommonMark alignment); underline drops entirely.** No standard Markdown delimiter for underline exists, and repurposing any delimiter creates confusion. A non-conflicting extension (e.g., `++text++`) can be proposed separately if underline becomes necessary.

4. **Retire `/slash/` italic.** Slash is too common in URLs, file paths, and prose to be a reliable delimiter. With `*` and `_` available for italic, `/` is redundant. Retiring it eliminates the largest class of false positives.

5. **State-machine parser over layered regexes.** The current regex approach cannot handle double delimiters, nesting, escapes, or boundary rules without exponential complexity. A single-pass scanner handles all of them naturally.

6. **`\n` is a hard break (diverge from CommonMark).** Chat users expect Enter to produce a visible line break. Requiring trailing spaces for hard breaks would be confusing.

7. **Dependency injection for code highlighting.** `@endo/markmdown` must not depend on Monaco or any editor library. The renderer accepts an optional `highlightCode` callback; without one, code fences render as plain unhighlighted text. `@endo/chat` injects Monaco's tokenizer at the call site.

8. **No raw HTML passthrough.** Security trumps completeness. The renderer uses `textContent` exclusively for user content.

## Known gaps and TODOs

- Autolinks (bare-URL detection) — deferred; can add in Phase 2 or later.
- Image syntax — deferred indefinitely (chat has its own attachment system).
- Nested blockquotes — supported by the recursive design but may need depth-limiting for display.
- Task lists (`- [ ]` / `- [x]`) — GFM extension, low priority.

## Translation

| Paper / CommonMark term | Endo-side surface |
|---|---|
| render mode | per-message Markdown / Literal / Preformatted toggle |
| `WeakMap` keyed on message body | the per-message mode store (ephemeral, not persisted) |
| Phase 0 / Phase 1 / Phase 2 / Phase 3 | the design's own four-phase rollout shape, also used by `endo-but-for-bots--llm-designs-base64-native-fallthrough` and `endo-but-for-bots--llm-designs-hardened-text-codecs-shim` |

## Implications for Endo

The render-mode toggle is a small but instructive example of the *uniform autocomplete list navigation* and *modeline completeness* invariants applied to a tertiary affordance: the existing timestamp tooltip is the keyboard-accessible surface, and the new `</>` toggle lands inside it rather than creating a new modal or menu. The chat-invariants design's *progressive complexity* principle is what justifies the placement: most users never need the toggle; those who need it find it in the natural inspect-this-message gesture.

The phased-rollout shape (Phase 0 visually-invisible scaffold + N feature phases) is a recurring shape across the corpus's larger designs. See `endo-but-for-bots--llm-designs-chat-color-schemes--implementation-and-monaco-bridge` (Step 1 is the visually-invisible rename pass) and `endo-but-for-bots--llm-designs-base64-native-fallthrough` (three S-sized phases) for two other instances. The shape is sound enough to be worth naming on its own; for now the design corpus carries three instances of it.

## See also

- [endo-but-for-bots--llm-designs-chat-markdown-render--motivation-and-gap-analysis](endo-but-for-bots--llm-designs-chat-markdown-render--motivation-and-gap-analysis.md) — what the phases address.
- [endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules](endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules.md) — what Phase 1 implements.
- [endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast](endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast.md) — the package the phases land into.
- [endo-but-for-bots--llm-designs-chat-color-schemes--implementation-and-monaco-bridge](endo-but-for-bots--llm-designs-chat-color-schemes--implementation-and-monaco-bridge.md) — same visually-invisible-baseline-then-feature-phases shape.
- [endo-but-for-bots--llm-designs-base64-native-fallthrough](../sources/endo-but-for-bots--llm-designs-base64-native-fallthrough.md) — same shape applied to a vetted-shim rollout.

Source: [designs/chat-markdown-render.md](https://github.com/endojs/endo-but-for-bots/blob/5e6dbb533c9b9853c681588541362dbdda3a91c6/designs/chat-markdown-render.md) at commit `5e6dbb53`.
