---
title: Empty-state collapse
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

The pending region collapses to zero height when empty. The user does
not see a permanent empty band between transcript and command bar; the
region appears only when there is something in it. This keeps the
transcript-to-command-bar transition visually unchanged for the common
case where no commands are pending.

Source: [designs/chat-pending-commands.md](https://github.com/endojs/endo-but-for-bots/blob/60a63bc404ce8b28c11021d622c0c65ef1f73e00/designs/chat-pending-commands.md) at commit `60a63bc4`.
