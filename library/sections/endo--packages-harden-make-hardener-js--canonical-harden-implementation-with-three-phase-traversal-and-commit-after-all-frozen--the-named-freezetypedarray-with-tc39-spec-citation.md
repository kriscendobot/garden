---
title: §the-named-freezeTypedArray-with-tc39-spec-citation
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

Lines 289-320 — `freezeTypedArray` handles TypedArrays specially:

```js
arrayForEach(ownKeys(array), name => {
  const desc = getOwnPropertyDescriptor(array, name);
  assert(desc);
  // TypedArrays are integer-indexed exotic objects, which define special
  // treatment for property names in canonical numeric form:
  // integers in range are permanently writable and non-configurable.
  // https://tc39.es/ecma262/#sec-integer-indexed-exotic-objects
  //
  // This is analogous to the data of a hardened Map or Set,
  // so we carve out this exceptional behavior but make all other
  // properties non-configurable.
  if (!isCanonicalIntegerIndexString(name)) {
    defineProperty(array, name, { ...desc, writable: false, configurable: false });
  }
});
```

**§the-named-freezeTypedArray-with-tc39-spec-citation** — first-explicit-observation. The comment cites the TC39 spec URL (`tc39.es/ecma262/#sec-integer-indexed-exotic-objects`) as the JUSTIFICATION for the special handling. **§the-named-tc39-spec-citation-as-rationale** — first-explicit-observation as a tier-3 meta-pattern.

**§the-named-analogous-to-hardened-Map-or-Set** — the comment compares TypedArray integer-indexed data to *"the data of a hardened Map or Set"* — that is, the data slots are conceptually exempt from freeze because they're part of the object's identity, like Set/Map's internal slots. **§the-named-conceptual-analogy-to-justify-exception** — first-explicit-observation as a tier-3 meta-pattern.

**§the-named-fail-safe-when-encountering-named-platform-bug** — lines 297-300:

> We get each descriptor individually rather than using getOwnPropertyDescriptors in order to fail safe when encountering an obscure GraalJS issue where getOwnPropertyDescriptor returns undefined for a property that does exist.

The comment names BOTH:
1. The platform (GraalJS)
2. The bug (getOwnPropertyDescriptor returns undefined for existing property)
3. The defense (per-property check rather than bulk-fetch)

**§the-named-platform-bug-defended-against-with-per-item-fallback** — first-explicit-observation. **§three-cycles-with-named-platform-specific-defense** (cycle 87 V8-stack + cycle 156 GC-as-side-channel + cycle 338 GraalJS + V8 + Safari combined). The defense pattern: when a bulk operation has platform-specific bugs, fall back to per-item operations.
