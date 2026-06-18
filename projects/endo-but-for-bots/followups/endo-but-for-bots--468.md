---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 468
created_at: 2026-06-18T08:49:53Z
last_appended_at: 2026-06-18T08:49:53Z
status: parked
---

# Follow-ups for endo-but-for-bots#468

## Items

- [ ] `@endo/bytes` README does not document that `bytesToImmutable`'s result can now be used as a TypedArray backing store after loading the shim.  
  **Source juror(s)**: integrator  
  **Round**: 1  
  **Recommended action**: append a sentence or example to `packages/bytes/README.md` showing `new Uint8Array(bytesToImmutable(view))` produces a freezable wrapper

- [ ] No test pins the subclassing limitation at the emulated-immutable branch. `class MyArr extends Uint8Array {}; new MyArr(iab) instanceof MyArr === false` is the expected behavior per the design doc's "Out of scope" section, but no test asserts it.  
  **Source juror(s)**: corner-prober  
  **Round**: 1  
  **Recommended action**: add one test in `shim-typedarray.test.js` (or `lib-typedarray.test.js`) that asserts the current subclassing shape explicitly

- [ ] `designs/freezable-typedarray.md` § Semantics § Indexed assignment lacks a reference to ECMA-262 § 10.4.2 (Integer-Indexed Exotic Objects) explaining why the limitation is fundamental.  
  **Source juror(s)**: pedant  
  **Round**: 1  
  **Recommended action**: amend the design doc to cite the spec section

- [ ] `test/shim-typedarray-per-flavor.test.js` could grow to include `fast-check`-style boundary tests for `byteOffset`+`length` constructor arguments across all eleven flavors.  
  **Source juror(s)**: fast-checker  
  **Round**: 1  
  **Recommended action**: open a follow-up PR adding property-based tests once `fast-check` is confirmed as a dev dependency for this package

- [ ] `README.md` has a pre-existing "TypeArray" typo (not introduced by this PR) in the Background section.  
  **Source juror(s)**: pedant  
  **Round**: 1  
  **Recommended action**: correct to "TypedArray" in a follow-up cleanup commit
