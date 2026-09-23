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
title: §Path-segment-validation-multi-layer
parent: endo-but-for-bots--llm-designs-daemon-capability-filesystem--reference-vision-with-three-layer-architecture-and-four-backends-and-materialization-bridge
---

> *The `PathSegment` type must reject names containing
> `/`, `\`, `..`, or the null byte. These checks occur in
> the `Dir` exo, not just in the backend, so they are
> enforced even for in-memory or CAS-backed filesystems.*

§Defense-in-depth-applies-even-to-in-memory-backends.
§Validation-at-the-exo-layer-not-just-backend-layer.

§subDir(path)-splits-on-`/`-validates-each-segment-and-
resolves-eagerly. §Eager-resolution-avoids-TOCTOU between
scoping and use. §Returned-Dir-holds-direct-reference-to-
resolved-subtree.

§Cycle-166's-mount has the operation-time confinement
check. §This-document-says-the-segment-validation-is-
exo-layer-not-backend-only.
