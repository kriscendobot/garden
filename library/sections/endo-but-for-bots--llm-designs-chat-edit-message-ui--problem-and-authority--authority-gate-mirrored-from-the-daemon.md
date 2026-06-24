---
title: Authority gate (mirrored from the daemon)
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

Source: [designs/chat-edit-message-ui.md](https://github.com/endojs/endo-but-for-bots/blob/1d1a0bc78f0ed1b7cbabdbb4551c795276af21fe/designs/chat-edit-message-ui.md) at commit `1d1a0bc7`.
