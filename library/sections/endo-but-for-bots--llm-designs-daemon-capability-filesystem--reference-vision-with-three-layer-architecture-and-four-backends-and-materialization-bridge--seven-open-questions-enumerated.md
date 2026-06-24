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
title: §Seven-Open-Questions enumerated
parent: endo-but-for-bots--llm-designs-daemon-capability-filesystem--reference-vision-with-three-layer-architecture-and-four-backends-and-materialization-bridge
---

The doc names §seven-deferred-decisions:

1. What is the right backend interface?
2. Should `glob()` live on `Dir` or as a separate utility?
3. How should the VFS handle overlapping/shadowing mounts?
4. What are atomicity semantics for cross-mount writes?
5. How should materialization handle large subtrees?
6. Is `subDir(path)` the right name? (Alternatives:
   `chroot(path)`, `scope(path)`.)
7. Should `readOnly()` and `subDir()` return new exos with
   their own control facets?

§Honest-deferral-discipline. §These-questions-belong-to-
future-concrete-designs.

§Cycle-149's-three-open-questions (unhandled-rejection-
display) follow the same shape. §Open-Questions-as-design-
artifact across the design corpus.
