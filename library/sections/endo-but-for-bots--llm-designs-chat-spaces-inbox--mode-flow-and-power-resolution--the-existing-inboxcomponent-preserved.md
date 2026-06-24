---
title: The existing `inboxComponent` (preserved)
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

The chat client already had an inbox component before this design;
nothing about it needed to change:

```js
const inboxComponent = async ($parent, $end, powers) => {
  for await (const message of makeRefIterator(E(powers).followMessages())) {
    // Render message
  }
};
```

The component:

- Follows `followMessages()` from powers (async-iterator subscription).
- Renders each message as it arrives.
- Supports sent / received message styling.
- Handles message interactions (dismiss, token popups, etc.).
