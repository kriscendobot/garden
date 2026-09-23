Done. Final completion report:

---

## Completion report — job `endojs-endo-but-for-bots-pr475-14cfb16e`

**Directive:** erights's review comment (r3496523848) on endojs/endo-but-for-bots PR #475 asked where `compareBytes` rejects input that is not a genuine integer-indexed `Uint8Array` — observing it does not, and "simply completes successfully with the wrong answer and no diagnostic."

**Diagnosis (confirmed valid).** `@endo/bytes`'s `compareBytes`, `bytesEqual`, and `concatBytes` read each byte through the integer-indexed protocol (`array[i]`, `array.set(...)`). An emulated frozen byteArray wrapper (a plain object inheriting from `Uint8Array.prototype` with no integer-indexed bytes, the `@endo/immutable-arraybuffer` shape) answers those reads with `undefined`, so the readers silently produced garbage. The package README already *promised* these functions "will throw" on such input, but the code did not enforce it.

**What I did (commit `4f5192232`, pushed to `feat/narrow-bytearray-to-uint8`):**
- Added `packages/bytes/src/genuine-uint8-array.js` exporting `assertGenuineUint8Array` — a dependency-free brand check using the captured `%TypedArray%.prototype[Symbol.toStringTag]` getter (the same check `@endo/pass-style` and SES's hardener use). Accepts only a genuine `Uint8Array`; otherwise throws a `TypeError` naming the bad argument and the repair (thaw to a mutable `Uint8Array`).
- Asserted every `Uint8Array` argument up front in `compare.js`, `equals.js`, and `concat.js` (generalizing erights's point to the two sibling readers with the identical footgun).
- Updated the README API section and the existing changeset to document the now-enforced contract.
- Added 8 tests (genuine accept; reject of emulated wrapper, other typed arrays, and non-arrays; per-function rejection) plus genuine happy-path coverage for `compareBytes`, which the bytes package previously did not test at all.

**Verification:** `@endo/bytes` 20 tests pass across all three lockdown configs (lockdown/unsafe/endo); `tsc` and `eslint` clean. Dependents unaffected: `@endo/marshal` 79 pass (1 pre-existing skip), `@endo/ocapn` 261 pass — the real callers already thaw to a mutable `Uint8Array` before calling in, so the guard is purely additive.

**Communication (standing endo-but-for-bots authorization; erights holds maintainer-equivalent authority on pass-style/bytes):**
- Inline reply on the thread: pull/475#discussion_r3496570793
- Top-level summary comment: pull/475#issuecomment-4840466127
- Journal `result`: `entries/2026/06/30/061931Z-result-gardener-69b6bb.md`

**Scope notes / follow-ups:** PR stays **Draft** per its standing "DRAFT until @kriskowal says otherwise" note — I only addressed the review comment. The separate unresolved question on the same file (r3496506517, lexicographic vs short-lex, erights→gibson042) is a semantics decision and was left untouched. The pre-existing kriskowal `CHANGES_REQUESTED` reviews on this PR are out of scope for this directive.

**Self-improvement:** nothing this time.
