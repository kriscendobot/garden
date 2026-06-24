---
title: The fallback role (the dual-positioning move)
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

The design explicitly preserves its value even if the daemon change
ships:

> This design remains valuable as the near-term solution and as a
> fallback if the daemon change is deferred.

This is a load-bearing piece of dependency framing. The design is not
*blocked on* the daemon change; it ships first, and if the daemon
change never lands, the pending region remains the UX answer
indefinitely. If the daemon change does land, the pending region's
existence accelerates rollout (the chat UI already knows how to
render in-flight cards).

The dual-positioning is the canonical *near-term-UI vs. invasive-
daemon-change* shape in this design corpus: ship the UI fix that
covers the user's immediate pain, name the deeper architectural
question as a sibling design, and frame the UI fix as both immediate
solution *and* graceful-degradation path if the deeper change is
deferred. The two designs are not in tension; they cover different
time horizons of the same problem.

Source: [designs/chat-pending-commands.md](https://github.com/endojs/endo-but-for-bots/blob/60a63bc404ce8b28c11021d622c0c65ef1f73e00/designs/chat-pending-commands.md) at commit `60a63bc4`.
