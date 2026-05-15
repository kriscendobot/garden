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
---

## The mode field's job

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

## The existing `inboxComponent` (preserved)

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

## Per-space power resolution

When a space is selected, the chat's `bodyComponent` walks the
`profilePath` through the daemon's name resolution to get the
target agent's powers:

```js
const resolvePowers = async () => {
  let powers = rootPowers;
  for (const name of profilePath) {
    powers = E(powers).lookup(name);
  }
  return powers;
};

// When profile changes, rebuild triggers new inboxComponent
resolvePowers().then(resolvedPowers => {
  inboxComponent($messages, $anchor, resolvedPowers);
});
```

The same `inboxComponent` runs with *different powers* per space —
no per-space inbox component is needed. The agent's perspective is
established by the powers object the component is handed, not by
any state the component itself carries.

This is the chat-UI counterpart of the *profile-as-current-"I"*
discipline from
[[endo-but-for-bots--llm-designs-chat-components--profile-system-and-error-handling]]:
the inventory and the inbox both swap when the profile path swaps,
because both consume the same powers object.

## Two integration flows

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

## Zero new files — composition over creation

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
