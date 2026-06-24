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
title: §The-relationship-to-mkweblet
parent: endo-but-for-bots--llm-designs-daemon-checkin-checkout--bidirectional-bridge-between-local-FS-and-formula-store-with-CLI-side-formulation
---

> *`endo checkin -z` replaces the zip extraction that was
> previously embedded inside `mkweblet`.*

§Zip-extraction-extracted-from-mkweblet. The earlier design
had zip handling inside `mkweblet` (the weblet-application
verb); this design pulls it into a §standalone-command-
without-weblet-coupling.

§Mkweblet-now-accepts-a-readable-tree-directly. §Two-step-
pipeline: `endo ci -z dist.zip -n my-app-content` →
`endo mkweblet my-app-content --as my-app`.

§Decomposition-of-bundled-verbs is the §refactor-discipline:
when one verb does two things and they need separate use,
split.
