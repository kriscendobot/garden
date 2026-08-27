---
title: Semantics
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

> Abstract: Specifies how emulated wrappers handle mutator methods, indexed assignment, freezing, buffer identity, and `Symbol.toStringTag` while preserving immutable backing storage.

## Semantics

Three semantic choices warrant explicit treatment.

### Mutator methods throw

The five enumerated mutator methods (`copyWithin`, `fill`, `reverse`,
`set`, `sort`) each `throw TypeError` when invoked on an emulated
freezable TypedArray.
This matches the *Immutable ArrayBuffer* proposal's guarantee that an
immutable-backed view is immutable: a mutator that observably
modifies the contents must be prevented, and a thrown `TypeError` is
the explicit failure mode the proposal text uses.

The throw is implemented at the lib level via the
amplifier-with-this-fallthrough pattern: each mutator on the lib's
property record checks brand-WeakMap membership and throws on hit; on
miss it delegates to the captured genuine method, which preserves
unchanged behaviour for genuine TypedArrays.

### Indexed assignment never modifies the underlying buffer

The proposal does not provide a way to make integer-indexed
assignment to a TypedArray *throw*.
The emulated wrapper's response to `view[0] = 42` is therefore
necessarily different from the genuine integer-indexed exotic's
silent-swallow path; the wrapper is a plain ordinary object whose
`[[Prototype]]` is `T.prototype`, not an integer-indexed exotic
object.
What this design guarantees is the *immutability of the underlying
buffer*: no path through the emulated wrapper can mutate the bytes
the immutable `ArrayBuffer` holds.
What `view[0]` reads back after `view[0] = 42` depends on whether the
wrapper itself has been frozen, and is independent of the buffer's
contents.

#### Worked example (non-frozen wrapper)

```js
import '@endo/immutable-arraybuffer/shim.js';

const ab = new ArrayBuffer(4);             // [0, 0, 0, 0]
const iab = ab.sliceToImmutable();
const view = new Uint8Array(iab);

view[0];                                   // 0  (delegates to the hidden
                                           //     genuine TypedArray's read
                                           //     of the immutable buffer's
                                           //     byte 0)
view[0] = 42;                              // OrdinarySet on the plain
                                           //   wrapper; creates an own
                                           //   data property '0' => 42.
                                           //   The underlying immutable
                                           //   buffer is NOT touched.
view[0];                                   // 42 (now reads the own
                                           //     property, which shadows
                                           //     the prototype's indexed
                                           //     read delegate)

Uint8Array.prototype.at.call(view, 0);     // 0  (the buffer's actual
                                           //     byte 0 is unchanged)
```

The own-property creation is a quirk of the plain-object wrapper, not
a security concern: the immutable buffer's bytes are untouched, and
any code that observes the bytes via a non-indexed method (`at`,
`slice`, `subarray`, the DataView accessors, byte enumeration through
`for ... of`) sees the original buffer contents.
The discrepancy is only visible to code that reads through the
wrapper's integer-indexed surface after an integer-indexed write,
and that surface is exactly the surface the proposal cannot prevent
the write to.

#### Worked example (frozen wrapper)

```js
const view = new Uint8Array(iab);
Object.freeze(view);
Object.isFrozen(view);                     // true

view[0] = 42;                              // silently swallowed in
                                           //   non-strict mode; throws
                                           //   TypeError in strict mode
                                           //   (own property '0' cannot
                                           //   be created on a frozen
                                           //   object)
view[0];                                   // undefined (no own property;
                                           //   the prototype has no
                                           //   integer-indexed slot)
```

After `Object.freeze(view)`, the wrapper rejects new own-property
installation per the ordinary frozen-object semantics; the
integer-indexed write fails to create an own property and the
subsequent read falls through the prototype chain to find no slot,
returning `undefined`.

The experiment branch carries coverage for the post-freeze case
(the "strengthened indexed-assignment swallow test" in fixup
`740259d2`); this design preserves that coverage and adds the
non-frozen-wrapper worked example as a new test
(`shim: indexed assignment creates a wrapper-local own property on a
non-frozen emulated freezable view; underlying buffer unchanged`).

This is a known proposal-level constraint, not a shim shortcoming.
The README's *Caveats* section is updated to mention both the
non-frozen and frozen cases.

### `Object.isFrozen(view)` returns true after `Object.freeze(view)`

The emulated wrapper has no integer-indexed exotic slots and no
non-configurable own data properties, so `Object.freeze(view)`
succeeds and `Object.isFrozen(view)` returns `true`.
This is the proposal's TypedArray-can-be-frozen guarantee at the
JavaScript surface.

For a genuine TypedArray on a mutable buffer, `Object.freeze` throws
because the integer-indexed slots are non-configurable accessor-like
slots backed by the buffer; the emulated wrapper has neither of those
properties, so `freeze` is well-defined.

The spec basis: `Object.freeze` invokes `SetIntegrityLevel` on the
receiver, which iterates the receiver's *own* property keys (via
`[[OwnPropertyKeys]]`) and sets each to non-configurable.
The integer-indexed exotic check that makes genuine TypedArrays
unfreezable lives on the integer-indexed exotic object's
`[[OwnPropertyKeys]]` and `[[DefineOwnProperty]]` internal methods,
which enumerate the integer-indexed slots as own properties.
The emulated wrapper is a plain ordinary object whose `[[Prototype]]`
is `T.prototype`; its own `[[OwnPropertyKeys]]` (the ordinary-object
form) does not enumerate integer-indexed slots because the wrapper
has none.
The freeze walk therefore touches only the wrapper's plain own
properties (none) and completes; the prototype chain's exotic-ness is
not consulted because freeze operates on the receiver.

