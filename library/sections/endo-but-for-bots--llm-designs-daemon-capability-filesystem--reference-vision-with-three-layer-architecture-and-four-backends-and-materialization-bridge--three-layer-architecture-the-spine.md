---
source: designs/daemon-capability-filesystem.md
source_repo: endojs/endo-but-for-bots
source_url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/daemon-capability-filesystem.md
source_path: designs/daemon-capability-filesystem.md
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
cycle: 170
lane: designs
status: current
title: §Three-layer-architecture (the spine)
parent: endo-but-for-bots--llm-designs-daemon-capability-filesystem--reference-vision-with-three-layer-architecture-and-four-backends-and-materialization-bridge
---

```
┌─────────────────────────────────────────────┐
│               Guest (Dir / File)            │
│  Navigation, read, write, attenuation       │
│  Structural confinement — cannot go up      │
├─────────────────────────────────────────────┤
│        VFS Namespace (host-only)            │
│  Composes backends into a virtual tree      │
│  mount(), root(), control facets            │
├───────────┬─────────────┬───────────────────┤
│ Physical  │  Git Tree   │  Memory / CAS     │
│ Backend   │  Backend    │  Backend          │
└───────────┴─────────────┴───────────────────┘
```

§Three-layer-decoupling:

- **Guest layer** (`Dir` / `File`): the *only* capabilities
  the guest sees. §Structural-confinement — cannot navigate
  above the root.
- **VFS Namespace** (host-only): §composes-backends-into-
  a-virtual-tree. The guest cannot distinguish which paths
  are physical and which are virtual. §Chroot-jail-shape.
- **Backends**: provide storage behind the `Dir`/`File`
  interface. §Single-interface-multiple-backings.

§The-key-property: §the-guest-cannot-tell-which-backend-
serves-which-path. The same `Dir` and `File` methods work
whether the backing is physical, git tree, memory, or CAS.

§Endo-already-has-this-pattern: cycle 161's overview of
ocap-kernel noted the four-layer name-space (kref/vref/
rref/eref); this is the filesystem analog (one Dir
interface; multiple backends).
