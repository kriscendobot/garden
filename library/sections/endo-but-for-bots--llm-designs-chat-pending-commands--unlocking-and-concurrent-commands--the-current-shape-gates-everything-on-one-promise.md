---
title: The current shape (gates everything on one promise)
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

```js
setCommandSubmitting(true);
try {
  const result = await executor.execute(commandName, data);
  // ...
} finally {
  setCommandSubmitting(false);
}
```

`setCommandSubmitting(true)` is what locks the bar
(`contentEditable = false`, `pointer-events: none`, `opacity: 0.5`,
spinner replaces send button). The `finally` releases the lock only
after the promise settles. The entire UI is held by one in-flight
operation.

Source: [designs/chat-pending-commands.md](https://github.com/endojs/endo-but-for-bots/blob/60a63bc404ce8b28c11021d622c0c65ef1f73e00/designs/chat-pending-commands.md) at commit `60a63bc4`.
