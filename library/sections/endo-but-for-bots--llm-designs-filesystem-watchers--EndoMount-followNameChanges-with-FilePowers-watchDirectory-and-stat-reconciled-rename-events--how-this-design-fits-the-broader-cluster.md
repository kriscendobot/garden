---
section: EndoMount-followNameChanges-with-FilePowers-watchDirectory-and-stat-reconciled-rename-events
source: endo-but-for-bots--llm-designs-filesystem-watchers
topics: [daemon, persistence, tooling]
status: current
title: How this design fits the broader cluster
parent: endo-but-for-bots--llm-designs-filesystem-watchers--EndoMount-followNameChanges-with-FilePowers-watchDirectory-and-stat-reconciled-rename-events
---

§Three Dependencies:

| Design | Relationship |
|--------|--------------|
| `daemon-mount` | Defines `EndoMount`; this design adds one method |
| `platform-fs` | Owns `FilePowers`; adds `watchDirectory` |
| `daemon-content-store-gc` | Cleans up scratch mount backing directories at GC time; the watcher's `finally` release is the runtime-side cleanup |

The §dependency-typology observation (parallel to cycle 159):
each Dependency names its *kind of relationship*. Adding-a-
method / owning-a-primitive / runtime-cleanup-counterpart are
*different* kinds.

§Runtime-cleanup-pairs-with-GC observation: the watcher
release in `finally` happens *at iterator drop time*; the GC
cleanup of the mount happens *at directory garbage-collection
time*. The two work together to ensure no leaked OS handles.
