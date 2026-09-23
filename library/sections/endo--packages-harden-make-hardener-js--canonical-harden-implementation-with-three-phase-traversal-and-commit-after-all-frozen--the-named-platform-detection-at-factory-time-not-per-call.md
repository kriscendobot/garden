---
title: §the-named-platform-detection-at-factory-time-not-per-call
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

Lines 414-445 — `freezeAndTraverse` is defined as ONE OF TWO closures at factory time, NOT a branch evaluated per-call:

```js
const freezeAndTraverse =
  FERAL_STACK_GETTER === undefined && FERAL_STACK_SETTER === undefined
    ? // On platforms without v8's error own stack accessor problem,
      // don't pay for any extra overhead.
      baseFreezeAndTraverse
    : obj => {
        if (isError(obj)) {
          // ... stack-accessor repair logic ...
        }
        return baseFreezeAndTraverse(obj);
      };
```

**§the-named-platform-detection-at-factory-time-not-per-call** — first-explicit-observation as a tier-3 meta-pattern. The runtime branch is replaced by a per-instance choice. Platforms without the V8 bug get `baseFreezeAndTraverse` directly; V8 platforms get the wrapper that checks `isError(obj)` before adding stack repair.

The comment names the rationale: *"On platforms without v8's error own stack accessor problem, don't pay for any extra overhead."* **§the-named-platform-conditional-fast-path-vs-slow-path** — first-explicit-observation. Compare to:
- Cycle 332 exo-tools.js's §the-named-zero-copy-when-possible-discipline (copy only when needed)
- Cycle 334 common/object-map.js's §the-named-harden-cast-vs-harden-function-distinction (no extra harden on intrinsics)
- **Cycle 338 make-hardener.js's §the-named-platform-detection-at-factory-time-not-per-call** (no per-call branch on platforms without the bug)

**§three-cycles-with-named-pay-only-when-necessary-discipline** (332 + 334 + 338) — first-explicit-observation as a tier-3 meta-pattern.
