---
title: "Problem 3: The asymmetric command record"
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

The inbox transcript shows inbound messages, things sent *to* the
user. It does not show outbound commands the user issued. The result
is an asymmetric record: you see what others said to you but not what
you did. This asymmetry is the root cause of Problem 2 and motivates
both the near-term *pending region* fix and the deeper
`daemon-commands-as-messages` alternative (covered separately in this
source's *relationship-to-commands-as-messages* section).

Source: [designs/chat-pending-commands.md](https://github.com/endojs/endo-but-for-bots/blob/60a63bc404ce8b28c11021d622c0c65ef1f73e00/designs/chat-pending-commands.md) at commit `60a63bc4`.
