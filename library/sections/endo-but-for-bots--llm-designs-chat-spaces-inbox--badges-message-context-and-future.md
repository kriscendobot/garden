---
title: Unread-count badges, in-space message context, and future enhancements
source: designs/chat-spaces-inbox.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 0ee0cbb3c7639985c971c30c2fb6f32e1944d55b
source_date: 2026-02-24
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions]
status: current
---

## Unread-count badges (proposed, future)

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

## In-space message context

When a user is *in* a space, the chat-bar context shifts:

| Affordance | Behavior |
|---|---|
| **Profile path** | Shown in breadcrumbs (already implemented; see [[endo-but-for-bots--llm-designs-chat-components--profile-system-and-error-handling]]). |
| **Send target** | Defaults to the space's agent. |
| **Available commands** | Scoped to the space's capabilities. |

The send-target default is a worked example of the
[[endo-but-for-bots--llm-designs-chat-invariants--principles]]
*progressive disclosure* principle: simple operations stay simple.
A user in a space can send a message with `text + Enter` (no need
to type `@space-agent message`) because the recipient is already
implicit in the current context.

The *available-commands* scoping is the chat-bar manifestation of
the daemon's capability-confinement model: an agent only has the
commands its powers grant; the chat bar surfaces exactly those.

## Future enhancements (four items)

The design records four roadmap items:

| # | Item | Notes |
|---|---|---|
| 1 | **Unread badges** | The proposed implementation above; daemon-vs-client tradeoff still open. |
| 2 | **Last message preview** | Show snippet on hover. Pure-client; no daemon change needed. |
| 3 | **Notification sounds** | When a new message arrives in an *inactive* space. Pure-client. |
| 4 | **Quick reply** | Type message without full navigation. Probably composes with the existing send-form; no new daemon API needed. |

Three of the four are pure-client; one (badges) crosses the
daemon-API boundary. Future cycles ingesting the implementations of
any of these will report on whether the API discipline held.

## Testing

The design's test plan is five end-to-end scenarios:

1. **Add a space** pointing to a guest (e.g., `['fae']`).
2. **Click the space** — should navigate to that guest's inbox.
3. **Verify messages** — should show that guest's message history.
4. **Send a message** — should be sent to that guest.
5. **Cmd+N shortcut** — should switch to the Nth space's inbox.

Note that step 5 uses **Cmd+N**, which is consistent with the
source's `Cmd+1..9` handler (Cmd+1 = home, Cmd+2..9 = user spaces;
see cycle-58 investigation in
[[endo-but-for-bots--llm-designs-chat-spaces-gutter--interactions-keyboard-and-future]]).
This design predates the chat-spaces-home aspirational `Cmd+0`
table; the test uses the current source-of-truth numbering.
