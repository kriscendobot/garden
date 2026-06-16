---
title: §the-named-bulk-destructure-of-globalThis
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

Lines 26-37 destructure TEN names from globalThis in one block:

```js
const {
  Array,
  JSON,
  Number,
  Object,
  Reflect,
  Set,
  String,
  Symbol,
  Uint8Array,
  WeakSet,
} = globalThis;
```

**§the-named-bulk-destructure-of-globalThis** — first-explicit-observation as a refinement of cycle 314/318's Reflect-only destructure and cycle 332's Reflect.apply+ownKeys destructure. Cycle 338 expands to ten intrinsics at module load.

**§five-cycles-with-named-pre-lockdown-intrinsic-capture** (314 + 318 + 332 + 334 + 338) — the discipline grows with file scope: hex needed Reflect; common needed Function.prototype.call.bind; make-hardener needs ten intrinsics because it touches Array iteration + JSON stringification + Number checks + Object descriptors + Reflect.apply + Set + WeakSet + Symbol + String + Uint8Array.

**§the-named-bulk-destructure-tracks-file-scope** — first-explicit-observation as a tier-3 meta-pattern. The number of destructured intrinsics is a proxy for how many language primitives the file uses; bigger files need more.
