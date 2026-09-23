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
title: §Decision-2-checkout-entirely-CLI-side
parent: endo-but-for-bots--llm-designs-daemon-checkin-checkout--bidirectional-bridge-between-local-FS-and-formula-store-with-CLI-side-formulation
---

> *The CLI resolves the tree via `list()`, `lookup()`, and
> `streamBase64()` — all existing methods. No new daemon
> methods are needed for checkout.*

§Zero-new-daemon-methods-for-checkout. §Reuse-existing-
substrate-by-composition. §The-checkout-direction-was-
already-possible.

§Symmetry-break-named: checkin needed one method
(`storeTree`); checkout needed zero. §Existing-API-coverage-
is-asymmetric and the design names it.
