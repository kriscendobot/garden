---
title: §the-named-triple-duplication-with-named-layering-constraint
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

Lines 141-156 contain the SAME `isPrimitive` function as cycle 336 memo-race.js + cycle 142 passStyle-helpers.js. The TODO at line 142-145 names THREE packages:

```js
/**
 * TODO Consolidate with `isPrimitive` that's currently in `@endo/pass-style`
 * and also `ses`.
 * Layering constraints make this tricky, which is why we haven't yet figured
 * out how to do this.
 */
```

**§the-named-triple-duplication-with-named-layering-constraint** — first-explicit-observation. Cycle 336's note said the duplication was between @endo/promise-kit and @endo/pass-style (TWO packages). Cycle 338's TODO reveals the duplication is across THREE packages: @endo/harden, @endo/pass-style, and ses. The layering constraint forms a triangle: each package sits BELOW the others in some sense (harden is THE substrate; pass-style imports harden; ses underpins everything).

**§the-named-three-package-duplication-discipline** — first-explicit-observation. Tier-3 meta-pattern: when a primitive helper is needed at the bottom of multiple layered packages, duplicate rather than introduce circular imports. The TODO acknowledges the obstacle (layering); the practical decision is to duplicate.

**§the-named-honest-TODO-with-named-obstacle-applies-to-triple-duplication** — extending cycle 336's TODO-with-named-obstacle observation. **§four-cycles-with-named-isPrimitive-duplication-observation** (142 passStyle-helpers.js + 336 memo-race.js + 338 make-hardener.js + the implicit fourth in ses; not yet ingested).
