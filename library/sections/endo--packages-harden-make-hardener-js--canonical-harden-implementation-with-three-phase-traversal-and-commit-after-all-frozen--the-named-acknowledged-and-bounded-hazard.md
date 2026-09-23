---
title: §the-named-acknowledged-and-bounded-hazard
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

Lines 433-441:

```js
defineProperty(obj, 'stack', {
  // NOTE: Calls getter during harden, which seems dangerous.
  // But we're only calling the problematic getter whose
  // hazards we think we understand.
  // @ts-expect-error TS should know FERAL_STACK_GETTER
  // cannot be `undefined` here.
  // See https://github.com/endojs/endo/pull/2232#discussion_r1575179471
  value: apply(FERAL_STACK_GETTER, obj, []),
});
```

**§the-named-acknowledged-and-bounded-hazard** — first-explicit-observation as a tier-3 meta-pattern. The comment NAMES:
1. The hazard (*"Calls getter during harden, which seems dangerous"*)
2. The bounded reason for accepting it (*"we're only calling the problematic getter whose hazards we think we understand"*)
3. The TypeScript suppression with named cause (`@ts-expect-error` + named reason)
4. The PR discussion link where the decision was discussed

**§the-named-four-part-hazard-acknowledgment** — first-explicit-observation. Compare to cycle 156 finalize.js's §gc-as-side-channel warning (the dangerous mode named); cycle 322 exo-makers.js's §warning-comment-repeated-thrice (state-sealed-not-frozen reminder); cycle 338's four-part acknowledgment is the most structured form. **§three-shapes-of-hazard-acknowledgment** (156 named-warning + 322 repeated-warning + 338 four-part-acknowledgment).
