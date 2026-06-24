---
title: §the-named-FERAL-prefix-naming-convention
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

The file declares THREE FERAL_-prefixed names:

| Name | Source | Reason |
|---|---|---|
| `FERAL_ERROR` (line 43) | `Error` constructor from globalThis | *"safe for internal use, but must not be revealed to post-lockdown code in any compartment since in V8 at least it bears stack inspection capabilities"* |
| `FERAL_STACK_GETTER` (line 231) | The stack accessor's `get` | *"shared getter of all those accessors"* on V8 |
| `FERAL_STACK_SETTER` (line 242) | The stack accessor's `set` | *"shared setter"* on V8 |

**§the-named-FERAL-prefix-naming-convention** — first-explicit-observation as a tier-3 meta-pattern. The `FERAL_` prefix marks values that have **excess authority** and must be **carefully hidden from client code**. The naming convention SIGNALS to reviewers that the value is dangerous. Tier-3 meta-pattern: when capturing a primitive that has authority beyond what should be exposed, prefix the binding with `FERAL_` so readers immediately understand the capability concern.

**§the-named-feral-error-with-named-reason** — first-explicit-observation. The comment at lines 40-43 explains:

> The feral Error constructor is safe for internal use, but must not be revealed to post-lockdown code in any compartment including the start compartment since in V8 at least it bears stack inspection capabilities.

The reasoning names BOTH the safe use (internal) AND the unsafe exposure (post-lockdown code) AND the platform (V8) AND the capability (stack inspection). **§the-named-FERAL-binding-with-four-part-justification** — first-explicit-observation.

Sibling to **cycle 87 pass-style/error.js**'s §V8-stack-accessor-channel observation. **§three-cycles-with-named-V8-stack-accessor-discipline** (87 + 336 + 338).
