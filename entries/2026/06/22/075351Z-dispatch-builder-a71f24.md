---
kind: dispatch
role: builder
host: endolinbot
posture: liaison
short_id: a71f24
dispatch_root: dispatches/builder--a71f24
repo: endojs/endo-but-for-bots
branch: feat/narrow-bytearray-to-uint8
pr_number: 475
model: sonnet
---

RSVP kriskowal's CHANGES_REQUESTED review on PR #475 (review id
4542047082, 2026-06-22T07:52:01Z, body: "Please accept specific
feedback as general and apply as broadly as possible").

Five inline asks (all unresolved):
1. `packages/ocapn/src/client/ocapn.js:527` — "strictly one or the
   other and not tolerate both."
2. `packages/ocapn/src/client/util.js:17` — generalize `@endo/hex`
   to encode frozen Uint8Array on immutable ArrayBuffer without
   expensive cast.
3. `packages/ocapn/src/client/util.js:59` — utf-8 encoding of byte
   arrays should not require expensive cast; either
   `@endo/bytes/to-text.js` handles byte arrays gracefully, or a new
   `@endo/utf8` package.
4. `packages/ocapn/src/syrup/compare.js:98` — should be
   `@endo/bytes/compare.js` handling both byte arrays and mutable
   Uint8Arrays.
5. `packages/pass-style/src/concat-bytes.js:40` — interior could
   reuse mutable `@endo/bytes/concat.js`.

General pattern (the maintainer's meta directive): byte-array
utilities should accept BOTH the byte-array form (frozen Uint8Array
on immutable ArrayBuffer) and the mutable-Uint8Array form
gracefully — same runtime behavior, no expensive intermediate copy.
The implementations belong in `@endo/bytes` (or new sibling packages
like `@endo/utf8`); pass-style and ocapn delegate.

User authorized the in-place refactor on PR #475
(2026-06-22T07:21Z); this iteration is the continuation.
