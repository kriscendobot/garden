---
title: The single most structurally interesting move
source: endo--packages-promise-kit-src-memo-race-js
url: https://github.com/endojs/endo/blob/master/packages/promise-kit/src/memo-race.js
authors: [Brian Kim (original), Endo project (adopted)]
repo: endojs/endo
path: packages/promise-kit/src/memo-race.js
total-lines: 170
ingest-cycle: 336
ingest-date: 2026-06-15
lane: chat
section-tags:
  - the-named-deviation-named-in-the-source-too
  - the-named-implementation-of-the-accommodation
  - the-named-public-domain-license-header-preserved-verbatim
  - the-named-attribution-discipline-when-adopting-public-domain-code
  - the-named-explicit-acknowledgment-of-cross-package-layering-constraint
  - the-named-name-both-the-goal-and-the-obstacle
  - the-named-helpers-private-export-single-public
  - the-named-export-the-noun-not-the-verbs
  - the-named-in-place-transition-for-shared-references
  - the-named-assign-then-freeze-transition
  - the-named-fake-record-honors-real-record-discipline
  - the-named-named-function-via-object-destructure
  - the-named-api-name-vs-impl-name-asymmetry
  - the-named-JSDoc-generic-this-binding
  - the-named-cachedValues-defends-against-one-shot-iterables
  - the-named-complementary-lens-re-ingest
  - the-named-streak-resumes-after-one-cycle-gap
  - five-cycles-with-named-complementary-lens-re-ingest
  - twenty-seven-cycles-with-named-pivot-domain-stay
  - fifty-citation-arc-closures-in-pivot-now
parent: endo--packages-promise-kit-src-memo-race-js--fifth-complementary-lens-deviation-named-in-the-source-too
---

**§the-named-deviation-named-in-the-source-too** — line 127-128 of memo-race.js, in the `race` method's JSDoc:

```js
/**
 * Creates a Promise that is resolved or rejected when any of the provided Promises are resolved
 * or rejected.
 *
 * Unlike `Promise.race` it cleans up after itself so a non-resolved value doesn't hold onto
 * the result promise.
 * ...
 */
```

The README at cycle 335 made the abstract ponyfill claim (*"making certain accommodations to ensure that the resulting promises can pipeline messages through `@endo/eventual-send`"*). The SOURCE at cycle 336 **names the deviation explicitly in JSDoc**: *"Unlike `Promise.race` it cleans up after itself"*.

**§the-named-implementation-of-the-accommodation** — first-explicit-observation. The README's abstract claim about *"certain accommodations"* (cycle 335) materializes in the source's JSDoc statement of the divergence (cycle 336). The implementation does not silently diverge; the divergence is **named at the API surface** so callers reading the JSDoc know what they're getting that `Promise.race` doesn't give them.

**§the-named-deviation-named-in-the-source-too** — first-explicit-observation as a tier-3 meta-pattern. The discipline: when a README claims deliberate divergence from a standard (cycle 335's *§the-named-deliberately-imperfect-ponyfill*), the source should ALSO name that divergence at the JSDoc level, not just in the README. Two levels of honesty: package-level (README) + symbol-level (JSDoc). **§the-named-honesty-at-two-levels-discipline** — first-explicit-observation as a related meta-pattern.

This is the **implementation-side closure** of cycle 335's *deliberately-imperfect-ponyfill* claim. **§the-named-citation-arc-from-cycle-335-takes-1-cycle-to-close** as an *implementation-of-the-deliberate-imperfection* arc. The eighth INSTANCE of the one-cycle README↔source pattern (counted as a discipline-application count, not a streak — cycle 334 → 335 broke the §seven-cycles-with-named-one-cycle-README-source-arc streak; cycle 335 → 336 is one cycle, but isolated). **§the-named-streak-resumes-after-one-cycle-gap** — first-explicit-observation as a discipline-resumption.
