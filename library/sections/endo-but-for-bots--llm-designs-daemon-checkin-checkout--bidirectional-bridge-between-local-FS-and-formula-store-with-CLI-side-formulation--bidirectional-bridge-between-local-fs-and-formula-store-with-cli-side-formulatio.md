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
title: Bidirectional bridge between local FS and formula store with CLI-side formulation
parent: endo-but-for-bots--llm-designs-daemon-checkin-checkout--bidirectional-bridge-between-local-FS-and-formula-store-with-CLI-side-formulation
---

> §Endo-but-for-bots-design genre (designs-lane; the
> §pair-design to cycle 166's daemon-mount.md). Status:
> **Complete** (shipped 2026-03-20 commit `d60ba38b2`;
> zip support 2026-04-17 commit `a6e20c5e2`; verb unification
> 2026-05-18 PR #153 commit `8a8e872d4`).

`designs/daemon-checkin-checkout.md` (578 lines) is the
**§complete-bidirectional-bridge** between the local
filesystem and the daemon's immutable formula store.
Where cycle 166's daemon-mount provides §live-mutable-
access, this design provides §point-in-time-snapshot-and-
restore. The single most structurally interesting move is
the §single-substrate-four-modes pattern: directory mode +
zip mode for both checkin and checkout, all producing the
same `readable-tree` / `readable-blob` hierarchy.
