---
source: packages/harden/make-selector.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/harden/make-selector.js
source_path: packages/harden/make-selector.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Mark S. Miller (prompted)
topics:
  - hardened-javascript
  - patterns
  - tooling
genre: §endo-source-comment-fragment
cycle: 175
lane: chat
status: current
title: §Synthesis-target
parent: endo--packages-harden-make-selector-js--race-to-install-harden-at-Object-at-harden-with-three-tier-lookup-and-pin-on-first-install
---

§Slot-machine-library may need similar §coordination-
mechanism if multiple modules want to install the same
service. The §race-to-install-at-well-known-slot pattern
is borrowable for any module that needs a §singleton-
service-across-realm.

§Symbol.for(name)-as-coordination-slot is the §portable-
way-to-share-state-across-modules-without-a-direct-
dependency.
