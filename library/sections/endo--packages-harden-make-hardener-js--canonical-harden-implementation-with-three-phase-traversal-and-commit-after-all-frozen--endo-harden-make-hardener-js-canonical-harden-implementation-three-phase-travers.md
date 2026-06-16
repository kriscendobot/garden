---
title: "`@endo/harden make-hardener.js` — canonical harden implementation; three-phase traversal with commit-after-all-frozen"
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

The 471-line canonical implementation of `harden()` — the function that makes Hardened JavaScript hardened. Cycle 338 is **chat-lane after cycle 337's designs-lane @endo/harden README** (adjacent forward pair; same package). **Ninth INSTANCE** of one-cycle README↔source pattern; **§the-named-streak-resumes-with-ninth-instance** — the streak was at 1 after cycle 336 → 337 cross-package interruption; cycle 337 → 338 same-package resumes it. Streak count: 1.

**Twenty-ninth consecutive non-garden source after the pivot** (cycles 310-338). **§twenty-nine-cycles-with-named-pivot-domain-stay**. **§fourteen-named-packages-in-the-pivot-cluster** continues (harden's source after its README).

The file is the **canonical harden implementation**: 471 lines spanning a multi-generation derivation chain, bulk-destructure of globalThis intrinsics, FERAL_ERROR / FERAL_STACK_GETTER / FERAL_STACK_SETTER capture with platform-specific repair, three-phase traversal (enqueue + dequeue + commit), TypedArray special-case handling, and exported `makeHardener` factory.
