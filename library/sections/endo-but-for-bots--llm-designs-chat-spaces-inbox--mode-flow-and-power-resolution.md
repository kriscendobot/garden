---
title: Inbox-mode flow, power resolution, and the "no additional files" composition
source: designs/chat-spaces-inbox.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 0ee0cbb3c7639985c971c30c2fb6f32e1944d55b
source_date: 2026-02-24
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions]
status: current
notes: **Status: Complete** upstream. Third in the chat-spaces family (after gutter and home); completes the trio. The structurally interesting property: **zero new files** — the inbox mode just composes existing components (`inboxComponent`, `bodyComponent`, `sendFormComponent`, `resolvePowers`) with the space's `profilePath`. Same *client-side convention over a complete daemon API* discipline that chat-spaces-gutter established.
kind: index
section_count: 5
---

Sections:

- [The mode field's job](endo-but-for-bots--llm-designs-chat-spaces-inbox--mode-flow-and-power-resolution--the-mode-field-s-job.md)
- [The existing `inboxComponent` (preserved)](endo-but-for-bots--llm-designs-chat-spaces-inbox--mode-flow-and-power-resolution--the-existing-inboxcomponent-preserved.md)
- [Per-space power resolution](endo-but-for-bots--llm-designs-chat-spaces-inbox--mode-flow-and-power-resolution--per-space-power-resolution.md)
- [Two integration flows](endo-but-for-bots--llm-designs-chat-spaces-inbox--mode-flow-and-power-resolution--two-integration-flows.md)
- [Zero new files — composition over creation](endo-but-for-bots--llm-designs-chat-spaces-inbox--mode-flow-and-power-resolution--zero-new-files-composition-over-creation.md)
