---
title: Implications for Endo
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

Source: [designs/chat-edit-message-ui.md](https://github.com/endojs/endo-but-for-bots/blob/1d1a0bc78f0ed1b7cbabdbb4551c795276af21fe/designs/chat-edit-message-ui.md) at commit `1d1a0bc7`.
