---
title: Modeline updates
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

Source: [designs/chat-edit-message-ui.md](https://github.com/endojs/endo-but-for-bots/blob/1d1a0bc78f0ed1b7cbabdbb4551c795276af21fe/designs/chat-edit-message-ui.md) at commit `1d1a0bc7`.
