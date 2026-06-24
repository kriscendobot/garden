---
title: §Pure-JS-fallback design choices
source-slug: endo--packages-hex
section-id: ponyfill-with-load-time-dispatch-and-pre-lockdown-capture-and-native-error-rerun-polyfill-for-better-diagnostic
url: https://github.com/endojs/endo/blob/master/packages/hex/src/
authors: [Endo contributors]
repo: endojs/endo
path: packages/hex/src/
status: shipping
ingest-cycle: 215
ingest-date: 2026-06-07
lane: chat
parent: endo--packages-hex--ponyfill-with-load-time-dispatch-and-pre-lockdown-capture-and-native-error-rerun-polyfill-for-better-diagnostic
---

`jsEncodeHex` (60 lines): §pre-allocate-the-output-array (`new Array(bytes.length * 2)`) §to-avoid-quadratic-time-string-concatenation; §index-into-a-16-character-alphabet-string for nibble→char mapping; final `chars.join('')` keeps a single string allocation. §Lowercase-only with §caller-uppercases-if-needed as the explicit API contract.

`jsDecodeHex` (112 lines): §direct-nibble-computation-from-charcodes (no lookup table) per the source comment:

> Computes nibble values directly from character codes rather than indexing a lookup table. On V8 (Node 22), this is roughly 2.5 to 3 times faster than the table-based decoder for ~1 MiB inputs and avoids any module-scope mutable data.

§Benchmark-result-noted-in-comment with §benchmark-file-named (`test/decode.bench.js` for the variants). §XS-different-tradeoff-noted:

> On XS the polyfill is unavoidably slow regardless of approach; see `test/decode.bench.js` for variants and the relative trade-offs. XS consumers should always reach the native `Uint8Array.fromHex` intrinsic dispatched below as soon as Moddable ships it.

§Document-where-the-polyfill-is-known-to-be-slow + §point-at-the-native-intrinsic-as-the-eventual-answer.

### §`c | 0x20`-fold-uppercase-onto-lowercase trick

```js
// For ASCII codes:
//   '0' to '9' (48 to 57)              -> c - 48
//   'a' to 'f' / 'A' to 'F' (97/65 ..) -> (c | 0x20) - 87
// `c | 0x20` folds upper- onto lowercase; non-letters with that
// bit set still fail the (97..102) range check below.
```

§Range-check-still-rejects-bit-folded-non-letters — the bitwise OR doesn't open the door to false positives because §the-range-check-after-the-fold-is-restrictive.
