---
title: Dependencies
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

| Design                                                                                                            | Relationship                                                              |
|-------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------|
| [chat-command-bar](https://github.com/endojs/endo-but-for-bots/blob/llm/designs/chat-command-bar.md)              | Command registration and modal dispatch                                   |
| [chat-markdown-render](https://github.com/endojs/endo-but-for-bots/blob/llm/designs/chat-markdown-render.md)      | Markdown rendering pipeline reused for preview                            |
| [chat-focus-message](https://github.com/endojs/endo-but-for-bots/blob/llm/designs/chat-focus-message.md)          | Focus mode shortcut integration                                           |
| [daemon-mount](https://github.com/endojs/endo-but-for-bots/blob/llm/designs/daemon-mount.md)                      | Writable directory entries for `/edit` save                               |
| [daemon-checkin-checkout](https://github.com/endojs/endo-but-for-bots/blob/llm/designs/daemon-checkin-checkout.md) | `ReadableTree` blob access patterns                                       |

The chat-command-bar dependency is unsurprising: every chat slash
command rides on the command-bar's registration and modal-dispatch
machinery. The chat-markdown-render dependency is the load-bearing
piece for Phase 4: without it, the Markdown preview would either
ship a second renderer (creating the styling and security drift the
design explicitly avoids) or omit the preview entirely. The
chat-focus-message dependency provides the framework the `v` and
`e` shortcuts join. The two daemon-side dependencies (daemon-mount
and daemon-checkin-checkout) provide the writable directory entries
the mutable-save path operates on; without them, only immutable
save-as-new would be available.

Of these five, the chat-command-bar and chat-markdown-render designs
are already ingested in the library; chat-focus-message,
daemon-mount, and daemon-checkin-checkout are not yet (and were not
in the cycle 70 ingestion lane). The cross-design dependency graph
the chat-design corpus is building up is its own structural
artifact: the chat client's bones are an explicit composition of
roughly a dozen named designs.

Source: [designs/chat-view-edit-commands.md](https://github.com/endojs/endo-but-for-bots/blob/2691e7d52d061c0a10b89864e879188f2d4e11d7/designs/chat-view-edit-commands.md) at commit `2691e7d5`.
