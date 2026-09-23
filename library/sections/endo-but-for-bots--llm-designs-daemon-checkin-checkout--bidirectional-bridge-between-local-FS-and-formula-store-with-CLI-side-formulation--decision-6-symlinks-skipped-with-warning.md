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
title: §Decision-6-symlinks-skipped-with-warning
parent: endo-but-for-bots--llm-designs-daemon-checkin-checkout--bidirectional-bridge-between-local-FS-and-formula-store-with-CLI-side-formulation
---

> *The `readable-tree` model has no concept of symlinks.
> Following symlinks could create cycles or reference files
> outside the intended tree. Skipping them is the safe
> default.*

§Symlinks-skipped-not-followed. §Cycle-166's-mount has the
opposite stance: it *does* follow symlinks (with realpath +
confinement check). §Different-substrate-different-policy:
mount is live + confined; checkin is snapshot + content-
only.

§Symlinks-could-create-cycles: a snapshot must terminate;
following symlinks risks infinite descent. §The-content-
model-doesn't-naturally-encode-symlinks.
