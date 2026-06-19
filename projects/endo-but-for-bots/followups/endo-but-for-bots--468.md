---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 468
created_at: 2026-06-18T08:49:53Z
last_appended_at: 2026-06-18T09:07:12Z
status: in-progress
followup_pr: 472
---

# Follow-ups for endo-but-for-bots#468

Items 1, 2, 3, and 4 are addressed in PR #472 (`chore: act on #468 postponed review items`).
Items 6, 7, and 8 were addressed in the #468 merged PR's summary-fix bundle.
Item 5 (fast-check tests) remains parked pending fast-check dev-dep confirmation.

## Items

- [x] `@endo/bytes` README does not document that `bytesToImmutable`'s result can now be used as a TypedArray backing store after loading the shim.
  **Source juror(s)**: integrator
  **Round**: 1
  **Recommended action**: append a sentence or example to `packages/bytes/README.md` showing `new Uint8Array(bytesToImmutable(view))` produces a freezable wrapper
  **Closed in**: PR #472 commit `1c946a176`

- [x] No test pins the subclassing limitation at the emulated-immutable branch. `class MyArr extends Uint8Array {}; new MyArr(iab) instanceof MyArr === false` is the expected behavior per the design doc's "Out of scope" section, but no test asserts it.
  **Source juror(s)**: corner-prober
  **Round**: 1
  **Recommended action**: add one test in `shim-typedarray.test.js` (or `lib-typedarray.test.js`) that asserts the current subclassing shape explicitly
  **Closed in**: PR #472 commit `0354d0e54`

- [x] `designs/freezable-typedarray.md` section Semantics section Indexed assignment lacks a reference to ECMA-262 section 10.4.2 (Integer-Indexed Exotic Objects) explaining why the limitation is fundamental.
  **Source juror(s)**: pedant
  **Round**: 1
  **Recommended action**: amend the design doc to cite the spec section
  **Closed in**: PR #472 commit `61ce83ae1`

- [ ] `test/shim-typedarray-per-flavor.test.js` could grow to include `fast-check`-style boundary tests for `byteOffset`+`length` constructor arguments across all eleven flavors.
  **Source juror(s)**: fast-checker
  **Round**: 1
  **Recommended action**: open a follow-up PR adding property-based tests once `fast-check` is confirmed as a dev dependency for this package
  **Status**: still parked; mentioned in PR #472 body

- [x] `README.md` has a pre-existing "TypeArray" typo (not introduced by this PR) in the Background section.
  **Source juror(s)**: pedant
  **Round**: 1
  **Recommended action**: correct to "TypedArray" in a follow-up cleanup commit
  **Closed in**: PR #472 commit `b529705ce`

- [x] `test/shim-typedarray.test.js`: no test for chained `view.subarray(a,b).subarray(c,d).buffer === iab`. The mechanism is provably correct (reverseBuffers maps the genuine backing buffer regardless of nesting depth) but an explicit regression test would protect future refactors.
  **Source juror(s)**: corner-prober
  **Round**: 2
  **Recommended action**: add one test in `shim-typedarray.test.js` asserting the double-subarray buffer-contract
  **Closed in**: #468 summary-fix bundle (chained subarray assertion)

- [x] `src/lib.js` (cleaner commit `a04fbe7af`): JSDoc `{Function} [predicate]` on callback-required methods (`every`, `some`, `find`, `findIndex`, `findLast`, `findLastIndex`, `forEach`, `map`, `reduce`, `reduceRight`) marks mandatory parameters as optional. Worth correcting in a follow-up.
  **Source juror(s)**: typist
  **Round**: 2
  **Recommended action**: change `[predicate]` to `predicate` and `[callback]` to `callback` on methods where the parameter is spec-required
  **Closed in**: #468 summary-fix bundle

- [x] `test/shim-typedarray.test.js` (subarray test): does not assert `sub.byteOffset`. `view.subarray(1,3).byteOffset` should be `1`; an explicit assertion would pin the amplifier-delegate path for offset values.
  **Source juror(s)**: prover
  **Round**: 2
  **Recommended action**: add `t.is(sub.byteOffset, 1)` to the existing subarray test
  **Closed in**: #468 summary-fix bundle (`t.is(sub.byteOffset, 1)` assertion)
