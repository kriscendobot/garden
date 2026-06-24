---
title: The deeper asymmetry the UI region cannot fix
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

The pending region resolves *blocked input* and surfaces *invisible
commands* during their in-flight phase. What it does not fix is the
**durability** of the command record. Once a card fades out, the
trace is gone. The daemon's `followMessages()` stream carries only
inbound messages; the outbound command (the user's "I dismissed
message 5") was never durable.

This is the same *asymmetric record* problem named in the
*motivation-and-problems* section: you see what others said to you
but not what you did. The pending region treats the in-flight phase;
the asymmetry returns once the cards fade.

Source: [designs/chat-pending-commands.md](https://github.com/endojs/endo-but-for-bots/blob/60a63bc404ce8b28c11021d622c0c65ef1f73e00/designs/chat-pending-commands.md) at commit `60a63bc4`.
