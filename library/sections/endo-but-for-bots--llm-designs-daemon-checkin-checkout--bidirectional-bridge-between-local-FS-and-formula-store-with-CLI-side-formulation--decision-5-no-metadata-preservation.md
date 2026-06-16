---
source: designs/daemon-checkin-checkout.md
source_repo: endojs/endo-but-for-bots
source_url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/daemon-checkin-checkout.md
source_path: designs/daemon-checkin-checkout.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - tooling
  - capability-security
genre: §endo-but-for-bots-design
cycle: 168
lane: designs
status: current
title: §Decision-5-no-metadata-preservation
parent: endo-but-for-bots--llm-designs-daemon-checkin-checkout--bidirectional-bridge-between-local-FS-and-formula-store-with-CLI-side-formulation
---

> *`readable-tree` and `readable-blob` formulas store
> **content only**, not metadata (permissions, timestamps,
> ownership). This is intentional: the formulas represent
> immutable content snapshots, not filesystem replicas.*

§Content-only-not-filesystem-replica. §Permissions-and-
timestamps-are-host-specific; storing them would §couple-
the-formula-store-to-POSIX-or-Windows-conventions.

§If-needed-in-the-future-add-as-optional-sidecar-formula
without changing core tree structure. §Future-extension-
named with §don't-bake-it-in-yet discipline.

§Comparison-with-Git: Git also doesn't preserve full file
metadata (only executable bit + symlink); checkin/checkout
goes further by storing zero metadata. §Less-than-Git-by-
choice.

§Synthesis-target: future daemon designs that want metadata
should propose a §parallel-formula-not-a-baked-in-field.
