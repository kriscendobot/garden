---
title: The pending-commands region, per-card progress, and card-state transitions
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
kind: index
section_count: 7
---

Sections:

- [Abstract](endo-but-for-bots--llm-designs-chat-pending-commands--pending-region-and-card-states--abstract.md)
- [Per-card content](endo-but-for-bots--llm-designs-chat-pending-commands--pending-region-and-card-states--per-card-content.md)
- [Settled-card state transitions](endo-but-for-bots--llm-designs-chat-pending-commands--pending-region-and-card-states--settled-card-state-transitions.md)
- [Visual sketch (from the design)](endo-but-for-bots--llm-designs-chat-pending-commands--pending-region-and-card-states--visual-sketch-from-the-design.md)
- [Empty-state collapse](endo-but-for-bots--llm-designs-chat-pending-commands--pending-region-and-card-states--empty-state-collapse.md)
- [Affordance for produced values](endo-but-for-bots--llm-designs-chat-pending-commands--pending-region-and-card-states--affordance-for-produced-values.md)
- [See also](endo-but-for-bots--llm-designs-chat-pending-commands--pending-region-and-card-states--see-also.md)

Source: [designs/chat-pending-commands.md](https://github.com/endojs/endo-but-for-bots/blob/60a63bc404ce8b28c11021d622c0c65ef1f73e00/designs/chat-pending-commands.md) at commit `60a63bc4`.
