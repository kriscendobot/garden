---
title: Per-space power resolution
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
