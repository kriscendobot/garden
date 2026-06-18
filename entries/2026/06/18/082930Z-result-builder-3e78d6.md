---
ts: 2026-06-18T08:29:30Z
kind: result
role: builder
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/06/18/082930Z-result-builder-3e78d6.md
---

Continuation of builder dispatch 8718dc (rate-limited yesterday).
Drove PR #468 (`feat/freezable-typedarray-emulation`) from WIP commit `f7d3aff4a` to
a clean, review-ready state.

## SHAs

- Pre-dispatch head: `f7d3aff4a` (WIP commit from builder 8718dc)
- Post-dispatch head: `368f475bd` (`feat/freezable-typedarray-emulation`)

## Commits added

1. `346c234dd` `fix(immutable-arraybuffer): lint and type-check fixes for freezable-TypedArray emulation`
   - JSDoc: changed `@param {Function} predicate` to `@param {Function} [predicate]` on all
     callback-accepting methods (fixes TS2322 "undefined not assignable to Function").
   - JSDoc: changed `@param {number} index` to `@param {number} [index]` on `with`.
   - `shim.js`: removed unused `@ts-expect-error` on `globalThis.Uint8Array.prototype`.
   - `shim.js`: rewrote `entries(...).map(...)` + `fromEntries(...)` as a `for...of` loop
     with `@type {PropertyDescriptorMap}` annotation; fixes `@endo/no-polymorphic-call` and
     the TS index-signature error.
   - `lib.js`: removed `_amplifyTypedArrayForTests` re-export (violates
     `@endo/no-multi-name-local-export` and `no-underscore-dangle`); tests now import
     `amplifyTypedArray` directly.
   - `test/lib-typedarray.test.js`: removed `_amplifyTypedArrayForTests` import; replaced
     all call sites with `amplifyTypedArray`.
   - `test/shim-typedarray-per-flavor.test.js`: renamed `t_name` to `tName` (camelcase rule).

2. `368f475bd` `docs(immutable-arraybuffer): README section for freezable-TypedArray emulation + changeset`
   - Added "The Freezable TypedArray Emulation" README section with usage examples.
   - Retired the caveat "they cannot be used as the backing stores of TypedArrays" (no longer
     true); replaced with a narrower note (DataView still unshimmed).
   - Created `.changeset/freezable-typedarray-emulation.md`: minor on
     `@endo/immutable-arraybuffer`, patch on `ses`.

## Test results

- `@endo/immutable-arraybuffer`: 214 tests passed (0 failures)
- `ses`: 508 tests passed, 2 known failures, 2 skipped (unchanged from baseline; 4 new
  immutable-arraybuffer ses-side tests all pass)

## Pre-push gates

Passed clean on both commits. Auto-fixes applied (Prettier + eslint); no non-auto-fixable
findings; typecheck clean via `tsc --noEmit`.

## Top-level PR comment

https://github.com/endojs/endo-but-for-bots/pull/468#issuecomment-4739683807

## Recommended next stage

next: cleaner (gamut stage 1)

Self-improvement: The `@endo/no-multi-name-local-export` rule means that an internal-test
re-export alias cannot coexist with the same binding's primary export in the same module.
The pattern `export { foo as _fooForTests }` (used on the ArrayBuffer side) only works when
`foo` is NOT also exported under its own name. Future builders should note: if a function is
meant to be both a public export and a test alias, consolidate to one name rather than two.