The harden phase of SES `lockdown()` reaches every primordial and
freezes it transitively; the emulated wrappers participate normally
in that walk because they are plain objects.

### `view.buffer` returns the immutable wrapper

The lib installs `virtualTypedArrayBufferGetter` as the new accessor
for `%TypedArrayPrototype%.buffer`.
The getter checks `hiddenTypedArrays` for the receiver; on hit it
returns the immutable wrapper (`reverseHiddenBuffers.get(genuineAb)`);
on miss it returns the genuine buffer the way the native accessor
would.
This means a caller who does `view.buffer.sliceToImmutable()` on an
emulated freezable view gets the immutable wrapper back, consistent
with the rest of the proposal's surface.

The same getter therefore serves both genuine TypedArrays and
emulated freezable TypedArrays, so the shim install replaces the
prototype's `buffer` accessor unconditionally (under the stage-3
detect-then-skip gate).

### `[Symbol.toStringTag]`

The shim **replaces** the genuine `%TypedArrayPrototype%[Symbol.toStringTag]`
getter with a wrapper around it, so an emulated freezable TypedArray wrapper
reports the same string tag as a genuine view.
That genuine getter is `this`-sensitive — it reads the receiver's
`[[TypedArrayName]]` internal slot — and an emulated wrapper is a plain
ordinary object (`Object.create(T.prototype)`) with no such slot, so the
*unmodified* getter would return `undefined` for it and
`Object.prototype.toString.call(view)` would read `'[object Object]'` rather
than `'[object Uint8Array]'` (or the concrete flavor's name).
The shim's replacement getter closes that gap using the same
amplifier-with-fallthrough shape as the `buffer` / `byteLength` /
`byteOffset` / `length` accessors: on an emulated wrapper it amplifies to the
hidden genuine TypedArray (`hiddenTypedArrays.get(receiver)`) and reads *its*
internal-slot tag; on a genuine TypedArray it delegates to the captured
genuine getter; on any other receiver it returns `undefined`, exactly as the
genuine getter does.

This is a **getter-wrapper** fix, not a `[Symbol.toStringTag]` **data
property** on the wrapper. A data property would repair only the
`Object.prototype.toString` lookup path while leaving the genuine
`this`-sensitive getter still reporting `undefined` on a wrapper (a *flawed*
fidelity fix); the getter wrapper makes the getter and
`Object.prototype.toString` agree. The wrapper therefore still carries **no**
own `[Symbol.toStringTag]` — the tag comes from the prototype getter.

Consequently `[Symbol.toStringTag]` is **no longer** an emulated-vs-genuine
distinguisher; the single committed distinguisher remains `ArrayBuffer.isView`.
One downstream consequence: a brand check that captures *this* (shim-installed)
getter as an internal-slot probe — as `@endo/harden`'s `isTypedArray` does —
will classify an emulated wrapper as a `TypedArray` when it captures the getter
after the shim installs, rerouting the wrapper through `harden`'s
`freezeTypedArray` branch. That reroute is benign: the wrapper carries no own
integer-indexed properties, so `freezeTypedArray` reduces to
`preventExtensions` plus a no-op over an empty own-key set, and
`harden(wrapper)` succeeds in either capture order (verified empirically).
`test/shim-typedarray-tostringtag.test.js` pins the repaired
`'[object Uint8Array]'` reading and the getter-wrapper (not data-property)
shape.

**Reversal of the earlier "defer to the genuine tag" decision.** An earlier
revision of this design deliberately did *not* replace the getter, following
erights's call on
[PR #449's open question 3](https://github.com/endojs/endo-but-for-bots/issues/comments/4735477238)
(*"(b) is best. ... I'm happy not to add complexity to avoid it until we find out
if it is an actual problem"*) and treating the `'[object Object]'` reading as an
incidental, un-depended-upon fidelity loss. erights subsequently asked for the
receiver-aware getter as a higher-fidelity fix and to land it as a separately
reviewable commit to see what it does and does not break
([#475 review comments 3817252816 / 3817264546](https://github.com/endojs/endo-but-for-bots/pull/475)).
This section records that reversal; the getter wrapper is that commit.
It parallels PR #435's ArrayBuffer-side post-departure recovery (which installed
`'emulated immutable ArrayBuffer'` as an own-property tag on each emulated immutable
buffer), differing in mechanism — a receiver-aware getter rather than an own
data property, which is why the emulated view's tag stays faithful to *this*
receiver rather than being pinned to a single literal.

The experiment branch set `[Symbol.toStringTag] = 'FreezableTypedArray'` on the
would-be intermediate prototype; under the drop-the-pseudo-prototype shape there
is no intermediate prototype to hang a tag on, and this fix supplies the flavor-
faithful tag through the prototype getter instead.


Source: [freezable-typedarray.md](https://github.com/endojs/endo-but-for-bots/blob/c8007ce9c9f7e9dad2d129f4586ae0cb8fecef97/packages/immutable-arraybuffer/designs/freezable-typedarray.md) at PR head `c8007ce9` (unreviewed archive).
