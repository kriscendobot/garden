---
title: "@endo/pass-style/src/copyRecord.js — CopyRecordHelper third PassStyleHelper concrete instance, completing the leaf-helper triplet"
source-slug: endo--packages-pass-style-src-copyRecord-js
url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/copyRecord.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/pass-style/src/copyRecord.js
total-lines: 70
ingest-cycle: 264
ingest-date: 2026-06-10
lane: chat
---

# `@endo/pass-style/src/copyRecord.js`

A 70-line file that exports `CopyRecordHelper` for the `'copyRecord'` pass-style. **Third concrete instance** of the `PassStyleHelper` shape — completing the cluster's **triplet-of-leaf-pass-style helpers** (cycle 260 byteArray + cycle 262 copyArray + cycle 264 copyRecord). Three points define the pattern.

## Key moves

- **§Third PassStyleHelper concrete instance** — §the-triplet-IS-the-pedagogy; §three-points-define-the-pattern-better-than-two.
- **§The work-distribution-between-phases varies per helper** — copyRecord puts the per-property guard in **phase-1** (confirmCanBeValid) and leaves phase-2 with only the recursive walk; byteArray and copyArray do it the other way. §first-explicit-observation in library.
- **§The three-concerns-template with named local helpers extracted** — when confirmCanBeValid needs multiple checks, extract each into a named local function (`confirmObjectPrototype` + `confirmPropertyCanBeValid`); §the-`confirm`-prefix-IS-the-naming-convention. §first-explicit-observation in library.
- **§Cross-helper-cluster disambiguation import** — `canBeMethod` from `./remotable.js` because §a-CopyRecord-could-be-confused-with-a-Remotable; §when-one-pass-style-could-be-confused-with-another, §the-helper-imports-the-other-helper's-detector-to-reject-the-overlap. §first-explicit-observation in library.
- **§The `@import` via JSDoc-block pattern with multiple typedefs** — `Rejector` from `@endo/errors/rejector.js` and `PassStyleHelper` from `./internal-types.js`. §types-only-imports-via-JSDoc-`@import`.
- **§Three orthogonal kinds of side-channel-defense across the triplet** — count-zero (byteArray) + count-equal-to-len-plus-1 (copyArray) + per-key-and-per-value-rules (copyRecord). §first-explicit-observation in library.
- **§Key-must-be-string discipline** — rejects symbol-keyed properties.
- **§Value-must-not-be-method-like discipline** — `!canBeMethod(value)` because §a-method-shaped-value-suggests-this-IS-secretly-a-Remotable.
- **§Honest-TODO acknowledging design drift without fix** — *"Update message now that there is no such thing as 'implicit Remotable'"*.
- **§`.every()` short-circuits at first rejection** — fail-fast iteration with named property identification.
- **§Three cycles with direct-prototype-equality as canonical validation** (260 immutableArrayBufferPrototype + 262 arrayPrototype + 264 objectPrototype).

## Section files

- [§CopyRecordHelper third PassStyleHelper + §two named local helper functions + §canBeMethod guard against implicit-Remotable + §work-distribution-between-phases varies](../sections/endo--packages-pass-style-src-copyRecord-js--CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-between-phases-varies.md) — full 70-line file in scope.

## Ingest scope

Cycle 264 (chat-lane after cycle 263's designs-lane outliner-design-doc-2). Full 70-line file ingested. **First-explicit-observations (eight)**: §the-triplet-is-the-pedagogy-better-than-the-pair-because-three-points-define-a-pattern + §the-work-distribution-between-phases-varies-per-helper + §the-three-concerns-template-with-named-local-helpers-extracted + §cross-helper-cluster-disambiguation-import-when-one-pass-style-must-distinguish-itself-from-another + §the-`@import`-via-JSDoc-block-pattern-with-multiple-typedefs + §extracting-the-canonical-prototype-check-into-a-named-local-function-is-the-shape-the-third-instance-takes + §the-cross-cluster-disambiguation-discipline + §the-side-channel-defense-takes-three-forms-across-the-triplet.
