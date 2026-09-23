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
kind: index
section_count: 5
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

Sections:

- [Authority gate (mirrored from the daemon)](endo-but-for-bots--llm-designs-chat-edit-message-ui--problem-and-authority--authority-gate-mirrored-from-the-daemon.md)
- [The three coordinated entry points](endo-but-for-bots--llm-designs-chat-edit-message-ui--problem-and-authority--the-three-coordinated-entry-points.md)
- [Modeline updates](endo-but-for-bots--llm-designs-chat-edit-message-ui--problem-and-authority--modeline-updates.md)
- [Implications for Endo](endo-but-for-bots--llm-designs-chat-edit-message-ui--problem-and-authority--implications-for-endo.md)
- [See also](endo-but-for-bots--llm-designs-chat-edit-message-ui--problem-and-authority--see-also.md)

Source: [designs/chat-edit-message-ui.md](https://github.com/endojs/endo-but-for-bots/blob/1d1a0bc78f0ed1b7cbabdbb4551c795276af21fe/designs/chat-edit-message-ui.md) at commit `1d1a0bc7`.
