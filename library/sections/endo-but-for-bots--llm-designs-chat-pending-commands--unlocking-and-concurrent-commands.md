---
title: Unlocking the command bar and admitting concurrent commands
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
kind: index
section_count: 7
---

Sections:

- [Abstract](endo-but-for-bots--llm-designs-chat-pending-commands--unlocking-and-concurrent-commands--abstract.md)
- [The current shape (gates everything on one promise)](endo-but-for-bots--llm-designs-chat-pending-commands--unlocking-and-concurrent-commands--the-current-shape-gates-everything-on-one-promise.md)
- [The change (dispatch then release; per-card promise)](endo-but-for-bots--llm-designs-chat-pending-commands--unlocking-and-concurrent-commands--the-change-dispatch-then-release-per-card-promise.md)
- [Multiple concurrent commands](endo-but-for-bots--llm-designs-chat-pending-commands--unlocking-and-concurrent-commands--multiple-concurrent-commands.md)
- [The ordering concern: user intent](endo-but-for-bots--llm-designs-chat-pending-commands--unlocking-and-concurrent-commands--the-ordering-concern-user-intent.md)
- [Affected files (from the design's appendix)](endo-but-for-bots--llm-designs-chat-pending-commands--unlocking-and-concurrent-commands--affected-files-from-the-design-s-appendix.md)
- [See also](endo-but-for-bots--llm-designs-chat-pending-commands--unlocking-and-concurrent-commands--see-also.md)

Source: [designs/chat-pending-commands.md](https://github.com/endojs/endo-but-for-bots/blob/60a63bc404ce8b28c11021d622c0c65ef1f73e00/designs/chat-pending-commands.md) at commit `60a63bc4`.
