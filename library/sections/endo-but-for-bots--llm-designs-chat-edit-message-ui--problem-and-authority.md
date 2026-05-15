---
title: Problem, authority gate, and the three coordinated entry points
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
---

The daemon's `editMessage` and `messageHistory` methods (delivered by
[[endo-but-for-bots--llm-designs-daemon-message-streaming]] and
implemented in `endojs/endo-but-for-bots#23`) let any sender, human or
LLM, replace the interior of a message they previously sent and let any
recipient inspect the revision history. The chat UI did not surface
either. A user who noticed a typo had to dismiss and resend, which
broke the reply-to chain and the recipient's dismissal state. Agents
implemented as guests of the local user could call `editMessage`
through the daemon, but the user driving the chat client was denied the
same affordance. This design closes the gap with three coordinated
entry points (keybinding, hover button, slash command) that compose
with the existing focus-mode and command-bar conventions.

## Authority gate (mirrored from the daemon)

Edit affordances are visible only on messages whose `sender` matches
the current profile. The daemon enforces sender-only edit authority;
the UI mirrors that check so the affordance is not even offered for
messages the user could not edit. The mirror is *defensive
redundancy*: the daemon would refuse a forged `editMessage` call
regardless, but hiding the entry points keeps the affordance honest
about what it can do.

The same gate suppresses the affordance for a not-done message produced
by the local user (rare but possible when the user is driving an agent
that streams). The streaming sender owns the message during the
streaming session, and manual edits during a stream race the agent's
own edits. The button and shortcut are hidden until the message
settles (`done: true`).

## The three coordinated entry points

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

## Modeline updates

The send-mode modeline gains no new entries (edit is reachable only
through focus mode or hover). The focus-mode modeline appends `e` to
the shortcut row, conditional on the focused message being editable by
the current user:

```
<kbd>r</kbd> reply  <kbd>d</kbd> dismiss  <kbd>a</kbd> adopt  <kbd>g</kbd> grant  <kbd>s</kbd> submit  <kbd>e</kbd> edit  <kbd>Esc</kbd> back
```

The inline-command-form modeline for `/edit` matches the existing
form-mode modeline pattern (`Enter submit · Tab next field · Esc
cancel`). The visibility-conditional shortcut respects the *modeline
completeness* invariant from
[[endo-but-for-bots--llm-designs-chat-invariants--overview-and-six-invariants]]:
the modeline shows exactly the shortcuts that are currently armed, no
more and no less. Hiding `e` when it would no-op keeps the modeline
honest.

## Implications for Endo

The design exemplifies a recurring chat-UI shape that has appeared in
several sibling designs: a single daemon-side capability surfaced
through *multiple coordinated UI entry points* that all converge on one
dispatch path. Slash-command + focus-shortcut + hover-button is the
canonical trio (mirrored in the dismiss / adopt / grant / submit
shortcuts already in focus mode). The pattern lets each input modality
(typing, keyboarding, mousing/touching) reach the same operation
without each modality needing its own implementation of the operation
itself. The chat's *keyboard-manual parity* invariant (see chat-invariants)
is the broader principle; this design is one concrete instance of it.

## See also

- [[endo-but-for-bots--llm-designs-chat-command-bar--command-bar-states-and-modeline]] — the inline command form `/edit` registers with.
- [[endo-but-for-bots--llm-designs-chat-invariants--overview-and-six-invariants]] — the keyboard-manual parity and modeline-completeness invariants this design honors.
- [[token-chip]] — the chip mechanism the edit form reuses; chip-bearing edit fields work the same as fresh-send fields.

Source: [designs/chat-edit-message-ui.md](https://github.com/endojs/endo-but-for-bots/blob/1d1a0bc78f0ed1b7cbabdbb4551c795276af21fe/designs/chat-edit-message-ui.md) at commit `1d1a0bc7`.
