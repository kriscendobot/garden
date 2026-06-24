---
title: "@endo/harden make-hardener.js — canonical harden implementation; three-phase traversal with commit-after-all-frozen; V8 stack-accessor repair (70-line); FERAL-prefix discipline; substrate-of-substrates with zero @endo imports"
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
kind: index
section_count: 23
---

Sections:

- [`@endo/harden make-hardener.js` — canonical harden implementation; three-phase traversal with commit-after-all-frozen](endo--packages-harden-make-hardener-js--canonical-harden-implementation-with-three-phase-traversal-and-commit-after-all-frozen--endo-harden-make-hardener-js-canonical-harden-implementation-three-phase-travers.md)
- [The single most structurally interesting move](endo--packages-harden-make-hardener-js--canonical-harden-implementation-with-three-phase-traversal-and-commit-after-all-frozen--the-single-most-structurally-interesting-move.md)
- [§the-named-multi-generation-derivation-chain-named-in-the-header](endo--packages-harden-make-hardener-js--canonical-harden-implementation-with-three-phase-traversal-and-commit-after-all-frozen--the-named-multi-generation-derivation-chain-named-in-the-header.md)
- [§the-named-FERAL-prefix-naming-convention](endo--packages-harden-make-hardener-js--canonical-harden-implementation-with-three-phase-traversal-and-commit-after-all-frozen--the-named-feral-prefix-naming-convention.md)
- [§the-named-V8-error-own-stack-accessor-repair](endo--packages-harden-make-hardener-js--canonical-harden-implementation-with-three-phase-traversal-and-commit-after-all-frozen--the-named-v8-error-own-stack-accessor-repair.md)
- [§the-named-platform-detection-at-factory-time-not-per-call](endo--packages-harden-make-hardener-js--canonical-harden-implementation-with-three-phase-traversal-and-commit-after-all-frozen--the-named-platform-detection-at-factory-time-not-per-call.md)
- [§the-named-acknowledged-and-bounded-hazard](endo--packages-harden-make-hardener-js--canonical-harden-implementation-with-three-phase-traversal-and-commit-after-all-frozen--the-named-acknowledged-and-bounded-hazard.md)
- [§the-named-triple-duplication-with-named-layering-constraint](endo--packages-harden-make-hardener-js--canonical-harden-implementation-with-three-phase-traversal-and-commit-after-all-frozen--the-named-triple-duplication-with-named-layering-constraint.md)
- [§the-named-substrate-of-substrates-zero-endo-imports](endo--packages-harden-make-hardener-js--canonical-harden-implementation-with-three-phase-traversal-and-commit-after-all-frozen--the-named-substrate-of-substrates-zero-endo-imports.md)
- [§the-named-bulk-destructure-of-globalThis](endo--packages-harden-make-hardener-js--canonical-harden-implementation-with-three-phase-traversal-and-commit-after-all-frozen--the-named-bulk-destructure-of-globalthis.md)
- [§the-named-Safari-bug-workaround-with-named-tracking-URL](endo--packages-harden-make-hardener-js--canonical-harden-implementation-with-three-phase-traversal-and-commit-after-all-frozen--the-named-safari-bug-workaround-with-named-tracking-url.md)
- [§the-named-uncurry-this-canonical-idiom](endo--packages-harden-make-hardener-js--canonical-harden-implementation-with-three-phase-traversal-and-commit-after-all-frozen--the-named-uncurry-this-canonical-idiom.md)
- [§the-named-hasOwn-shim-with-named-issue-link](endo--packages-harden-make-hardener-js--canonical-harden-implementation-with-three-phase-traversal-and-commit-after-all-frozen--the-named-hasown-shim-with-named-issue-link.md)
- [§the-named-freezeTypedArray-with-tc39-spec-citation](endo--packages-harden-make-hardener-js--canonical-harden-implementation-with-three-phase-traversal-and-commit-after-all-frozen--the-named-freezetypedarray-with-tc39-spec-citation.md)
- [§the-named-canonical-Endo-idiom-named-function-via-object-destructure](endo--packages-harden-make-hardener-js--canonical-harden-implementation-with-three-phase-traversal-and-commit-after-all-frozen--the-named-canonical-endo-idiom-named-function-via-object-destructure.md)
- [§the-named-traversePrototypes-as-named-option](endo--packages-harden-make-hardener-js--canonical-harden-implementation-with-three-phase-traversal-and-commit-after-all-frozen--the-named-traverseprototypes-as-named-option.md)
- [Closes citation arcs](endo--packages-harden-make-hardener-js--canonical-harden-implementation-with-three-phase-traversal-and-commit-after-all-frozen--closes-citation-arcs.md)
- [Patterns the cycle extends](endo--packages-harden-make-hardener-js--canonical-harden-implementation-with-three-phase-traversal-and-commit-after-all-frozen--patterns-the-cycle-extends.md)
- [Tier-1 borrowing (thirty-plus first-explicit-observations)](endo--packages-harden-make-hardener-js--canonical-harden-implementation-with-three-phase-traversal-and-commit-after-all-frozen--tier-1-borrowing-thirty-plus-first-explicit-observations.md)
- [Tier-2 borrowing (multi-cycle patterns extended)](endo--packages-harden-make-hardener-js--canonical-harden-implementation-with-three-phase-traversal-and-commit-after-all-frozen--tier-2-borrowing-multi-cycle-patterns-extended.md)
- [Tier-3 borrowing (meta-patterns)](endo--packages-harden-make-hardener-js--canonical-harden-implementation-with-three-phase-traversal-and-commit-after-all-frozen--tier-3-borrowing-meta-patterns.md)
- [Synthesis-target](endo--packages-harden-make-hardener-js--canonical-harden-implementation-with-three-phase-traversal-and-commit-after-all-frozen--synthesis-target.md)
- [Library state after cycle 338](endo--packages-harden-make-hardener-js--canonical-harden-implementation-with-three-phase-traversal-and-commit-after-all-frozen--library-state-after-cycle-338.md)
