---
title: Abstract
source: designs/chat-pending-commands.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 60a63bc404ce8b28c11021d622c0c65ef1f73e00
source_date: 2026-03-13
source_authors: [Kris Kowal]
topics: [chat-ui]
status: current
notes: |
  **Status: Not Started** upstream. Names two concrete chat-UX problems
  the indeterminate spinner causes (blocked input, no command history)
  and a third deeper *asymmetric record* problem (the inbox transcript
  shows inbound messages only; outbound commands are invisible).
parent: endo-but-for-bots--llm-designs-chat-pending-commands--motivation-and-problems
---

When the user issues a chat command (`/dismiss 5`, `/adopt 3 edge name`,
`/eval`, or a plain message send), the current chat client replaces the
send button with an indeterminate spinner and locks the entire command
bar (`contentEditable = false`, `pointer-events: none`, `opacity: 0.5`)
until the daemon promise settles. This creates two surface UX problems
(*blocked input* and *no command history*) and surfaces a deeper
*asymmetric record* problem: the inbox transcript shows what others said
to you, not what you did. This section catalogs the three problems the
`chat-pending-commands` design is targeted at.

Source: [designs/chat-pending-commands.md](https://github.com/endojs/endo-but-for-bots/blob/60a63bc404ce8b28c11021d622c0c65ef1f73e00/designs/chat-pending-commands.md) at commit `60a63bc4`.
