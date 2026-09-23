---
kind: dispatch
role: builder
host: endolinbot
posture: liaison
short_id: 383676
dispatch_root: dispatches/builder--383676
repo: endojs/endo-but-for-bots
branch: feat/narrow-bytearray-to-uint8
pr_number: 475
model: sonnet
---

RSVP kriskowal's CHANGES_REQUESTED review on PR #475 (review id
4546639717, 2026-06-22T17:54:22Z). New direction after the prior
round's investigation showed that `@endo/bytes` cannot reasonably
be reused for passable byte arrays without forced memcopy.

Inline ask (`packages/bytes/src/compare.js:44`, comment 3454267360):
> No reasonable way to reuse `@endo/bytes` for passable byte arrays
> from `@endo/pass-style`. Need fully parallel set of routines in
> pass-style entangled with the underlying mutable storage of
> immutable byte arrays. Keep `@endo/bytes` ignorant of byte arrays
> (reallocation cost too high for ordinary manipulations).
> `@endo/pass-style` may use `@endo/bytes` routines internally on
> the underlying mutable storage.

Review-body new direction:
1. Rename `bytesToString`/`bytesFromString` to `encodeUtf8`,
   `decodeUtf8`, `strictDecodeUtf8` (fatal variant) — consistent
   with `encodeHex`/`decodeHex` and `encodeBase64`/`decodeBase64`.
2. Create new `@endo/utf8` package using web TextEncoder/TextDecoder
   by default. Remove utf-8 transcoding from `@endo/bytes`.
3. Parallel set of modules (in `@endo/pass-style` or
   `@endo/immutable-arraybuffer`) entangled with the shim's internals
   to transcode without forced memcopy.
4. The maintainer notes @erights may disagree and prefer to suffer
   the memcopy under the shim (short-lived); consider creating an
   alternative PR exploring the ponyfill approach at
   `@endo/pass-style/encode-utf8.js`, `@endo/pass-style/decode-hex.js`,
   etc. that degrade to copy when shimmed.

Either way: reuse `@endo/bytes` internally on hidden mutable storage
or original storage. Major-version bump on `@endo/bytes` is in
scope.
