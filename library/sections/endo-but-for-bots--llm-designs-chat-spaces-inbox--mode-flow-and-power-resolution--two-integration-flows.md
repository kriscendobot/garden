---
title: Two integration flows
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

### Space-selection flow

```
User clicks space icon
  → spacesGutter.selectSpace(id)
    → onNavigate(space.profilePath)
      → bodyComponent.onProfileChange(newPath)
        → rebuild()
          → resolvePowers() with new path
            → inboxComponent with agent's powers
```

The chain crosses three components — the gutter (cycle-56),
`bodyComponent` (cycle-55), and the inbox (this design) — each
handing off via callbacks (`onNavigate`, `onProfileChange`) rather
than shared state. The flow's locality is what makes the
multi-agent context-switch cheap.

### Messaging flow

```
User types message in chat bar
  → sendFormComponent with resolved powers
    → E(powers).send(message)
      → Agent receives message
        → Agent responds
          → inboxComponent receives via followMessages()
```

The same powers object that resolves the inbox also resolves the
send target. *Sending* and *receiving* go through the same agent
because they go through the same `powers` reference.
