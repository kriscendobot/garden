---
title: Relationship to commands-as-messages, dependency framing, and the fallback role
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
kind: index
section_count: 7
---

Sections:

- [Abstract](endo-but-for-bots--llm-designs-chat-pending-commands--relationship-to-commands-as-messages--abstract.md)
- [The deeper asymmetry the UI region cannot fix](endo-but-for-bots--llm-designs-chat-pending-commands--relationship-to-commands-as-messages--the-deeper-asymmetry-the-ui-region-cannot-fix.md)
- [The deeper alternative (subsumption shape)](endo-but-for-bots--llm-designs-chat-pending-commands--relationship-to-commands-as-messages--the-deeper-alternative-subsumption-shape.md)
- [The fallback role (the dual-positioning move)](endo-but-for-bots--llm-designs-chat-pending-commands--relationship-to-commands-as-messages--the-fallback-role-the-dual-positioning-move.md)
- [Dependencies (from the design's appendix)](endo-but-for-bots--llm-designs-chat-pending-commands--relationship-to-commands-as-messages--dependencies-from-the-design-s-appendix.md)
- [Implications for Endo](endo-but-for-bots--llm-designs-chat-pending-commands--relationship-to-commands-as-messages--implications-for-endo.md)
- [See also](endo-but-for-bots--llm-designs-chat-pending-commands--relationship-to-commands-as-messages--see-also.md)

Source: [designs/chat-pending-commands.md](https://github.com/endojs/endo-but-for-bots/blob/60a63bc404ce8b28c11021d622c0c65ef1f73e00/designs/chat-pending-commands.md) at commit `60a63bc4`.
