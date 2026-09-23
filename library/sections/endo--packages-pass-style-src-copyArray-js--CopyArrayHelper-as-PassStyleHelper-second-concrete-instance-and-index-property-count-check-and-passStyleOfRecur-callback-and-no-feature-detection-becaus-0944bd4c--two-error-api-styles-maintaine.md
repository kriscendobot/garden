---
title: §Two error-API styles maintained — cycle-260 pattern continues
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

Lines 21, 25, 31, 36:
- `assert.fail(X\`...\`, TypeError)` — structural rejections (prototype mismatch, count mismatch).
- `Fail` — passed *into* `confirmOwnDataDescriptor` as the rejecter for descriptor validation (semantic delegation).

§The-two-error-API-styles in copyArray match the byteArray pattern; §two-cycles-with-two-error-API-styles-encoding-distinction-between-structural-and-semantic-rejection (260 + 262); §discipline-now-emergent-pattern.

§The-Fail-callback-passed-INTO-the-shared-helper is a new variation — §the-rejecter-is-an-argument-to-the-shared-helper rather than thrown directly; §the-shared-helper-decides-when-to-call-it; §callback-based-rejection-API; §first-explicit-observation in library of §callback-based-rejection-API-where-the-rejecter-is-passed-into-a-shared-validation-helper.
