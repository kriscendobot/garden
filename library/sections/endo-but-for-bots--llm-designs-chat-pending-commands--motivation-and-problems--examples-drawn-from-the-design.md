---
title: Examples drawn from the design
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

- `/dismiss 5` — dismiss inbox message 5.
- `/adopt 3 edge name` — adopt edge `edge` from message 3, binding it
  to pet name `name`.
- `/eval` — evaluate an expression in an isolated worker.
- A plain message send — the implicit "send" command from typing in the
  command bar and pressing Enter.

These four shapes have different latency profiles. Dismiss and adopt
are fast (low-millisecond round-trips). Evaluate, request, and send can
take seconds. The same indeterminate-spinner treatment for all of them
amplifies the blocked-input problem for the slow shapes.

Source: [designs/chat-pending-commands.md](https://github.com/endojs/endo-but-for-bots/blob/60a63bc404ce8b28c11021d622c0c65ef1f73e00/designs/chat-pending-commands.md) at commit `60a63bc4`.
