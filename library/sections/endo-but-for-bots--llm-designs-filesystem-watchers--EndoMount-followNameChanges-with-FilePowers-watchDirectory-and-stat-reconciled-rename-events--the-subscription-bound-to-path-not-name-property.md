---
section: EndoMount-followNameChanges-with-FilePowers-watchDirectory-and-stat-reconciled-rename-events
source: endo-but-for-bots--llm-designs-filesystem-watchers
topics: [daemon, persistence, tooling]
status: current
title: The §subscription-bound-to-path-not-name property
parent: endo-but-for-bots--llm-designs-filesystem-watchers--EndoMount-followNameChanges-with-FilePowers-watchDirectory-and-stat-reconciled-rename-events
---

> *A subscriber to `mount/foo` who calls `await
> E(mount).move('foo', 'bar')` keeps watching the moved-out
> directory; the receiver of the new name path opens its own
> watcher. This matches `EndoDirectory` semantics, where a
> subscription to `petName` survives the rename of `petName`.*

The §subscription-bound-to-path-not-name discipline. The
watcher holds an *OS-level handle to the directory*, not a
*name-table entry*. Moving the name binding doesn't move the
handle.

The §matches-EndoDirectory-semantics observation: the parity
applies *to invariants*, not just to the *method signature*.
A consumer's *temporal expectations* (what happens across
renames) work the same way.
