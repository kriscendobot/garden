---
section: EndoMount-followNameChanges-with-FilePowers-watchDirectory-and-stat-reconciled-rename-events
source: endo-but-for-bots--llm-designs-filesystem-watchers
topics: [daemon, persistence, tooling]
status: current
title: The §confinement-flows-through-unchanged discipline
parent: endo-but-for-bots--llm-designs-filesystem-watchers--EndoMount-followNameChanges-with-FilePowers-watchDirectory-and-stat-reconciled-rename-events
---

The §security-discipline-flows-through observation: the
`EndoMount` confinement model applies to both the subscription
*setup* (assertConfined before opening the watcher) and to
each *emitted event* (isConfinedPath filter per entry).

> *Symlinks added at runtime that point outside the root are
> silently dropped from the stream.*

The §silent-drop-not-error discipline: a symlink-outside is
*not* a violation worth raising. It's a *normal* filesystem
state that simply *isn't* visible through the confined view.
§silent-omission-vs-loud-error choice.
