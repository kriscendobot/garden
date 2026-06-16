---
section: EndoMount-followNameChanges-with-FilePowers-watchDirectory-and-stat-reconciled-rename-events
source: endo-but-for-bots--llm-designs-filesystem-watchers
topics: [daemon, persistence, tooling]
status: current
title: The §parity-first design-philosophy
parent: endo-but-for-bots--llm-designs-filesystem-watchers--EndoMount-followNameChanges-with-FilePowers-watchDirectory-and-stat-reconciled-rename-events
---

The whole design is an exercise in **§parity-first**:

- `MountNameChange` matches `PetStoreNameChange`'s shape
  (with §interface-asymmetry-tracks-ownership-asymmetry).
- Snapshot-then-diff pattern *lifted from* `pet-store.js`.
- Subscription-bound-to-path-not-name matches EndoDirectory.
- Shallow-only matches EndoDirectory.
- AsyncIterator-as-CapTP-surface via `makeIteratorRef` matches
  EndoDirectory.

The §parity-as-design-axiom: the design's *primary value* is
*sameness with the existing thing*. Innovation is *minimized
to what the new substrate strictly requires* (the watcher
adapter + the type field).
