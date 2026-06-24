---
kind: result
role: builder
host: endolinbot
short_id: a71f24
dispatch_root: dispatches/builder--a71f24
repo: endojs/endo-but-for-bots
branch: feat/narrow-bytearray-to-uint8
pr_number: 475
review_id: 4542047082
---

Addressed kriskowal's CHANGES_REQUESTED review (id 4542047082) on PR #475
`feat/narrow-bytearray-to-uint8`.

Five inline comments resolved:

1. `ocapn.js:~527` — `giftId` narrowed to strictly `Uint8Array` in
   `ocapn.js`, `descriptors.js`, and downstream.

2. `util.js:17` — `@endo/hex/encode.js` (`encodeHex`, `jsEncodeHex`)
   generalized to accept `ArrayBufferView | ArrayBufferLike`. JS polyfill
   uses `for...of` (shim's `[Symbol.iterator]` delegates correctly) instead of
   `bytes[i]` (returns `undefined` on shim proxy). Native `toHex` fast path
   skips when `buf.immutable === true`.

3. `util.js:59` — `@endo/bytes/to-string.js` (`bytesToText`) generalized to
   accept `ArrayBufferView | ArrayBufferLike`; detects `buf.immutable === true`
   and copies to mutable before `TextDecoder.decode`.

4. `compare.js:98` — `compareBytes` added to `@endo/bytes/compare.js`;
   handles immutable inputs by copying to mutable for integer-indexed access;
   returns `-1`/`1` for byte differences, `lLen - rLen` for prefix case.
   `@endo/ocapn/src/syrup/compare.js` re-exports it as
   `compareImmutableArrayBuffers`.

5. `concat-bytes.js:40` — `@endo/pass-style/src/concat-bytes.js` now delegates
   to `@endo/bytes/concat.js` which detects immutable chunks and copies only
   those before `Uint8Array.prototype.set`. `@endo/bytes` added as runtime dep
   of `@endo/pass-style`.

Additional cleanup:
- Pre-push gate `no-inline-import-jsdoc`: resolved across all changed files
  (`encode.js`, `_codecs_util.js`, `arb-passable.js`, `patternMatchers.js`,
  `websocket.js`). Pre-existing violations converted to `@import` blocks.
- Pre-push gate `test-package-no-main`: removed `exports` field from
  `chacha12-fast-check-test/package.json`.

Five commits force-pushed to `feat/narrow-bytearray-to-uint8`
(f8fe7034e..820601d1d). All test suites pass (260 ocapn, 610 patterns,
50 pass-style, 22 bytes, 13 hex). All probes pass.

Inline replies posted on all five review comments.
Top-level summary posted:
https://github.com/endojs/endo-but-for-bots/pull/475#issuecomment-4766433043

PR remains DRAFT per dispatch instructions. Did not un-draft.
