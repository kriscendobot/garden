---
title: Test plan
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
topics: [testing, hardened-javascript]
status: current
notes: Unreviewed archive captured at maintainer direction before deletion from the PR.
---

> Abstract: Enumerates lib-level, shim-level, per-flavor, SES integration, and cross-package tests for genuine and emulated TypedArray and DataView behavior.

## Test plan

The implementation must pass three test layers.

### Lib-level (the property-record + pseudo-constructor in isolation)

`packages/immutable-arraybuffer/test/lib-typedarray.test.js`
(translation of the experiment branch's
`freezable-typedarray-pony.test.js`, four tests):

- `makePseudoTypedArrayConstructor wraps an immutable ArrayBuffer`:
  the brand-check WeakMap registration succeeds; the
  `virtualTypedArrayBufferGetter` recovers the immutable wrapper.
- `makePseudoTypedArrayConstructor forwards a non-immutable first arg`:
  the fallthrough branch via `Reflect.construct(OriginalConstructor,
  args, new.target)` produces a genuine TypedArray view.
- `virtualTypedArrayBufferGetter returns the real buffer for a
  genuine TypedArray`: the fallthrough returns the genuine buffer.
- `virtualTypedArrayBufferGetter redirects to the immutable wrapper
  when present`: the redirect via `reverseHiddenBuffers` works.

### Shim-level (after `import '../src/shim.js'`)

`packages/immutable-arraybuffer/test/shim-typedarray.test.js`
(translation of the experiment branch's
`freezable-typedarray-shim.test.js`, eight tests):

- `shim: global Uint8Array on an immutable ArrayBuffer wraps as
  emulated freezable`.
- `shim: global Uint8Array on a regular ArrayBuffer forwards to the
  OriginalConstructor`.
- `shim: virtual buffer getter returns the real buffer for a genuine
  TypedArray`.
- `shim: virtual buffer getter redirects to the immutable wrapper
  when present`.
- `shim: emulated freezable byteLength and at redirect via
  amplifyTypedArray`.
- `shim: emulated freezable mutators complain` (each of the five
  enumerated mutators throws).
- `shim: emulated freezable subarray returns a view whose buffer is
  the immutable wrapper`.
