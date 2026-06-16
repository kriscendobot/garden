---
title: Per-message render mode toggle
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

Source: [designs/chat-markdown-render.md](https://github.com/endojs/endo-but-for-bots/blob/5e6dbb533c9b9853c681588541362dbdda3a91c6/designs/chat-markdown-render.md) at commit `5e6dbb53`.
