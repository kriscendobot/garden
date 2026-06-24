---
title: See also
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

- [[endo-but-for-bots--llm-designs-chat-view-edit-commands--commands-viewer-editor-and-panel-layout]] — the surface the design decisions justify.
- [[endo-but-for-bots--llm-designs-chat-view-edit-commands--markdown-synchronized-render-panel]] — Phase 4 and the synchronized-scroll mechanics that justify its separation.
- [[endo-but-for-bots--llm-designs-chat-markdown-render--render-mode-toggle-and-phased-rollout]] — the parallel four-phase rollout in chat-markdown-render; same maintainer discipline of phased complexity.
- [[endo-but-for-bots--llm-designs-chat-invariants--overview-and-six-invariants]] — the six MUST-hold UI invariants the modal-overlay and predictable-content-type decisions honor.
- [[endo-but-for-bots--llm-designs-chat-color-schemes--implementation-and-monaco-bridge]] — the Monaco bridge the editor's Monaco instance honors for theming.
- [[endo-but-for-bots--llm-designs-chat-edit-message-ui--open-questions]] — the named collision over the `/edit` slash command between this design and the chat-edit-message-ui sibling.

Source: [designs/chat-view-edit-commands.md](https://github.com/endojs/endo-but-for-bots/blob/2691e7d52d061c0a10b89864e879188f2d4e11d7/designs/chat-view-edit-commands.md) at commit `2691e7d5`.
