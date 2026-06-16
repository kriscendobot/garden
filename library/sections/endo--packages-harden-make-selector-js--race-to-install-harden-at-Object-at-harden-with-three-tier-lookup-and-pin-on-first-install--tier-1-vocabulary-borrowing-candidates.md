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
title: §Tier-1 vocabulary borrowing candidates
parent: endo--packages-harden-make-selector-js--race-to-install-harden-at-Object-at-harden-with-three-tier-lookup-and-pin-on-first-install
---

§Race-to-install-at-well-known-slot (multiple
implementations coordinate via a shared symbol).

§Three-tier-lookup-with-fallthrough (Object[@harden] →
globalThis.harden → fresh make).

§Pin-on-first-install (non-configurable + non-writable to
prevent replacement).

§Defer-to-first-use (lazy IIFE-closure pattern).

§Symbol.for(name)-as-coordination-slot (registered
symbols cross realm boundaries cleanly).

§Type-check-the-existing-implementation (defensive against
collisions; fail loud not silent).

§Fail-loud-on-corruption-with-helpful-diagnostic-message.

§Tier-2: §legacy-bridge-via-fallback (accept both old and
new conventions during migration), §forward-compat-via-
pin-vs-backward-compat-via-non-installation (honest
trade-off).
