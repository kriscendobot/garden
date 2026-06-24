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
title: §Type-discrimination-via-locator
parent: endo-but-for-bots--llm-designs-daemon-checkin-checkout--bidirectional-bridge-between-local-FS-and-formula-store-with-CLI-side-formulation
---

Checkout must distinguish §readable-blob (file) from
§readable-tree (directory). The design names two
approaches:

1. **§Duck-typing**: call `E(value).list()`; if it succeeds,
   it's a tree. §Fragile-but-requires-no-new-interface-
   methods.
2. **§Locator-encodes-formula-type** (preferred): the
   `locate()` method on directories already returns a
   locator string that encodes the formula type (e.g.,
   `?type=readable-tree`). The checkout resolves the pet
   name to a locator, parses it, dispatches.

§The-locator-format-is-doing-real-work — cycle 135's
daemon-locator-reference design defines this format; this
design *uses* it. §Locators-are-not-just-share-links; §they-
encode-type-information-too.

§Synthesis-target-implied: the §locator-as-typed-reference
pattern could be borrowed by future daemon clients beyond
this CLI.
