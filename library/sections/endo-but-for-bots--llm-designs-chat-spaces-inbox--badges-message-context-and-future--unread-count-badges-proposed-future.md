---
title: Unread-count badges (proposed, future)
source: designs/chat-spaces-inbox.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 0ee0cbb3c7639985c971c30c2fb6f32e1944d55b
source_date: 2026-02-24
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions]
status: current
parent: endo-but-for-bots--llm-designs-chat-spaces-inbox--badges-message-context-and-future
---

The gutter can display unread message counts on each space-icon
badge. The design sketches the polling implementation:

```js
// In spaces-gutter.js
const updateBadges = async () => {
  for (const space of spaces) {
    try {
      // Resolve powers for this space
      let spacePowers = powers;
      for (const name of space.profilePath) {
        spacePowers = await E(spacePowers).lookup(name);
      }

      // Get unread count (would need daemon support)
      const unreadCount = await E(spacePowers).getUnreadCount();

      const $badge = $container.querySelector(
        `.space-item[data-space-id="${space.id}"] .space-badge`,
      );
      if ($badge) {
        $badge.textContent = String(unreadCount);
        $badge.style.display = unreadCount > 0 ? 'flex' : 'none';
      }
    } catch {
      // Space may not be accessible
    }
  }
};

setInterval(updateBadges, 30000);
```

### Daemon-side requirements (open)

The design names two paths:

| Path | What it needs |
|---|---|
| **Daemon-side counter** | `E(powers).getUnreadCount()` (or similar) on the agent's powers facet. Crosses the no-new-daemon-APIs boundary that the rest of the chat-spaces family preserves. |
| **Client-side tracking** | Track "last seen" timestamp per-space client-side; compute unread by comparing message stream against the per-space last-seen. No daemon change. |

The design does not commit to either. The client-side path
preserves the *client-side convention over a complete daemon API*
discipline; the daemon-side path is cheaper to implement in the
client but requires a new daemon API. The choice is open and
should be made deliberately given the discipline.
