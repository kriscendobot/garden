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
  The near-term UI solution to the three problems named in the *motivation-and-problems* section: a dedicated region between transcript and command bar holds one card per in-flight command, with success/failure transitions and a value-modal escape hatch.
parent: endo-but-for-bots--llm-designs-chat-pending-commands--pending-region-and-card-states
---

- [[endo-but-for-bots--llm-designs-chat-pending-commands--motivation-and-problems]] — the three problems this region targets.
- [[endo-but-for-bots--llm-designs-chat-pending-commands--unlocking-and-concurrent-commands]] — the implementation change behind the cards: dispatch then release the bar; each card holds its own promise.
- [[endo-but-for-bots--llm-designs-chat-command-bar--value-modal-and-states]] — the value modal the "show result" affordance opens.
- [[endo-but-for-bots--llm-designs-chat-command-bar--command-bar-states-and-modeline]] — the command-bar state machine the pending region composes with.

Source: [designs/chat-pending-commands.md](https://github.com/endojs/endo-but-for-bots/blob/60a63bc404ce8b28c11021d622c0c65ef1f73e00/designs/chat-pending-commands.md) at commit `60a63bc4`.
