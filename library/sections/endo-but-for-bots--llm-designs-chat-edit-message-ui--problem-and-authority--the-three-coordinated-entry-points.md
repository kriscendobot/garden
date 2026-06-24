---
title: The three coordinated entry points
source: designs/chat-edit-message-ui.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 1d1a0bc78f0ed1b7cbabdbb4551c795276af21fe
source_date: 2026-05-06
source_authors: [Kris Kowal, Kriscendo Bot]
topics: [chat-ui]
status: current
notes: |
  **Status: Not Started** upstream. Closes a UI parity gap: the daemon
  shipped `editMessage` and `messageHistory` via the streaming-message
  work in `daemon-message-streaming` / endojs/endo-but-for-bots#23, but
  the chat client did not yet surface either capability. Agents driving
  the daemon could call `editMessage`; users driving the chat client
  could not.
parent: endo-but-for-bots--llm-designs-chat-edit-message-ui--problem-and-authority
---

The design ships three entry points that share a single dispatch path
into the body editor:

| Entry | Trigger | Notes |
|---|---|---|
| Slash command | `/edit <referent>` typed in the command bar | Referent is a message number (command-bar form) or an envelope reference (focus mode / hover); reuses the existing message-picker component |
| Focus-mode shortcut | `e` while a focused message is editable | Reads `data-number` from the focused envelope, calls `enterCommandMode('edit', { referent })`, lets the inline form take over; no-op when not editable |
| Hover button | Pencil button in the affordance row of a hovered editable envelope | Click invokes the same dispatch path as `e`; keyboard-reachable through normal Tab order; always visible on touch platforms (no hover) |

All three converge on the **inline command form** in
[[endo-but-for-bots--llm-designs-chat-command-bar--command-bar-states-and-modeline]]:
once the referent resolves, the inline form opens a body editor reusing
`send-form.js` so embedded `@petName` tokens (see [[token-chip]]) work
exactly as in a fresh send. The body field is pre-populated with the
current message's payload (Markdown text plus token chips for any
embedded references the original carried). Pressing `Enter` calls
`E(currentProfile).editMessage(number, payload, { done: true })` with
the rebuilt payload.

The new body is not a separate slash-command argument — `/edit` takes
only the referent, and the body editor is the next form step. The
referent field reuses the existing message-picker component (see
[[endo-but-for-bots--llm-designs-chat-components--inventory-and-messages]]).

The focus shortcut `e` is unused by `/edit`'s siblings in
[[endo-but-for-bots--llm-designs-chat-view-edit-commands]], which
proposes binding `e` to the blob editor *only when the focused value
resolves to a blob*. The two shortcuts are disambiguated by *what the
focus is on*: a message envelope versus a blob value chip inside that
message. The blob-editor binding fires only when the focus is on a
value, not on a message envelope. A future design that introduces a
third `e`-eligible focus target would need to extend the
disambiguation rule the same way.

Source: [designs/chat-edit-message-ui.md](https://github.com/endojs/endo-but-for-bots/blob/1d1a0bc78f0ed1b7cbabdbb4551c795276af21fe/designs/chat-edit-message-ui.md) at commit `1d1a0bc7`.
