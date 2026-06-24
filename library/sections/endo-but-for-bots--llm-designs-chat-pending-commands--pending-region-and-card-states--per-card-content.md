---
title: Per-card content
source: designs/chat-pending-commands.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 60a63bc404ce8b28c11021d622c0c65ef1f73e00
source_date: 2026-03-13
source_authors: [Kris Kowal]
topics: [chat-ui]
status: current
notes: |
  The near-term UI solution to the three problems named in the *motivation-and-problems* section: a dedicated region between transcript and command bar holds one card per in-flight command, with success/failure transitions and a value-modal escape hatch.
parent: endo-but-for-bots--llm-designs-chat-pending-commands--pending-region-and-card-states
---

Each card shows:

- The command name and its arguments (e.g., `dismiss #5`,
  `adopt #3:edge → myname`, `eval …`).
- An indeterminate progress indicator *per card* (not on the send
  button as today).
- The time elapsed since submission.

The progress indicator's *location* is the load-bearing change. Today's
spinner is on the send button, which is part of the command bar; the
new spinner is on the pending card, which is below the bar. Moving the
spinner moves the gate: the user is gated on cards (which can be many)
rather than on the bar (which is one).

Source: [designs/chat-pending-commands.md](https://github.com/endojs/endo-but-for-bots/blob/60a63bc404ce8b28c11021d622c0c65ef1f73e00/designs/chat-pending-commands.md) at commit `60a63bc4`.
