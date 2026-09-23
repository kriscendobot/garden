All done. Empty inbox, work complete.

## Completion report

**Job:** Answer @erights's `isTypedArray` / `ArrayBuffer.isView` review on endojs/endo-but-for-bots PR #475.

**Investigation (verified empirically, not asserted):**
- `Object.freeze(new Uint8Array([1,2,3]))` throws `TypeError`; `Object.freeze(new DataView(...))` succeeds. The `%TypedArray%[Symbol.toStringTag]` getter returns a tag for a TypedArray and `undefined` for a `DataView`; `ArrayBuffer.isView` is `true` for **both**.
- Mapped all three surviving getter sites: `ses/make-hardener.js` + its duplicate `harden/make-hardener.js` (the `freezeTypedArray` special-case, which exists *only* because `Object.freeze` throws on integer-indexed exotics — a `DataView` is not one), and `pass-style/passStyleOf.js:169/202` via `passStyle-helpers.js` (diagnostic "mutable typed arrays" message).
- Confirmed `byteArray.js`'s `isView` commitment answers a *different* question — emulated-wrapper vs native exotic on an **already-`Uint8Array`-narrowed** candidate, where `DataView` is already excluded.

**Decision (per site): keep the getter at all three; swap none to `isView`.** `isView` would be strictly less precise — misrouting `DataView` through `freezeTypedArray` in `harden`, and mislabeling a `DataView` as a "mutable typed array" in `passStyleOf` — with no offsetting benefit (both are equally spoof-proof internal-slot brand checks). The earlier `isView`-commit passes correctly left these alone; they were not an oversight.

**Code changes (commit `3995de4fb`, pushed to `feat/narrow-bytearray-to-uint8`):**
- Added in-code rationale comments at all three getter sites (ses + pass-style kept in sync).
- Fixed two stale duplicate-path references (the `make-hardener.js` copies pointed at a long-gone `packages/marshal/src/helpers/passStyle-helpers.js` → now `packages/pass-style/src/passStyle-helpers.js`).
- Added a `DataView` negative case to `ses/test/is-typed-array.test.js` pinning the exact getter-vs-`isView` divergence.
- Verified: prettier clean, eslint clean on all four files, `is-typed-array` + `make-hardener` suites green. No new changeset needed (`.changeset/narrow-bytearray-to-uint8.md` already covers `@endo/ses`, `@endo/pass-style`, `@endo/harden`; changes are comment/test-only).

**Reply:** posted one comment answering all five numbered questions and stating what changed — https://github.com/endojs/endo-but-for-bots/pull/475#issuecomment-5347368714 (did not resolve the thread, per never-resolve-review-thread).

**Follow-ups:** none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-endo475-istypedarray-isview.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (2219762 cached reads)
- Output: 26429 tokens
- Cost: $2.567192
- Wall-clock: 417s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
