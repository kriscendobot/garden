---
title: Unlocking the command bar and admitting concurrent commands
source: designs/chat-pending-commands.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 60a63bc404ce8b28c11021d622c0c65ef1f73e00
source_date: 2026-03-13
source_authors: [Kris Kowal]
topics: [chat-ui]
status: current
notes: |
  The implementation move behind the pending-region UI: change `executeWithSpinner` so the command bar is released immediately after dispatch, and let each pending card own its promise's settlement. This admits multiple concurrent commands. Names the user-intent ordering concern (rename-after-adopt) and explains why the pending region makes it visible.
---

## Abstract

Today `executeWithSpinner` in `chat-bar-component.js` gates the entire
UI on the command's returned promise: `setCommandSubmitting(true)` /
`await` / `setCommandSubmitting(false)` in a try/finally. The design's
implementation move is small and load-bearing: dispatch the command,
push a pending entry into the pending-commands region, and immediately
release the command bar. The pending entry holds the promise and
updates its own UI on settle. This unlocks the bar mid-flight and
admits multiple concurrent commands; the only ordering concern is the
user's own intent (e.g., rename-after-adopt), which the pending region
makes visible by showing what is still in flight.

## The current shape (gates everything on one promise)

```js
setCommandSubmitting(true);
try {
  const result = await executor.execute(commandName, data);
  // ...
} finally {
  setCommandSubmitting(false);
}
```

`setCommandSubmitting(true)` is what locks the bar
(`contentEditable = false`, `pointer-events: none`, `opacity: 0.5`,
spinner replaces send button). The `finally` releases the lock only
after the promise settles. The entire UI is held by one in-flight
operation.

## The change (dispatch then release; per-card promise)

```js
const pending = pendingRegion.add(commandName, data);
executor.execute(commandName, data).then(
  result => pending.resolve(result),
  error => pending.reject(error),
);
exitCommandMode(); // Immediately
```

The shape:

1. `pendingRegion.add(commandName, data)` creates the card and returns
   a handle.
2. `executor.execute(commandName, data)` is fired but **not awaited**.
3. `.then(result => pending.resolve, error => pending.reject)` routes
   settlement to the card.
4. `exitCommandMode()` runs synchronously; the bar is released and the
   user can type the next command.

The card holds the promise; the bar does not. The user is decoupled
from each individual operation's latency.

## Multiple concurrent commands

Each dispatched command gets its own card. Commands are independent
daemon operations: the daemon already handles concurrent `E()` calls
correctly. The design names the relevant operations:

- `dismiss`, `adopt`, and `resolve` operate on different message
  numbers and do not interfere.
- `evaluate` runs in an isolated worker.

The daemon side is already concurrency-safe; the change here is purely
UI.

## The ordering concern: user intent

The one ordering concern that survives is **user intent**. If a user
adopts edge `foo` from message 3 and then renames `foo`, the rename
must happen after adoption completes. The daemon will enforce this
(the rename of a pet name that does not yet exist would fail), but the
user might not understand the failure mode.

The pending region surfaces this concern by making it visible: the
adopt card is still in flight when the rename is typed, so the user
sees that the operation they depend on has not finished. The region
turns the implicit "the daemon will figure out the order" into an
explicit "you can see your earlier command has not finished yet."

## Affected files (from the design's appendix)

| File | Change |
|---|---|
| `packages/chat/chat-bar-component.js` | Remove `setSubmitting` gating; dispatch to pending region instead |
| `packages/chat/pending-commands.js` (new) | Pending commands region component |
| `packages/chat/chat.css` | Styles for pending cards, transitions |

The change is **scoped to three files**, one of them new. No daemon
changes are required for this near-term solution; that is the design's
load-bearing scoping move, and is also what enables the *Relationship
to Commands as Messages* discussion (see sibling section).

## See also

- [[endo-but-for-bots--llm-designs-chat-pending-commands--motivation-and-problems]] — the *blocked input* problem this change solves directly.
- [[endo-but-for-bots--llm-designs-chat-pending-commands--pending-region-and-card-states]] — what the cards look like and how they settle.
- [[endo-but-for-bots--llm-designs-chat-pending-commands--relationship-to-commands-as-messages]] — the deeper daemon-side alternative; the UI-only scoping here is what leaves the daemon-side question open.
- [[endo-but-for-bots--llm-designs-chat-edit-message-ui--in-flight-and-revision-history]] — sibling chat-design that reuses the indeterminate-progress affordance for in-flight edits; the two designs share a UI shape for in-flight operations.

Source: [designs/chat-pending-commands.md](https://github.com/endojs/endo-but-for-bots/blob/60a63bc404ce8b28c11021d622c0c65ef1f73e00/designs/chat-pending-commands.md) at commit `60a63bc4`.
