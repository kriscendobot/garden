---
title: §the-named-hasOwn-shim-with-named-issue-link
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

Lines 110-130 — feature detection + shim for `Object.hasOwn`:

```js
// See https://github.com/endojs/endo/issues/2930
if (!('hasOwn' in Object)) {
  const ObjectPrototypeHasOwnProperty = objectPrototype.hasOwnProperty;
  const hasOwnShim = (obj, key) => {
    if (obj === undefined || obj === null) {
      // We need to add this extra test because of differences in
      // the order in which `hasOwn` vs `hasOwnProperty` validates
      // arguments.
      throw TypeError('Cannot convert undefined or null to object');
    }
    return apply(ObjectPrototypeHasOwnProperty, obj, [key]);
  };
  defineProperty(Object, 'hasOwn', { value: hasOwnShim, writable: true, enumerable: false, configurable: true });
}
```

**§the-named-hasOwn-shim-with-named-issue-link** — first-explicit-observation. The comment cites endo/endo#2930. The shim:
1. Feature-detects `hasOwn` in Object
2. Captures `Object.prototype.hasOwnProperty` for use as the shim's underlying primitive
3. Adds an extra null/undefined check because *"differences in the order in which `hasOwn` vs `hasOwnProperty` validates arguments"*
4. Installs via `defineProperty` (which is the bug-workaround wrapper from above)

**§the-named-feature-detect-then-install-shim-pattern** — first-explicit-observation. The pattern: check; if absent, install. Compare to cycle 187's §two-shim-strategies (conditional + unconditional); cycle 338's shim is conditional (only installs when absent).

**§the-named-extra-test-because-of-validation-order-differences** — first-explicit-observation. The shim explicitly names the divergence from the spec's `hasOwn`. **§the-named-shim-explicitly-names-spec-divergence** — first-explicit-observation as a tier-3 meta-pattern. Sibling to cycle 336's §the-named-deviation-named-in-the-source-too — that was a deliberate divergence; cycle 338 is a *necessary* divergence for shim correctness.
