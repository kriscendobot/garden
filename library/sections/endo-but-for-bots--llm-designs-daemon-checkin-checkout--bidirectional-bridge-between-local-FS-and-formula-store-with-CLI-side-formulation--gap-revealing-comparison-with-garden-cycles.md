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
title: §Gap-revealing-comparison with garden cycles
parent: endo-but-for-bots--llm-designs-daemon-checkin-checkout--bidirectional-bridge-between-local-FS-and-formula-store-with-CLI-side-formulation
---

| Cycle | Connection |
|-------|------------|
| 166 (daemon-mount) | §Pair design — mount = live; checkin/checkout = snapshot |
| 141 (daemon-cas-management) | §Content-store-keyed-by-sha256 substrate; checkin produces store entries |
| 135 (daemon-locator-reference) | §Locator-encodes-formula-type used for §type-discrimination |
| 157 (exo-zip-package) | §Sibling — exo-zip is the *programmatic* API; this is the *CLI* API |
| 161 (filesystem-watchers) | §Cousin design — both touch FS-daemon boundary |
