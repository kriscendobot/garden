---
title: §The triplet-pedagogy — three points define the pattern
source-slug: endo--packages-pass-style-src-copyRecord-js
section-slug: CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-between-phases-varies
source-url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/copyRecord.js
source-repo: endojs/endo
source-path: packages/pass-style/src/copyRecord.js
source-author: Endo project (collective)
total-lines: 70
ingest-cycle: 264
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-pass-style-src-copyRecord-js--CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-between-phases-varies
---

| Cycle | Helper            | Substrate                          | Phase-1 work                                                | Phase-2 work                                              | Side-channel arithmetic              | Notes                          |
|-------|-------------------|------------------------------------|-------------------------------------------------------------|-----------------------------------------------------------|--------------------------------------|--------------------------------|
| 260   | ByteArrayHelper   | Immutable ArrayBuffer (stage-3)    | `instanceof ArrayBuffer && candidate.immutable`             | prototype-identity + immutability + `ownKeys.length === 0`| `=== 0`                              | Adapter-factory needed         |
| 262   | CopyArrayHelper   | `Array` (universal)                | `isArray(candidate)`                                        | prototype-identity + length-shape + each-index + count    | `=== len + 1`                        | No adapter-factory             |
| 264   | CopyRecordHelper  | `Object` with `Object.prototype`   | object-prototype + each-key-string + each-value-not-method  | recursive walk only                                       | (no count-invariant)                 | Phase-1 does more work         |

§Three-points-of-variation-now-visible-across-the-triplet:

1. **§adapter-factory-presence varies**: byteArray needs one (stage-3 proposal); copyArray and copyRecord don't (universal intrinsics).
2. **§side-channel-arithmetic varies**: byteArray uses `=== 0` (no own keys); copyArray uses `=== len + 1` (length + indices); copyRecord uses **no count check at all** because §a-record's-key-set-has-no-canonical-count-invariant.
3. **§work-distribution-between-phases varies**: byteArray and copyArray do most work in phase-2; **copyRecord moves more work into phase-1** (the per-property key+value guard) and leaves phase-2 with only the recursive walk.

§First-explicit-observation in library: **§the-work-distribution-between-phases-varies-per-helper — §each-helper-puts-pass-style-specific-validation-in-the-phase-where-it-belongs**.

§First-explicit-observation in library: **§the-triplet-is-the-pedagogy-better-than-the-pair-because-three-points-define-a-pattern**.
