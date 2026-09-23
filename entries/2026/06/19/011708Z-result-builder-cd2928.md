---
ts: 2026-06-19T01:17:08Z
kind: result
role: builder
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
---

Opened DRAFT PR endojs/endo-but-for-bots#473
`feat/pass-style-byte-array-plain-frozen-validation` against frozen base
`master-80e9b3e`, per @erights's request on merged PR #468 issue
comment 4747340575 to extend `packages/pass-style/src/byteArray.js` to
accept a plain frozen `Uint8Array` whose backing buffer is a plain frozen
immutable `ArrayBuffer` as the `byteArray` pass style.

Implementation in two commits:

- `feat(pass-style): validate plain frozen Uint8Array on immutable buffer as byteArray` (0434d6c38)
- `test(pass-style): cover plain frozen Uint8Array validation` (3cbc6e4ac)

The "plain" definition: the wrapper has only canonical integer-index own
properties in `[0, length)`, each an enumerable data property whose
value equals the byte the wrapper reads through
`%TypedArrayPrototype%.at`. On the emulated path that captured method
goes through the shim-installed amplifier and reads from the hidden
genuine TypedArray; on a future native path it reads via the
integer-indexed exotic. The two paths converge on the same accept /
reject contract. The backing-buffer sub-check reuses the existing
immutable-`ArrayBuffer` arm verbatim.

@erights's request also asked to fix any enumerability deviation in the
emulation. Audited every shim-installed descriptor (4 accessors + 30+
methods on `%TypedArrayPrototype%`, 11 properties on `ArrayBuffer.prototype`,
plus `[Symbol.toStringTag]` on each emulated immutable buffer); every
installed descriptor's `enumerable` flag matches the spec's
`{ enumerable: false }`. No emulation fixes needed; the
`defineProperty(..., { enumerable: false })` walk at the bottom of each
lib property record already aligns the shape.

Test surface: 9 new ava cases in `packages/pass-style/test/byteArray.test.js`
covering accept (plain wrapper; zero-length) and reject (mutable buffer;
shadowing index with disagreeing value; out-of-range index; non-index
own property; non-canonical numeric key `'01'`; accessor at canonical
index; backing buffer with extraneous own property). Total pass-style
test count goes 30 to 39.

Regression evidence: temporarily disabling the value-equality check in
`assertRestValidPlainFrozenUint8Array` causes the shadowing-disagreement
test to fail with `Expected to throw any exception`. Verified and
restored.

Out of scope: `packages/bytes` (per @erights: "I'll leave that to
@kriskowal") and any change to pass-style's brand-checking principles
beyond this validation extension.

Next stages owed: assayer (concert; jurisdiction call on a passable
brand change), cleaner, barrister panel.

Self-improvement: nothing this time. The task framing was clear, the
code change small and well-scoped, and the byte-equality unification of
emulated and native paths followed from the existing amplifier pattern
without needing a new garden skill or role norm.
