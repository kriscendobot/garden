---
title: §confirmOwnDataDescriptor — the shared validation helper
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

The helper is imported from `./passStyle-helpers.js` (the cluster's shared utilities — documented at the [helpers-cluster sibling](endo--packages-pass-style-helpers-cluster--PassStyleHelper-uniform-shape-and-two-phase-validation-and-styleName-confirmCanBeValid-assertRestValid-and-rest-spread-collects-everything-not-named.md) page). Its job: validate that a property is `{ value, writable: any, enumerable: <param>, configurable: any }`-shaped (not an accessor).

§Four-argument signature visible in the call sites: `confirmOwnDataDescriptor(candidate, key, enumerableRequired, rejecter)`:

- `candidate` — the object whose property is being validated.
- `key` — the property name (`'length'` or numeric index).
- `enumerableRequired` — boolean; `false` for `length` (which is canonically non-enumerable on arrays), `true` for indices (which must be enumerable to be visible to iteration).
- `rejecter` — `Fail` template-tag callback; thrown if validation fails.

§Three-named-arguments-of-the-shared-helper-each-encode-a-discipline:
- §the-property-must-be-own (no inheritance).
- §the-property-must-be-a-data-descriptor (no accessor side-effects).
- §the-property-enumerability-MAY-be-controlled-per-call (because indices and length differ).

§First-explicit-observation in library: **§confirmOwnDataDescriptor-as-named-cluster-helper-for-property-shape-validation-with-enumerability-as-a-per-call-parameter**.
