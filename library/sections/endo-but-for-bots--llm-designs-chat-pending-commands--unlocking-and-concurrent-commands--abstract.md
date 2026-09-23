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
  The implementation move behind the pending-region UI: change `executeWithSpinner` so the command bar is released immediately after dispatch, and let each pending card own its promise's settlement. This admits multiple concurrent commands. Names the user-intent ordering concern (rename-after-adopt) and explains why the pending region makes it visible.
parent: endo-but-for-bots--llm-designs-chat-pending-commands--unlocking-and-concurrent-commands
---

Today `executeWithSpinner` in `chat-bar-component.js` gates the entire
UI on the command's returned promise: `setCommandSubmitting(true)` /
`await` / `setCommandSubmitting(false)` in a try/finally. The design's
implementation move is small and load-bearing: dispatch the command,
push a pending entry into the pending-commands region, and immediately
release the command bar. The pending entry holds the promise and
updates its own UI on settle. This unlocks the bar mid-flight and
admits multiple concurrent commands; the only ordering concern is the
user's own intent (e.g., rename-after-adopt), which the pending region
makes visible by showing what is still in flight.

Source: [designs/chat-pending-commands.md](https://github.com/endojs/endo-but-for-bots/blob/60a63bc404ce8b28c11021d622c0c65ef1f73e00/designs/chat-pending-commands.md) at commit `60a63bc4`.
