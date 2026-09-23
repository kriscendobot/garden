---
title: "The ordering concern: user intent"
source: designs/chat-pending-commands.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 60a63bc404ce8b28c11021d622c0c65ef1f73e00
source_date: 2026-03-13
source_authors: [Kris Kowal]
topics: [chat-ui]
status: current
notes: |
  The implementation move behind the pending-region UI: change `executeWithSpinner` so the command bar is released immediately after dispatch, and let each pending card own its promise's settlement. This admits multiple concurrent commands. Names the user-intent ordering concern (rename-after-adopt) and explains why the pending region makes it visible.
parent: endo-but-for-bots--llm-designs-chat-pending-commands--unlocking-and-concurrent-commands
---

The one ordering concern that survives is **user intent**. If a user
adopts edge `foo` from message 3 and then renames `foo`, the rename
must happen after adoption completes. The daemon will enforce this
(the rename of a pet name that does not yet exist would fail), but the
user might not understand the failure mode.

The pending region surfaces this concern by making it visible: the
adopt card is still in flight when the rename is typed, so the user
sees that the operation they depend on has not finished. The region
turns the implicit "the daemon will figure out the order" into an
explicit "you can see your earlier command has not finished yet."

Source: [designs/chat-pending-commands.md](https://github.com/endojs/endo-but-for-bots/blob/60a63bc404ce8b28c11021d622c0c65ef1f73e00/designs/chat-pending-commands.md) at commit `60a63bc4`.
