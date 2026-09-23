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
title: §Race-semantics-when-multiple-implementations-load
parent: endo--packages-harden-make-selector-js--race-to-install-harden-at-Object-at-harden-with-three-tier-lookup-and-pin-on-first-install
---

Suppose `@endo/harden` and `@endo/harden` (different
versions) both load in the same realm:

1. First-loader calls `makeHardenerSelector(makeA)`.
2. `harden` is exported but not yet called.
3. Second-loader calls `makeHardenerSelector(makeB)`.
4. `harden` is exported but not yet called.
5. First call to either: tier walk → both tier 1 and tier
   2 empty → makeA runs (or makeB, depending on call
   order) → pin.
6. Subsequent calls (from either loader): tier 1 finds
   the pinned harden. §Both-loaders-share-the-same-
   harden.

§Object-identity-equality across loaders: §`hardenA ===
hardenB`-after-first-call.

§The-pin-makes-the-race-resolve-once. §No-double-install.
§No-tug-of-war.
