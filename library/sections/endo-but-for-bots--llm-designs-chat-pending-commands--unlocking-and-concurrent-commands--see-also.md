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
  The implementation move behind the pending-region UI: change `executeWithSpinner` so the command bar is released immediately after dispatch, and let each pending card own its promise's settlement. This admits multiple concurrent commands. Names the user-intent ordering concern (rename-after-adopt) and explains why the pending region makes it visible.
parent: endo-but-for-bots--llm-designs-chat-pending-commands--unlocking-and-concurrent-commands
---

- [[endo-but-for-bots--llm-designs-chat-pending-commands--motivation-and-problems]] — the *blocked input* problem this change solves directly.
- [[endo-but-for-bots--llm-designs-chat-pending-commands--pending-region-and-card-states]] — what the cards look like and how they settle.
- [[endo-but-for-bots--llm-designs-chat-pending-commands--relationship-to-commands-as-messages]] — the deeper daemon-side alternative; the UI-only scoping here is what leaves the daemon-side question open.
- [[endo-but-for-bots--llm-designs-chat-edit-message-ui--in-flight-and-revision-history]] — sibling chat-design that reuses the indeterminate-progress affordance for in-flight edits; the two designs share a UI shape for in-flight operations.

Source: [designs/chat-pending-commands.md](https://github.com/endojs/endo-but-for-bots/blob/60a63bc404ce8b28c11021d622c0c65ef1f73e00/designs/chat-pending-commands.md) at commit `60a63bc4`.
