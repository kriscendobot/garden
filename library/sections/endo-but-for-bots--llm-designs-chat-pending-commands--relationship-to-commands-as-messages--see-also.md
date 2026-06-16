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
  The design's self-positioning. The pending region is a UI-only solution; a sibling design (`daemon-commands-as-messages`) proposes the deeper daemon-side fix that would model commands as self-addressed messages. The pending-region design names the relationship explicitly and frames itself as the near-term solution and as a fallback if the daemon change is deferred. Notable as a worked example of *near-term-UI vs. invasive-daemon-change* dependency framing in this design corpus.
parent: endo-but-for-bots--llm-designs-chat-pending-commands--relationship-to-commands-as-messages
---

- [[endo-but-for-bots--llm-designs-chat-pending-commands--motivation-and-problems]] — the asymmetric-record problem that survives even after the UI fix lands.
- [[endo-but-for-bots--llm-designs-chat-pending-commands--unlocking-and-concurrent-commands]] — the implementation move that is *scoped to three chat-package files* (no daemon changes), enabling the dual-positioning.
- [[endo-but-for-bots--llm-designs-chat-pending-commands--pending-region-and-card-states]] — the UI surface that exists today (after this design lands) and that would gracefully merge into the transcript if commands-as-messages ships.
- [[endo-but-for-bots--llm-designs-chat-command-bar--command-bar-states-and-modeline]] — the command-bar state machine the pending region composes with.

Source: [designs/chat-pending-commands.md](https://github.com/endojs/endo-but-for-bots/blob/60a63bc404ce8b28c11021d622c0c65ef1f73e00/designs/chat-pending-commands.md) at commit `60a63bc4`.
