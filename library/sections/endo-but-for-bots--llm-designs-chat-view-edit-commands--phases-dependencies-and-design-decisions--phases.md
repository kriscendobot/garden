---
title: Phases
source: designs/chat-view-edit-commands.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 2691e7d52d061c0a10b89864e879188f2d4e11d7
source_date: 2026-03-21
source_authors: [Kris Kowal]
ingested: 2026-05-28
ingested_by: scholar
topics: [chat-ui]
status: current
notes: |
  Combines the design's *Phases*, *Dependencies*, and *Design
  Decisions* sections into one section. The four-phase rollout is the
  delivery shape; the dependency table is what the design assumes;
  the five design decisions are the load-bearing trade-offs the
  design names explicitly.
parent: endo-but-for-bots--llm-designs-chat-view-edit-commands--phases-dependencies-and-design-decisions
---

The design names a four-phase rollout that explicitly defers the
most complex sub-feature (Markdown split view) so the core commands
can ship first:

1. **Phase 1: `/view` with plain text.** Modal viewer, Monaco in
   read-only mode, content loaded via `text()`. No content-type
   inference beyond "text".

2. **Phase 2: `/edit` with mutable save.** Monaco editor with
   save-back to writable directories. Immutable blobs get "save as
   new" behavior.

3. **Phase 3: Content type inference.** Extension-based language
   mode selection for Monaco (`.js`, `.json`, `.ts`, `.py`, etc.).

4. **Phase 4: Markdown preview.** Synchronized two-panel layout for
   `.md` files, reusing the chat Markdown renderer. Scroll
   synchronization.

The shape is consistent with the maintainer's rollout discipline
across the chat corpus: ship the bones first (Phase 1 plain-text
view); add the next-largest affordance (Phase 2 mutable edit); add
the visible polish (Phase 3 language modes); add the complex
sub-feature last (Phase 4 synchronized split view). See the
[[endo-but-for-bots--llm-designs-chat-view-edit-commands--markdown-synchronized-render-panel]]
section for the synchronized-scroll mechanics that justify Phase 4's
separation, and the
[[endo-but-for-bots--llm-designs-chat-markdown-render--render-mode-toggle-and-phased-rollout]]
section for the parallel four-phase pattern in chat-markdown-render
itself.

Source: [designs/chat-view-edit-commands.md](https://github.com/endojs/endo-but-for-bots/blob/2691e7d52d061c0a10b89864e879188f2d4e11d7/designs/chat-view-edit-commands.md) at commit `2691e7d5`.
