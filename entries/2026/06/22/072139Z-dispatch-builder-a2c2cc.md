---
kind: dispatch
role: builder
host: endolinbot
posture: liaison
short_id: a2c2cc
dispatch_root: dispatches/builder--a2c2cc
repo: endojs/endo-but-for-bots
branch: feat/narrow-bytearray-to-uint8
pr_number: 475
model: sonnet
---

RSVP kriskowal's inline review-comment on PR #475
(id 3450413930, 2026-06-22T07:18:59Z):

> Please, for purposes of investigation, remove all of the
> `@endo/bytes/*-immutable*.js` modules and move these into
> `@endo/pass-style/*-bytes.js` modules like `concat-bytes.js`
> (`concatBytes`), `to-bytes.js` (`toBytes`, implying from mutable
> Uint8Array), `from-bytes.js` (`fromBytes` implying to mutable
> Uint8Array), `bytes-from-hex.js` (`bytesFromHex`), &c. I am hoping
> to see whether the impact of that change would improve or reduce
> clarity and ergonomics.

User authorized in-place refactor on the existing PR
(2026-06-22T07:21Z).

Constraints from the maintainer's comment body:
- After the move, "immutable" in `@endo/bytes/*-immutable.js` should
  no longer be used to refer to the immutable concept; the immutable
  modules disappear from `@endo/bytes` entirely.
- `@endo/bytes` then concerns only mutable Uint8Arrays.
- `@endo/pass-style` gains the passable-byte-array utility modules.
- The package is fresh enough to break the interface freely, but
  bump the major version in principle.
