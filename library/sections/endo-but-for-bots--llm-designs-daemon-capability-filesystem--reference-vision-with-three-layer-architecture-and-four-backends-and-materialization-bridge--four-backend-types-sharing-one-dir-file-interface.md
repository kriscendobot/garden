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
title: §Four-backend-types sharing one Dir/File interface
parent: endo-but-for-bots--llm-designs-daemon-capability-filesystem--reference-vision-with-three-layer-architecture-and-four-backends-and-materialization-bridge
---

| Backend | Mutability | Use case |
|---------|-----------|----------|
| **Physical** | Read-write | OS files; §sandbox-compatible (the daemon-mount slice) |
| **Git tree** | Read-only by default | Reference revision; experimentation without touching working tree |
| **Memory** | Read-write ephemeral | Scratch space; lost when VFS discarded |
| **CAS** | Read-only | Immutable content-addressed; build artifacts, datasets |

§Single-interface-multiple-backings = §polymorphism-by-
interface (sibling to cycle 166 daemon-mount's §ReadableTree-
compatible-reads-and-Mount-walk-the-same-way).

§Each-backend-is-independently-useful. §Each-can-be-built-
incrementally. The doc names the §good-candidates-for-
first-step:

1. Minimal physical-backend Dir/File (✓ shipped as cycle
   166 daemon-mount).
2. Read-only git-tree backend.
3. Materialization bridge.
4. VFS namespace compositor mounting multiple backends.
