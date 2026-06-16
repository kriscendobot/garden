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
title: §The-non-configurability-is-load-bearing
parent: endo--packages-harden-make-selector-js--race-to-install-harden-at-Object-at-harden-with-three-tier-lookup-and-pin-on-first-install
---

§Non-configurable-and-non-writable together mean: §the-
property-cannot-be-removed-or-replaced.

§Why-both: `writable: false` blocks `Object[@harden] =
...`; `configurable: false` blocks `delete Object[@harden]`
and `defineProperty(...)` overrides.

§Both-needed because §JavaScript-has-two-mutation-paths
for own properties.

§The-result: §once-this-line-runs-the-slot-is-permanent
for the lifetime of the realm.
