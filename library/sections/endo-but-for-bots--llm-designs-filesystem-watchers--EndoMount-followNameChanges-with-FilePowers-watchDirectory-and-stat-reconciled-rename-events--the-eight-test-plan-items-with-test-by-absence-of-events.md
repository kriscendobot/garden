---
section: EndoMount-followNameChanges-with-FilePowers-watchDirectory-and-stat-reconciled-rename-events
source: endo-but-for-bots--llm-designs-filesystem-watchers
topics: [daemon, persistence, tooling]
status: current
title: The §eight-test-plan items with §test-by-absence-of-events
parent: endo-but-for-bots--llm-designs-filesystem-watchers--EndoMount-followNameChanges-with-FilePowers-watchDirectory-and-stat-reconciled-rename-events
---

§Test Plan:

1. Snapshot
2. Live add
3. Live remove
4. Subdirectory
5. External-mount parity (the parity assertion)
6. Confinement
7. Disposal
8. Daemon restart

The §test-by-absence-of-events trick for Disposal (test 7):

> *A regression for this is hard to assert directly without
> inspecting OS handles; use `t.timeout(2000)` and a bounded
> "expect zero events" probe.*

The §absence-test-via-bounded-timeout idiom. Where direct
inspection is hard, test the *consequence* (no events arrive
after disposal). Bounded timeout + "expect zero events"
catches the regression even if a watcher leaks; the timeout
makes the test deterministic.
