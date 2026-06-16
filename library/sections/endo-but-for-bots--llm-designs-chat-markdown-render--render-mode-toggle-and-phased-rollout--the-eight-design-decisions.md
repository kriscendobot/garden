---
title: The eight design decisions
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

1. **Extract to `@endo/markmdown`.** The parser and renderer are general-purpose and warrant dedicated test fixtures, independent versioning, and potential reuse beyond chat (markdown preview, agent-output rendering). Placeholder / chip interpolation stays in `@endo/chat` as a thin integration layer.

2. **Align `*` / `_` with CommonMark.** Maximizes compatibility with LLM output and user expectations. The cost is a breaking change for existing messages that use `*single*` for bold, but the user base is small enough that the benefit dominates.

3. **`__text__` = bold (full CommonMark alignment); underline drops entirely.** No standard Markdown delimiter for underline exists, and repurposing any delimiter creates confusion. A non-conflicting extension (e.g., `++text++`) can be proposed separately if underline becomes necessary.

4. **Retire `/slash/` italic.** Slash is too common in URLs, file paths, and prose to be a reliable delimiter. With `*` and `_` available for italic, `/` is redundant. Retiring it eliminates the largest class of false positives.

5. **State-machine parser over layered regexes.** The current regex approach cannot handle double delimiters, nesting, escapes, or boundary rules without exponential complexity. A single-pass scanner handles all of them naturally.

6. **`\n` is a hard break (diverge from CommonMark).** Chat users expect Enter to produce a visible line break. Requiring trailing spaces for hard breaks would be confusing.

7. **Dependency injection for code highlighting.** `@endo/markmdown` must not depend on Monaco or any editor library. The renderer accepts an optional `highlightCode` callback; without one, code fences render as plain unhighlighted text. `@endo/chat` injects Monaco's tokenizer at the call site.

8. **No raw HTML passthrough.** Security trumps completeness. The renderer uses `textContent` exclusively for user content.

Source: [designs/chat-markdown-render.md](https://github.com/endojs/endo-but-for-bots/blob/5e6dbb533c9b9853c681588541362dbdda3a91c6/designs/chat-markdown-render.md) at commit `5e6dbb53`.
