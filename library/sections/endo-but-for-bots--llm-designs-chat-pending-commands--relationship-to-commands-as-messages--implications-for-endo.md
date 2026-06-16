---
title: Implications for Endo
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

This design is one of several in the chat-cluster that operate at the
UI layer with explicit awareness of a deeper daemon-layer alternative.
The pattern is: identify a UX gap, design a UI-only fix scoped to a
handful of chat-package files, name the daemon-side alternative that
would obviate the UI fix, and frame the UI fix as both near-term
solution and fallback. The shape lets the chat client improve
continuously while the daemon question is debated separately, without
either workstream blocking the other.

Source: [designs/chat-pending-commands.md](https://github.com/endojs/endo-but-for-bots/blob/60a63bc404ce8b28c11021d622c0c65ef1f73e00/designs/chat-pending-commands.md) at commit `60a63bc4`.
