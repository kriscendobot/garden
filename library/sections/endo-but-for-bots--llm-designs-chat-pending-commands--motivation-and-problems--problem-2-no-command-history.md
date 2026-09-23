---
title: "Problem 2: No command history"
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

Once a command completes, the spinner disappears and the command bar
resets. There is no visible record of what the user did or when:

- The only trace is the side effect in the inbox (a dismissed message
  disappears, an adopted value appears in the pet store).
- If the command fails, an error flash appears briefly and is gone.

The user has no way to scroll back through their own command stream.

Source: [designs/chat-pending-commands.md](https://github.com/endojs/endo-but-for-bots/blob/60a63bc404ce8b28c11021d622c0c65ef1f73e00/designs/chat-pending-commands.md) at commit `60a63bc4`.
