---
source: designs/daemon-mount.md
source_repo: endojs/endo-but-for-bots
source_url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/daemon-mount.md
source_path: designs/daemon-mount.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - capability-security
  - patterns
genre: §endo-but-for-bots-design
cycle: 166
lane: designs
status: current
title: §Single-exo-interface (the surface)
parent: endo-but-for-bots--llm-designs-daemon-mount--two-formula-type-split-with-shared-exo-interface-and-realpath-at-operation-time-confinement
---

```js
export const MountInterface = M.interface('EndoMount', {
  has, list, lookup,                          // ReadableTree-compatible reads
  write, remove, move, makeDirectory,         // Mutation
  readOnly,                                   // Attenuation
  snapshot,                                   // Bridge to immutable
  help,                                       // Discoverability
});
```

§Five-method-groupings: reads + mutation + attenuation +
snapshot + help.

§ReadableTree-compatible-reads — `has`/`list`/`lookup` match
the existing immutable surface. §Polymorphism-by-interface:
code that walks a `ReadableTree` walks a `Mount` the same
way.

§Mutation-suite — `write` / `remove` / `move` /
`makeDirectory`. §No-rename — `move` covers it. §No-chmod —
permissions are §host-controlled-not-mount-controlled.

§Snapshot-as-bridge — `snapshot()` returns a
content-addressed `readable-tree` / `readable-blob`
hierarchy. §Mount→Snapshot-as-round-trip-to-immutable.
§Combined-with-endo-checkin: §complete-round-trip (mount ↔
snapshot).