- `shim: detect-then-skip is idempotent under re-import` (parallel
  to PR #435's gate behaviour).

Additional tests this PR introduces beyond the experiment branch:

- `shim: indexed assignment on a non-frozen emulated freezable view
  creates a wrapper-local own property; the underlying immutable
  buffer is unchanged` and `shim: indexed assignment on a frozen
  emulated freezable view is silently swallowed; the underlying
  immutable buffer is unchanged` (cover both halves of the
  proposal-level constraint named in *Semantics* section
  *Indexed assignment never modifies the underlying buffer*).
- `shim: Object.freeze(view); Object.isFrozen(view) === true` on an
  emulated freezable view (the proposal's
  TypedArray-can-be-frozen guarantee).
- `shim: Object.getPrototypeOf(view) === Uint8Array.prototype` on an
  emulated freezable view (documents that no intermediate prototype
  exists, parallel to PR #435's analogous assertion).

### Per-flavor parameterized coverage

`packages/immutable-arraybuffer/test/shim-typedarray-per-flavor.test.js`
runs a parameterized matrix over all eleven concrete TypedArray
constructors (`Int8Array`, `Int16Array`, `Int32Array`, `Uint8Array`,
`Uint8ClampedArray`, `Uint16Array`, `Uint32Array`, `Float32Array`,
`Float64Array`, `BigInt64Array`, `BigUint64Array`).

The matrix carries a per-flavor *sample value* for each row.
For the nine non-BigInt flavors the sample is `1`; for the two
BigInt flavors (`BigInt64Array`, `BigUint64Array`) the sample is `1n`.
The mutator and `with` calls must use the per-flavor sample because
the native operations throw `TypeError` on a type mismatch *before*
reaching the brand check, which would mask the test's intent.
Specifically:

- `view.with(0, sample)` requires `sample === 1n` for the two BigInt
  flavors and `sample === 1` for the nine non-BigInt flavors.
  `view.with(0, 1)` on a `BigInt64Array` throws `TypeError`
  ("Cannot convert a Number value to a BigInt") before the
  emulation's mutator-throws path is reached.
- `view.fill(sample)` and `view.set([sample])` carry the same
  per-flavor constraint.
  Both are *expected* to throw `TypeError` on the emulated freezable
  view (the mutator-throws contract), but the test must construct
  the argument with the flavor-correct type so that the throw the
  test observes is the brand-check throw and not a type-mismatch
  throw at the native call site.

For each flavor, the matrix asserts (with the per-flavor sample
substituted into the parenthesized positions):

- Construction from an immutable buffer succeeds and yields a
  freezable wrapper whose `__proto__` is `T.prototype`.
- Each of the five mutator methods throws `TypeError`:
  `view.copyWithin(0, 1)`, `view.fill(sample)`, `view.reverse()`,
  `view.set([sample])`, `view.sort()`.
- Indexed assignment does not modify the underlying buffer.
  On a non-frozen wrapper: `view[0] = sample; t.is(view[0], sample)`
  reads back the own property; the buffer's byte 0 remains the
  per-flavor zero (`0` for non-BigInt flavors, `0n` for BigInt
  flavors), confirmed via `T.prototype.at.call(view, 0)`.
  On a frozen wrapper: `Object.freeze(view); view[0] = sample;
  t.is(view[0], undefined)` confirms the silent swallow and the
  buffer's byte 0 remains the per-flavor zero.
- `view.byteLength`, `view.byteOffset`, `view.length`, `view.buffer`
  all return correct values.
- `view.slice(...)`, `view.subarray(...)`, `view.at(0)`,
  `view.with(0, sample)`, `view.toReversed()`, `view.toSorted()`
  return correct values.
- `Object.freeze(view); Object.isFrozen(view)` returns `true`.
- The fallthrough constructor (`new T(genuineMutableBuffer)`) still
  produces a genuine writable view.

The eleven-flavor table catches regressions that a `Uint8Array`-only
test suite would miss (the experiment branch covers only
`Uint8Array`).
Naming the per-flavor sample shape explicitly here lets the builder
write the right matrix on the first try rather than rediscovering
the BigInt distinction in a CI run.

### ses-side integration

`packages/ses/test/immutable-arraybuffer.test.js` extends to cover:

- After `lockdown()`, an emulated freezable `Uint8Array` is hardened
  and `Object.isFrozen(view) === true`.
- After `lockdown()`, the permits walk does not complain about the
  `%TypedArrayPrototype%` slots the shim installs.
- After `lockdown()`, an emulated freezable view's mutator methods
  still throw (the harden phase does not break the lib's
  discrimination logic).

### Cross-package consumer touchpoints

The freezable-TypedArray emulation surfaces an explicit cross-package
risk against `packages/pass-style/src/byteArray.js`.
On post-#435 master, `byteArray.js`'s `confirmCanBeValid` requires
`candidate instanceof ArrayBuffer && candidate.immutable` and
`assertRestValid` requires `getPrototypeOf(candidate) === ArrayBuffer.prototype`.
A `Uint8Array` (genuine or emulated freezable) therefore does **not**
pass the current byte-array brand check.
This is a pre-existing condition of the post-#435 lib, not a
regression this design introduces.

A separate revision to `byteArray.js` is required for the
freezable-TypedArray emulation to be useful at the pass-style brand
boundary.
Per erights's
[inline comment on this design](https://github.com/endojs/endo-but-for-bots/pull/449#discussion_r3431570369)
(2026-06-17T21:26Z):
*"Also need to revise `packages/pass-style/src/byteArray.js` to use a
frozen Uint8Array rather than a frozen immutable ArrayBuffer as a
byteArray."*
And:
*"Perhaps packages/bytes need a similar revision."*
*"I'll leave that to @kriskowal."*
The `byteArray.js` revision is **out of scope for this PR** (the
design's scope is the immutable-arraybuffer package's freezable-
TypedArray emulation, not pass-style's brand check) and is left to a
follow-up that the maintainer files separately.

#### Adapter consolidation and withdrawal from `@endo/bytes`

Per kriskowal's inline comment on this design
(discussion `r3431584143`, 2026-06-17T21:29Z):
*"I believe we will be able to withdraw adapters for frozen Uint8
arrays backed by frozen immutable ArrayBuffer from `@endo/bytes` as
the shim presents as sufficiently ergonomic without utility
functions.
This does not need to be engaged in the same builder PR."*

That consolidation has since landed in this PR (see the
`consolidate-immutable-byte-utilities` changeset). `@endo/bytes`
previously carried two adapter functions that bridged between frozen
`Uint8Array` instances backed by frozen immutable `ArrayBuffer`s and
the broader bytes-handling surface; both have been withdrawn from
`@endo/bytes`, consolidated onto the shim's shared implementation, and
renamed:

- `frozenBytes(view)` (now exported from `@endo/immutable-arraybuffer`;
  formerly `bytesToImmutable` at `packages/bytes/src/to-immutable.js`):
  wraps a `Uint8Array` view's byte window into a hardened frozen
  `Uint8Array` backed by an immutable `ArrayBuffer`.
  With this design's shim installed it is the direct-construction
  pattern `Object.freeze(new Uint8Array(ab.sliceToImmutable()))`
  behind a single name.
- `thawedBytes(buffer)` (now exported from `@endo/immutable-arraybuffer`;
  formerly `bytesFromImmutable` at `packages/bytes/src/from-immutable.js`):
  copies an immutable `ArrayBuffer`'s contents into a fresh mutable
  `Uint8Array` so downstream APIs (such as `TextDecoder.decode`) that
  reject immutable buffers can consume the bytes.
  It is the fresh-copy pattern `new Uint8Array(immutableAb.slice(0))`
  behind a single name.

Because the shim makes that adapter shape ergonomic at the language
surface, the `@endo/bytes` sub-path exports `./to-immutable.js` and
`./from-immutable.js` were removed rather than re-homed under new
names in the same package: a consumer that wants a frozen `Uint8Array`
backed by an immutable `ArrayBuffer` either constructs it directly via
`new Uint8Array(ab.sliceToImmutable())` and freezes the wrapper, or
reaches for the shared `frozenBytes` / `thawedBytes` exported from
`@endo/immutable-arraybuffer`.

This consolidation rode the same cross-package consumer sweep this
design describes, confirming no regressions in `@endo/pass-style` or
`@endo/marshal`.

The implementation PR's consumer sweep therefore expects the
following:

- `yarn workspace @endo/pass-style test` after the implementation
  lands: passes unchanged.
  An emulated freezable `Uint8Array` does **not** pass the existing
  brand check; pass-style tests do not exercise the freezable-Uint8Array
  path and are unaffected.
- `yarn workspace @endo/marshal test` after the implementation lands:
  passes unchanged for the same reason.
  Marshal's byte-array codec routes through pass-style's
  `byteArray` style; without the `byteArray.js` revision, no marshal
  test exercises a freezable-Uint8Array round-trip.

The named regression signals the builder watches for (kinds of CI
failure that would indicate a real regression rather than the
expected no-op):

- Any `concordance`-routed `Buffer.from` `TypeError` on an emulated
  freezable `Uint8Array` (the parallel to PR #435's 13 ocapn-codec
  failures named in *Notes from the field*, 2026-06-09).
- Any pass-style brand-check mis-classification on an emulated
  freezable `Uint8Array` (the check correctly returns "not a
  byteArray"; a different routing is a regression).
- Any marshal codec test failing on a byte-array encode/decode
  round-trip whose input is constructed from an emulated freezable
  `Uint8Array` (this should not happen because no marshal test
  constructs such an input; if one does, the test should be updated
  to use the genuine `byteArray` shape rather than the regression
  being absorbed silently).

If the cross-package sweep surfaces any of these named signals, the
builder escalates back to the maintainer rather than installing a
workaround in the freezable-TypedArray PR; the underlying remediation
is the separate `byteArray.js` revision erights describes.

Per the *Notes from the field* entry in `roles/designer/AGENT.md`
2026-06-09: PR #435's `[Symbol.toStringTag]` decision killed 13 ocapn
codec tests because `concordance` routed through `Buffer.from` on the
`'[object ArrayBuffer]'` tag.
The parallel risk on the TypedArray side is acknowledged by erights's
*"It does have the hazard you mention, but I'm happy not to add
complexity to avoid it until we find out if it is an actual problem"*
on PR #449's open question 3 (resolution recorded in *Decisions* section 3);
the builder runs the same downstream consumer sweep before opening
the implementation PR and, if the sweep surfaces a regression,
escalates back to the maintainer rather than installing the tag
unilaterally.


Source: [freezable-typedarray.md](https://github.com/endojs/endo-but-for-bots/blob/c8007ce9c9f7e9dad2d129f4586ae0cb8fecef97/packages/immutable-arraybuffer/designs/freezable-typedarray.md) at PR head `c8007ce9` (unreviewed archive).
