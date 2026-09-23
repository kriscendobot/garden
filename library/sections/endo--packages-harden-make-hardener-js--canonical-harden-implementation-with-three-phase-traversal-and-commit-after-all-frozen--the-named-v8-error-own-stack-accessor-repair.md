---
title: §the-named-V8-error-own-stack-accessor-repair
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

Lines 171-242 implement a 70-line platform-specific repair of V8's problematic Error.prototype.stack accessor. The repair:

1. Captures the stack accessor's `get` + `set` for both `TypeError` and `Error`
2. Verifies same-realm equality (both errors should share the same getter and setter on V8)
3. If they match: capture as `FERAL_STACK_GETTER` + `FERAL_STACK_SETTER` and freeze them
4. If they don't match: **throw with named SES error code** `SES_UNEXPECTED_ERROR_OWN_STACK_ACCESSOR`

```js
} else {
  // See https://github.com/endojs/endo/blob/master/packages/ses/error-codes/SES_UNEXPECTED_ERROR_OWN_STACK_ACCESSOR.md
  throw TypeError(
    'Unexpected Error own stack accessor functions (SES_UNEXPECTED_ERROR_OWN_STACK_ACCESSOR)',
  );
}
```

**§the-named-platform-specific-repair-with-named-error-code** — first-explicit-observation. The error code is a **stable URL anchor**: `SES_UNEXPECTED_ERROR_OWN_STACK_ACCESSOR.md` lives in the ses package's error-codes directory. When code throws this error, the message contains the error code, which is grep-able. The Markdown file at the URL documents the failure mode.

**§the-named-error-code-as-stable-URL-anchor** — first-explicit-observation as a tier-3 meta-pattern. Compare to cycle 326's @deprecated tags (canonical pointer); cycle 336's TODO-with-named-obstacle (issue tracker reference); cycle 338's named-error-code (Markdown doc URL). **§three-shapes-of-stable-pointer-discipline** (deprecation-pointer + issue-link + error-code-Markdown). First-explicit-observation as a tier-3 meta-pattern.

**§the-named-platforms-without-the-bug-named-explicitly** — lines 194-198:

> Note that FF/SpiderMonkey, Moddable/XS, and the error stack proposal all inherit a stack accessor property from Error.prototype, which is great. That case needs no heroics to secure.

The comment names BOTH the platforms with the bug (V8) AND the platforms without it (FF/SpiderMonkey + Moddable/XS + error stack proposal). **§the-named-platforms-with-AND-without-bug-named-explicitly** — first-explicit-observation. Compare to cycle 337's §the-named-test-and-UI-framework-acknowledgment (parallel ecosystem named); cycle 338 names the platforms that DON'T need the repair.
