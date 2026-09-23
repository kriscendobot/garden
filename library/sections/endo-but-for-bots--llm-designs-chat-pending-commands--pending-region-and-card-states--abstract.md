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
  The near-term UI solution to the three problems named in the *motivation-and-problems* section: a dedicated region between transcript and command bar holds one card per in-flight command, with success/failure transitions and a value-modal escape hatch.
parent: endo-but-for-bots--llm-designs-chat-pending-commands--pending-region-and-card-states
---

The design adds a visually distinct *pending region* anchored to the
bottom of the transcript, above the command bar and below the message
list. Each in-flight command appears as a compact card showing the
command name, its arguments, a per-card indeterminate progress
indicator, and the time elapsed since submission. When a command
settles, the card transitions to a success or failure state with
distinct affordances: success cards fade out (with a "show result"
button if the command produced a value); failure cards persist until
explicitly dismissed. The region collapses to zero height when empty.

Source: [designs/chat-pending-commands.md](https://github.com/endojs/endo-but-for-bots/blob/60a63bc404ce8b28c11021d622c0c65ef1f73e00/designs/chat-pending-commands.md) at commit `60a63bc4`.
