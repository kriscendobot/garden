---
title: Background and API surface
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

> Abstract: Describes the immutable-buffer wrapper background and the intended constructor, prototype, and pass-style surface for emulated freezable views.

## Background

The freezable-TypedArray design extends the post-#435 lib surface,
not the experiment branch's earlier shape.
A reader meeting this document without having read
`designs/immutable-arraybuffer.md` first needs the following lib-side
topology before the *Implementation outline* section makes sense.

After PR #435 merges, the lib (`packages/immutable-arraybuffer/src/lib.js`)
owns two internal WeakMaps that the freezable-TypedArray code extends
rather than reintroduces:

- `hiddenBuffers` maps each emulated immutable ArrayBuffer wrapper to
  its backing genuine (mutable) ArrayBuffer.
  The lib uses the wrapper as the public-facing identity and the
  genuine buffer as the private storage; methods that need to read
  bytes (`slice`, `getInt8`, etc.) consult `hiddenBuffers` to recover
  the genuine buffer.
- `reverseHiddenBuffers` is the inverse map from genuine backing
  buffer to the wrapper.
  Methods that need to *return* a buffer (the `view.buffer` getter,
  for instance) consult `reverseHiddenBuffers` to hand back the
  immutable wrapper rather than the genuine buffer.

Both WeakMaps live inside the lib's module scope; they are not
exported.
The freezable-TypedArray code adds a third WeakMap (`hiddenTypedArrays`)
keyed on the emulated TypedArray wrappers and reads the two
pre-existing WeakMaps for `view.buffer` lookups.
This is the topology *Implementation outline* section *Lib additions* extends;
that section names `hiddenBuffers` and `reverseHiddenBuffers` without
re-explaining them.

A reader who wants to see the post-#435 lib in detail (the
amplifier-with-this-fallthrough pattern, the lib-as-property-record
shape, the brand-WeakMap discrimination) should read
`designs/immutable-arraybuffer.md` section *Move 2* first; this design assumes
that surface as a given.

## API surface

After this PR merges, the following hold for any concrete TypedArray
constructor `T` in the standard library's eleven concrete TypedArray
constructors (`Int8Array`, `Int16Array`, `Int32Array`, `Uint8Array`,
`Uint8ClampedArray`, `Uint16Array`, `Uint32Array`, `Float32Array`,
`Float64Array`, `BigInt64Array`, `BigUint64Array`):

```js
import '@endo/immutable-arraybuffer/shim.js';

const ab = new ArrayBuffer(4);
const iab = ab.sliceToImmutable();
const view = new T(iab);
```

| Expression                                | Returns                                                       |
| ----------------------------------------- | ------------------------------------------------------------- |
| `view instanceof T`                       | `true`                                                        |
| `Object.getPrototypeOf(view)`             | `T.prototype` (no intermediate prototype)                     |
| `view.buffer`                             | `iab` (the immutable wrapper, not the underlying genuine AB)  |
| `view.byteLength`, `byteOffset`, `length` | correct values, delegated to the hidden genuine TypedArray    |
| `view.at(0)`, `slice`, `subarray`, etc.   | correct values, delegated to the hidden genuine TypedArray    |
| `view.set([1])`                           | throws `TypeError` (complaining mutator)                      |
| `view.fill(0)`, `reverse`, `sort`, `copyWithin` | each throws `TypeError`                                 |
| `view[0] = 42; view.at(0)`                | `0` (the underlying buffer is never modified; `view.at(0)` delegates to the hidden genuine TypedArray and reads the actual buffer byte; see *Semantics* for the full worked example) |
| `Object.freeze(view); Object.isFrozen(view)` | `true`                                                     |

The non-emulated path (construction from a genuine mutable
ArrayBuffer) is unchanged:

```js
const realAb = new ArrayBuffer(4);
const view = new T(realAb);

// view is a genuine TypedArray view.
// Mutators succeed; indexed assignment writes through; .buffer === realAb.
```

The pseudo-constructor is a drop-in replacement for `T`: the
emulated-immutable branch is reached only when the first argument is
a hidden buffer (registered in the lib's `hiddenBuffers` WeakMap);
every other call shape falls through to the genuine constructor via
`Reflect.construct(OriginalConstructor, args, new.target)`.

The constructor surface is symmetric (both `new T(iab)` and
`new T(realAb)` parse and complete without error), but the
*result-of-construction* surface is asymmetric: the resulting views
diverge on mutability.
A reader of a single call site like `new Uint8Array(maybeIab)` cannot
tell from the syntax whether the produced view will throw on
`.set(...)` or write through; only the runtime identity of the
argument decides.
This is the proposal's central trade: the constructor accepts both
shapes uniformly so existing TypedArray-construction code at consumer
sites does not have to branch, and the call site's mutator behavior
is determined by the argument's immutability rather than by a
separate constructor name.


Source: [freezable-typedarray.md](https://github.com/endojs/endo-but-for-bots/blob/c8007ce9c9f7e9dad2d129f4586ae0cb8fecef97/packages/immutable-arraybuffer/designs/freezable-typedarray.md) at PR head `c8007ce9` (unreviewed archive).
