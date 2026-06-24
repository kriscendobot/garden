---
title: §The "ensured" comment as named invariant
source-slug: endo--packages-pass-style-src-copyArray-js
section-slug: CopyArrayHelper-as-PassStyleHelper-second-concrete-instance-and-index-property-count-check-and-passStyleOfRecur-callback-and-no-feature-detection-because-Array-is-universal
source-url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/copyArray.js
source-repo: endojs/endo
source-path: packages/pass-style/src/copyArray.js
source-author: Endo project (collective)
total-lines: 38
ingest-cycle: 262
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-pass-style-src-copyArray-js--CopyArrayHelper-as-PassStyleHelper-second-concrete-instance-and-index-property-count-check-and-passStyleOfRecur-callback-and-no-feature-detection-because-Array-is-universal
---

Lines 22-23 (the canonical doc-comment-IS-the-contract sibling):
```
// Since we're already ensured candidate is an array, it should not be
// possible for the following get to fail.
```

§The-comment-IS-the-evidence-of-the-load-bearing-invariant:

- §the-confirmCanBeValid-step-has-already-confirmed-candidate-is-an-array.
- §therefore-the-`length`-property-MUST-exist-and-be-an-own-data-descriptor.
- §but-the-helper-validates-it-anyway-because-defense-in-depth + §the-comment-documents-the-redundancy.

§First-explicit-observation in library: **§the-comment-documents-the-redundancy-of-a-defense-in-depth-check** — §the-helper-could-skip-the-`length`-validation-after-confirmCanBeValid + §but-defense-in-depth-requires-validating-the-thing-the-helper-doesn't-trust-came-through-its-own-confirmCanBeValid.

§Four-cycles-with-doc-comment-IS-the-contract (253 + 257 + 260 + 262); §discipline-now-reified-at-four-cycles.
