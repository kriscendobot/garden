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
title: §Reference-status-after-narrower-subset-shipped
parent: endo-but-for-bots--llm-designs-daemon-capability-filesystem--reference-vision-with-three-layer-architecture-and-four-backends-and-materialization-bridge
---

> *Became a reference document 2026-03-21 when the narrower
> `daemon-mount` design absorbed the implementable slice.*

§Reference-as-design-archive-shape. The document was
originally an open proposal (2026-02-15); cycle 166's
daemon-mount cherry-picked the §physical-backend-with-
symlink-confinement subset and shipped it.

§The-wider-vision-survives-as-reference. Future concrete
designs can §pick-one-facet, write a focused design for
it, and build it without §waiting-for-the-whole-picture-
to-solidify.

§Per-idea-factoring-suggested as the §migration-path: the
document explicitly invites contributors to peel off ideas
into focused designs. §Each-idea-can-be-a-future-cycle.

§Roadmap-calibration-via-git-blame (named in the doc
itself): 14-day design phase (2026-02-15 → 2026-02-28);
reference transition 2026-03-21; no implementation against
this document directly. §Doc-lifecycle-is-recorded.
