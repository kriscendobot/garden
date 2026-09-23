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
title: §Synthesis-target
parent: endo-but-for-bots--llm-designs-daemon-capability-filesystem--reference-vision-with-three-layer-architecture-and-four-backends-and-materialization-bridge
---

§Reference-document-as-roadmap-source. Future cycles can
pick:

- **Git tree backend** — currently un-designed; would
  let agents experiment against a revision without
  touching working tree.
- **Memory backend** — ephemeral scratch space.
- **CAS backend** — immutable artifacts.
- **VFS namespace compositor** — the multi-mount layer.
- **Materialization bridge** — non-physical → sandbox-
  visible.

§Each-of-these-is-a-future-concrete-design. §Per-idea-
factoring as the §recommended-path.

§Why-this-stayed-reference: the §wider-vision was too
broad to implement at once; §absorbing-the-implementable-
slice into a narrower design is the §correct-refactor-
of-design-effort.
