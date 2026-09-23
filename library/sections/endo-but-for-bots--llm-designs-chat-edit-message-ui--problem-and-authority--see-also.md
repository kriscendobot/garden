---
title: See also
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

- [[endo-but-for-bots--llm-designs-chat-command-bar--command-bar-states-and-modeline]] — the inline command form `/edit` registers with.
- [[endo-but-for-bots--llm-designs-chat-invariants--overview-and-six-invariants]] — the keyboard-manual parity and modeline-completeness invariants this design honors.
- [[token-chip]] — the chip mechanism the edit form reuses; chip-bearing edit fields work the same as fresh-send fields.

Source: [designs/chat-edit-message-ui.md](https://github.com/endojs/endo-but-for-bots/blob/1d1a0bc78f0ed1b7cbabdbb4551c795276af21fe/designs/chat-edit-message-ui.md) at commit `1d1a0bc7`.
