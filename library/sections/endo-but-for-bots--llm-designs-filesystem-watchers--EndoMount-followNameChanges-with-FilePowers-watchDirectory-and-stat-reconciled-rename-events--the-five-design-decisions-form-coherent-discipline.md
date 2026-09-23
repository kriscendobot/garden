---
section: EndoMount-followNameChanges-with-FilePowers-watchDirectory-and-stat-reconciled-rename-events
source: endo-but-for-bots--llm-designs-filesystem-watchers
topics: [daemon, persistence, tooling]
status: current
title: The §five Design Decisions form §coherent-discipline
parent: endo-but-for-bots--llm-designs-filesystem-watchers--EndoMount-followNameChanges-with-FilePowers-watchDirectory-and-stat-reconciled-rename-events
---

§Design Decisions:

1. **Fan-out multiplexing**: one watcher per subscriber first;
   add fan-out when profiling shows pressure.
2. **Recursive subscriptions**: shallow only (matches
   EndoDirectory).
3. **File-content changes**: parity-first; defer `replace` arm
   until it lands uniformly across name hubs.
4. **Coalescing window**: hard-coded 50ms; *tuning is
   premature; promote to an option only if a real consumer
   needs it*.
5. **Polling fallback default**: silent fallback with a
   `console.error` diagnostic on activation.

The §parity-first-then-extend discipline: each decision
defaults to *match the existing thing* (EndoDirectory) rather
than *innovate*. The §don't-design-for-yet-unseen-needs
discipline.

The §revisit-only-when-profiling-shows-pressure pattern in
Decision 1: explicit *trigger* for revisiting. §profiling-not-
guessing.
