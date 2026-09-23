---
title: §assertRestValid carries four-line validity check (one more line than byteArray)
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

The phase-2 check has **four orthogonal rejection criteria** (one more than byteArray's three):

1. **§Prototype-identity** — `getPrototypeOf(candidate) === arrayPrototype` (lines 20-21). Strict equality, not instanceof.
2. **§Length-property-shape** — `confirmOwnDataDescriptor(candidate, 'length', false, Fail)` validates that `length` is an own data property (not an accessor; not inherited). `false` says non-enumerable is OK (Array.prototype.length is canonically non-enumerable).
3. **§Each-index-shape-and-recursive-passable** — loop from `0` to `len-1`; each index validated via `confirmOwnDataDescriptor(candidate, i, true, Fail)` (the `true` says enumerable required); each value recursively walked via `passStyleOfRecur`.
4. **§Index-property-count-check** — `ownKeys(candidate).length === len + 1` — the `+1` accounts for `length`; this rejects sparse arrays AND arrays with extra non-index own properties.

§Four-line-validity-check-with-four-orthogonal-rejection-criteria — one more than byteArray's three because §a-copyArray-has-internal-structure-(indices)-that-byteArray-does-not.

§First-explicit-observation in library: **§the-validity-check-arity-correlates-with-the-internal-structure-of-the-pass-style** — §byteArray-has-no-internal-structure-only-three-lines + §copyArray-has-indices-so-four-lines + §the-checks-arise-from-the-shape-of-the-thing-being-validated.
