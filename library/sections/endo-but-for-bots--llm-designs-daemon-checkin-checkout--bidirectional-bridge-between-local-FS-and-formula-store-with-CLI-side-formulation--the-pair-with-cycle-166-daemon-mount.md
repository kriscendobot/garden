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
title: §The-pair-with-cycle-166-daemon-mount
parent: endo-but-for-bots--llm-designs-daemon-checkin-checkout--bidirectional-bridge-between-local-FS-and-formula-store-with-CLI-side-formulation
---

§Mount-and-checkin-checkout-are-the-two-shapes-of-FS-
access:

- **Mount** (cycle 166): §live-mutable filesystem capability;
  changes flow both ways in real time; the formula
  represents a *boundary*, not a snapshot.
- **Checkin/Checkout**: §point-in-time bridge to immutable
  snapshots; `readable-tree` + `readable-blob` formulas;
  the formula represents *the content at a moment*.

§Mount.snapshot()-produces-a-readable-tree (cycle 166
Decision: §snapshot-as-bridge-to-immutable). §Checkin
produces the same shape. §Two-paths-into-the-same-immutable-
representation: snapshot from a live mount, or checkin from
a local directory.

§Endo-checkout-restores: the §round-trip is mount ↔
snapshot ↔ checkout ↔ local directory.
