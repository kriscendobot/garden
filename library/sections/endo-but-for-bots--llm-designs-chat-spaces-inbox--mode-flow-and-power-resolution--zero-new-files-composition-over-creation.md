---
title: Zero new files — composition over creation
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

The design's *Files* section is one of the shortest in the chat
cluster:

```
This mode uses existing components:
- packages/chat/src/chat.js          (inboxComponent, bodyComponent)
- packages/chat/src/send-form.js     (Message sending)
- packages/chat/src/ref-iterator.js  (Message iteration)

No additional files needed for basic inbox mode.
```

The inbox mode is **pure composition**: existing power-resolution
machinery + existing inboxComponent + the space's profilePath = the
feature. This is the same *client-side convention over a complete
daemon API* shape that
[[endo-but-for-bots--llm-designs-chat-spaces-gutter--motivation-and-architecture]]
identified for spaces themselves, applied one level deeper —
spaces ride on existing pet-store primitives; inbox-mode rides on
existing chat-client components.

Two adjacent observations:

1. **The mode field is a discriminator over already-existing
   behaviors.** `mode: 'inbox'` doesn't add anything; it *selects*
   among the chat client's already-built display modes. Future
   modes (`'conversations'`, `'channels'`) will do the same.
2. **No daemon changes needed.** The same `followMessages` and
   `send` operations work for any agent the powers object resolves
   to — the daemon doesn't know it's serving a "space inbox" vs
   any other inbox view.
