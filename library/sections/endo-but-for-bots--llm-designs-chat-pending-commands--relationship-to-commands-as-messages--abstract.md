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
  The design's self-positioning. The pending region is a UI-only solution; a sibling design (`daemon-commands-as-messages`) proposes the deeper daemon-side fix that would model commands as self-addressed messages. The pending-region design names the relationship explicitly and frames itself as the near-term solution and as a fallback if the daemon change is deferred. Notable as a worked example of *near-term-UI vs. invasive-daemon-change* dependency framing in this design corpus.
parent: endo-but-for-bots--llm-designs-chat-pending-commands--relationship-to-commands-as-messages
---

The pending region is a UI-only solution. It solves the immediate UX
problems (blocked input, invisible commands) without daemon changes,
but leaves a deeper asymmetry intact: the daemon's transcript
(`followMessages()`) records only inbound messages; outbound commands
are promises that settle and vanish. The sibling `daemon-commands-as-
messages` design proposes the deeper fix (model commands as
self-addressed messages, results as reply messages). If implemented,
that design would subsume the pending region. This design positions
itself explicitly as the near-term solution *and* as a fallback if
the daemon change is deferred — a dual role that is itself an
exemplar of *near-term-UI vs. invasive-daemon-change* dependency
framing.

Source: [designs/chat-pending-commands.md](https://github.com/endojs/endo-but-for-bots/blob/60a63bc404ce8b28c11021d622c0c65ef1f73e00/designs/chat-pending-commands.md) at commit `60a63bc4`.
