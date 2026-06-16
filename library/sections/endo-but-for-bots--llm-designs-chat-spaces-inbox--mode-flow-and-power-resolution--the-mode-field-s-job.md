---
title: The mode field's job
source: designs/chat-spaces-inbox.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 0ee0cbb3c7639985c971c30c2fb6f32e1944d55b
source_date: 2026-02-24
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions]
status: current
notes: **Status: Complete** upstream. Third in the chat-spaces family (after gutter and home); completes the trio. The structurally interesting property: **zero new files** — the inbox mode just composes existing components (`inboxComponent`, `bodyComponent`, `sendFormComponent`, `resolvePowers`) with the space's `profilePath`. Same *client-side convention over a complete daemon API* discipline that chat-spaces-gutter established.
parent: endo-but-for-bots--llm-designs-chat-spaces-inbox--mode-flow-and-power-resolution
---

When a space is configured with `mode: 'inbox'` (the only value
supported as of this design), selecting that space does three
things:

1. **Navigates** to the space's `profilePath`.
2. **Displays** the inbox for that profile in the main content area.
3. **Enables** messaging to/from that agent.

The design future-proofs the mode field with reserved values
`'conversations'` and `'channels'` (per
[[endo-but-for-bots--llm-designs-chat-spaces-gutter--space-model-and-persistence]]),
but only `'inbox'` ships in this iteration.
