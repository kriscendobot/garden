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
title: Reference vision with three-layer architecture and four backends and materialization bridge
parent: endo-but-for-bots--llm-designs-daemon-capability-filesystem--reference-vision-with-three-layer-architecture-and-four-backends-and-materialization-bridge
---

> §Endo-but-for-bots-design genre (designs-lane). §The-
> §wider-vision-that-cycle-166's-daemon-mount-is-the-
> §concrete-mergeable-slice-of. Status: **Reference**
> (transitioned 2026-03-21 when narrower `daemon-mount`
> absorbed the implementable slice; was originally an open
> proposal 2026-02-15).

`designs/daemon-capability-filesystem.md` (966 lines) is
the **§speculative-vision-document** that lays out the
design space for filesystem capabilities in Endo. The
narrower implementable slice has shipped as cycle 166's
daemon-mount. This document remains as §reference-for-
forward-looking-work with §per-idea-factoring guidance.

The single most structurally interesting move is the §three-
layer-architecture (Guest / VFS-Namespace / Backends) that
decouples §what-the-guest-sees from §how-the-storage-is-
backed, enabling §Bazel-style-selective-mounting where
§absence-is-structural-not-policy.
