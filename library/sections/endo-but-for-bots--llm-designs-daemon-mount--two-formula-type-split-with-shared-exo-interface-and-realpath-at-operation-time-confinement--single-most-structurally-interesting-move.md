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
title: §Single-most-structurally-interesting-move
parent: endo-but-for-bots--llm-designs-daemon-mount--two-formula-type-split-with-shared-exo-interface-and-realpath-at-operation-time-confinement
---

The §two-formula-type-split-with-shared-exo-interface is
the design's §unique-shape. The split honors §lifecycle-
asymmetry (external-host-managed vs daemon-managed-storage)
without §sacrificing-implementation-symmetry (one exo
interface, one mount.js). §Lifecycle-asymmetry-vs-
implementation-symmetry as a §design-pattern-not-just-this-
design.

§Synthesis-target: future daemon capabilities that have
two lifecycle modes (host-provided vs daemon-provided)
could borrow this split. §Cycle-105's-daemon-capability-
bank might benefit from the same.
