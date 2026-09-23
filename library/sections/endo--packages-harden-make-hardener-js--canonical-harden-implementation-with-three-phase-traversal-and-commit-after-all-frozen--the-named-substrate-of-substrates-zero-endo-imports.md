---
title: §the-named-substrate-of-substrates-zero-endo-imports
source: endo--packages-harden-make-hardener-js
url: https://github.com/endojs/endo/blob/master/packages/harden/make-hardener.js
authors: [Kris Kowal, Mark S. Miller, Google Caja contributors, Agoric contributors]
repo: endojs/endo
path: packages/harden/make-hardener.js
total-lines: 471
ingest-cycle: 338
ingest-date: 2026-06-15
lane: chat
section-tags:
  - the-named-canonical-harden-implementation
  - the-named-three-phase-traversal-with-named-commit-after-all-frozen
  - the-named-enqueue-dequeue-commit-algorithm
  - the-named-mark-hardened-only-after-all-frozen-discipline
  - the-named-transactional-harden-discipline
  - the-named-multi-generation-derivation-chain-named-in-the-header
  - the-named-four-stage-attribution-chain
  - the-named-FERAL-prefix-naming-convention
  - the-named-feral-error-with-named-reason
  - the-named-V8-error-own-stack-accessor-repair
  - the-named-platform-specific-repair-with-named-error-code
  - the-named-platform-detection-at-factory-time-not-per-call
  - the-named-platform-conditional-fast-path-vs-slow-path
  - the-named-acknowledged-and-bounded-hazard
  - the-named-triple-duplication-with-named-layering-constraint
  - the-named-bulk-destructure-of-globalThis
  - the-named-Safari-bug-workaround-with-named-tracking-URL
  - the-named-error-code-as-stable-URL-anchor
  - the-named-link-rot-acknowledgment-with-archive-URL
  - the-named-fallback-URL-when-canonical-dies
  - the-named-uncurry-this-canonical-idiom
  - the-named-hasOwn-shim-with-named-issue-link
  - the-named-substrate-of-substrates-zero-endo-imports
  - the-named-freezeTypedArray-with-tc39-spec-citation
  - the-named-freeze-before-traversal-defends-against-reactive-objects
  - the-named-getOwnPropertyDescriptors-defends-against-Object.prototype-poisoning
  - the-named-traversePrototypes-as-named-option
  - the-named-canonical-Endo-idiom-named-function-via-object-destructure
  - the-named-streak-resumes-with-ninth-instance
  - twenty-nine-cycles-with-named-pivot-domain-stay
  - sixty-two-citation-arc-closures-in-pivot-now
parent: endo--packages-harden-make-hardener-js--canonical-harden-implementation-with-three-phase-traversal-and-commit-after-all-frozen
---

Looking at make-hardener.js's imports: there are **ZERO** imports of any @endo package. The file depends only on:
- `globalThis` (line 24 + 26-37 bulk destructure)
- Implicit Apache-2.0 license header (lines 1-21)

**§the-named-substrate-of-substrates-zero-endo-imports** — first-explicit-observation. Cycle 337 README named @endo/harden as the *"third tier"* of the HardenedJS defense (after HardenedJS primordials and LavaMoat). Cycle 338 reveals: **the third tier itself depends on NO other @endo package**. This is the substrate-of-substrates property — @endo/harden sits BELOW every other @endo package in the dependency graph.

**§the-named-zero-endo-imports-as-substrate-marker** — first-explicit-observation as a tier-3 meta-pattern. The dependency-graph position of a substrate package is **detectable by counting @endo imports**. A package with zero @endo imports cannot be a consumer; it can only be a provider.

Compare to:
- Cycle 332 exo-tools.js: seven @endo imports (substrate consumer)
- Cycle 334 common/object-map.js: one @endo import (`@endo/harden`)
- Cycle 336 memo-race.js: one @endo import (`@endo/harden`)
- **Cycle 338 make-hardener.js: ZERO @endo imports** (substrate provider)

**§the-named-dependency-import-count-tracks-package-tier** — first-explicit-observation as a tier-3 meta-pattern. Tier-3 framing: more @endo imports = higher in the stack; zero @endo imports = at the bottom.
