---
title: Status and problem
source: packages/immutable-arraybuffer/designs/freezable-typedarray.md
source_repo: endojs/endo-but-for-bots
source_branch: feat/narrow-bytearray-to-uint8
source_commit: c8007ce9c9f7e9dad2d129f4586ae0cb8fecef97
source_pr: endojs/endo-but-for-bots#475
source_pr_state: open
source_date: 2026-08-25
source_authors: [Kriscendo Bot]
ingested: 2026-08-27
ingested_by: scholar
topics: [hardened-javascript, pass-style]
status: current
notes: Unreviewed archive captured at maintainer direction before deletion from the PR.
---

> Abstract: Frames the design as a blocked follow-on to immutable ArrayBuffer emulation and explains why genuine TypedArray views cannot be frozen while plain wrapper objects can.

# Freezable TypedArray emulation: drop the pseudo-prototype on the TypedArray side

This design captures the *delayed freezable TypedArray emulation*
that erights asked for in his 2026-06-17T10:55Z comment on PR #435.
PR #435 is the predecessor that drops the immutable-ArrayBuffer
pseudo-prototype.
This is the TypedArray-side analog explicitly named in PR #435's
`designs/immutable-arraybuffer.md` section *Out of scope*
(quoted: "The TypedArray-side analog (drop
`%FreezableTypedArrayPrototype%` similarly).
Separate PR, separate design.").

The package keeps its split between a self-contained library layer
(`src/lib.js`) and a shim layer (`src/shim.js`) that installs
emulation onto genuine prototypes at load time.
The TypedArray side mirrors the ArrayBuffer-side amplifier-with-this-fallthrough
shape PR #435 established: every method on `%TypedArrayPrototype%`
discriminates on brand-WeakMap membership, the emulated wrapper
inherits directly from the genuine prototype (no intermediate
pseudo-prototype), and the shim installs the lib's property record
onto the genuine prototype under a stage-3 detect-then-skip policy.

## Status

| Field    | Value                                                                                            |
| -------- | ------------------------------------------------------------------------------------------------ |
| Created  | 2026-06-17                                                                                       |
| Authors  | erights (original framing), kriscendobot (write-up)                                              |
| Status   | Proposed                                                                                         |
| Depends  | PR #435 (drop-the-pseudo-prototype on the ArrayBuffer side) must merge before the builder fires  |
| Affects  | `packages/immutable-arraybuffer/`, `packages/ses/src/permits.js`                                 |
| Replaces | The would-be `%FreezableTypedArrayPrototype%` intrinsic that the experiment branch introduced    |

## Problem

The *Immutable ArrayBuffer* proposal at TC39 (Stage 2.7, advanced
February 2025) carries an explicit guarantee:
*A `DataView` or `TypedArray` using an immutable buffer as its backing
store can be frozen and immutable.*
PR #435 lands the ArrayBuffer-side emulation under the
drop-the-pseudo-prototype shape; this proposal carries the parallel
guarantee for `TypedArray` instances backed by emulated immutable
ArrayBuffers.

After PR #435 merges, a caller can do this:

```js
import '@endo/immutable-arraybuffer/shim.js';

const ab = new ArrayBuffer(4);
const iab = ab.sliceToImmutable();          // emulated immutable AB
const view = new Uint8Array(iab);            // currently throws or
                                             // silently produces a
                                             // wrong-shape view
```

Without the freezable-TypedArray emulation, the `new Uint8Array(iab)`
call would fall into one of two unwanted states:

- **Throws.**
  The native `Uint8Array` constructor expects a real `ArrayBuffer`
  exotic object as its first argument.
  The emulated immutable buffer is a plain object whose `__proto__`
  is `ArrayBuffer.prototype`; the spec's internal slot check rejects it.
- **Coerces silently.**
  Some engines treat the emulated immutable buffer as a buffer-like
  and copy out a degraded view whose `.buffer` is a fresh genuine
  ArrayBuffer disconnected from the immutable wrapper.
  The view is then mutable, breaking the proposal's
  *can-be-frozen-and-immutable* guarantee at the TypedArray surface.

The proposal's TypedArray guarantee therefore cannot land at the
JavaScript surface without a TypedArray-side shim.
The experiment branch `experiment/no-spackle-immutable-arraybuffer-417`
(prototype, not for merge) demonstrates the pattern; PR #435 fixes
the ArrayBuffer-side surface this design builds on; this PR brings
the TypedArray-side surface to parity.


Source: [freezable-typedarray.md](https://github.com/endojs/endo-but-for-bots/blob/c8007ce9c9f7e9dad2d129f4586ae0cb8fecef97/packages/immutable-arraybuffer/designs/freezable-typedarray.md) at PR head `c8007ce9` (unreviewed archive).
