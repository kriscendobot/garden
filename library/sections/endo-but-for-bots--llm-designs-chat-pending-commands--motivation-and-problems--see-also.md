---
title: See also
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

- [[endo-but-for-bots--llm-designs-chat-pending-commands--pending-region-and-card-states]] — the design's near-term solution: a dedicated pending-region UI between transcript and command bar.
- [[endo-but-for-bots--llm-designs-chat-pending-commands--unlocking-and-concurrent-commands]] — the implementation change that releases the command bar immediately and admits multiple concurrent commands.
- [[endo-but-for-bots--llm-designs-chat-pending-commands--relationship-to-commands-as-messages]] — the deeper daemon-side alternative (modeling commands as self-addressed messages) that would subsume this UI-only fix.
- [[endo-but-for-bots--llm-designs-chat-command-bar--command-bar-states-and-modeline]] — the command-bar state machine; `executeWithSpinner` is the gate this design opens.

Source: [designs/chat-pending-commands.md](https://github.com/endojs/endo-but-for-bots/blob/60a63bc404ce8b28c11021d622c0c65ef1f73e00/designs/chat-pending-commands.md) at commit `60a63bc4`.
