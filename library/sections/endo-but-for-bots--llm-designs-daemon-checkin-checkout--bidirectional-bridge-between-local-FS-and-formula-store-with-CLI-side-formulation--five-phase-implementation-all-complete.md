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
title: §Five-phase-implementation (all complete)
parent: endo-but-for-bots--llm-designs-daemon-checkin-checkout--bidirectional-bridge-between-local-FS-and-formula-store-with-CLI-side-formulation
---

Phase 1: `readable-tree` Formula Type — adds ReadableTreeFormula, exo, host method.
Phase 2: `endo checkin` Directory Mode.
Phase 3: `endo checkout` Directory Mode.
Phase 4: Zip Support (`-z` flag).
Phase 5: Chat Integration (`/checkin` and `/checkout`).

§Phased-S-sized (all marked S — small). §Each-phase-can-
ship-independently. §No-flag-day-required for any phase.
