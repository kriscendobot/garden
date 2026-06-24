---
section: EndoMount-followNameChanges-with-FilePowers-watchDirectory-and-stat-reconciled-rename-events
source: endo-but-for-bots--llm-designs-filesystem-watchers
topics: [daemon, persistence, tooling]
status: current
title: The §load-bearing-two-fold-problem
parent: endo-but-for-bots--llm-designs-filesystem-watchers--EndoMount-followNameChanges-with-FilePowers-watchDirectory-and-stat-reconciled-rename-events
---

The §What-is-the-Problem-Being-Solved section names *two*
distinct problems:

1. **§Surface parity** — Code that consumes a `NameHub` for
   live updates (`chat-spaces-gutter`, the inventory view,
   the `endo log` follower) *cannot be retargeted at an
   EndoMount because the method is absent*. Polymorphic hub
   abstractions *break down at the subscription edge*.
2. **§Mechanism parity** — Even where polling is acceptable,
   every consumer *reinvents debounce, ordering, and
   disposal*. A central adapter from `node:fs` watcher events
   to `pubsub` lets callers share *one code path* with
   EndoDirectory consumers.

The §enumerate-two-problems methodology: rather than "EndoMount
needs follow," the design names *two* independent reasons
either of which would justify the fix. §multiple-independent-
justifications (parallel to cycle 153's CI design which named
*supply-chain + reproducibility + correctness*).
