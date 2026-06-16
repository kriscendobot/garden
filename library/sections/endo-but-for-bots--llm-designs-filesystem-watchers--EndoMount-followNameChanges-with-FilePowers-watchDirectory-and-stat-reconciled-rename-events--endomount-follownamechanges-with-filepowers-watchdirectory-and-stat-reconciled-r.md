---
section: EndoMount-followNameChanges-with-FilePowers-watchDirectory-and-stat-reconciled-rename-events
source: endo-but-for-bots--llm-designs-filesystem-watchers
topics: [daemon, persistence, tooling]
status: current
title: EndoMount `followNameChanges` with `FilePowers.watchDirectory` and stat-reconciled rename events
parent: endo-but-for-bots--llm-designs-filesystem-watchers--EndoMount-followNameChanges-with-FilePowers-watchDirectory-and-stat-reconciled-rename-events
---

> *Hub abstractions that pick between a directory and a mount
> based on what the user has bound at a name path break down
> at the subscription edge.*
>
> — `designs/filesystem-watchers.md` §What is the Problem Being Solved

`filesystem-watchers.md` (486 lines, *Not Started* status,
created 2026-05-07) is a §parity-fix design by Kris Kowal
*(prompted)*. Source named in metadata: **Issue #110**.

The §design-from-sourced-issue lifecycle: the metadata cites
`Source: Issue #110`. Cycle 149's unhandled-rejection-display
was sourced from *issue + repro test PR*; cycle 157's
exo-zip-package was sourced from *PR inline review comment*;
this design's source is a *standalone issue*. §three-design-
sources-lifecycle observed across cycles 149 / 157 / 161.
