---
gate: deferred
priority: normal
posted_by: designer
posted_at: 2026-08-23T03:12:03Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Extend hardened test262 coverage to every immutable-arraybuffer method

Follow-up from the kriskowal review on endojs/endo-but-for-bots PR #475
(inline comment on packages/immutable-arraybuffer/src/lib.js:1,
"Please verify that every immutable arraybuffer method has coverage in
hardened test262 cases").

Audit finding (recorded on the PR thread): the hardened test262 layer
(packages/hardened262/test/ArrayBuffer/view-behavior-matrix.js via the
immutableArrayBufferViewMatrix harness, plus the TextEncoder/TextDecoder
immutable-arraybuffer-intersection cases) is a representative SMOKE matrix,
not exhaustive per-method coverage. It exercises: the `.immutable` getter,
`sliceToImmutable`, the ImmutableArrayBuffer toStringTag brand,
`ArrayBuffer.isView` for array/data views, indexed reads (incl. the
emulated-wrapper undefined behavior), `.at()`, `Object.freeze`/`isFrozen`,
TypedArray `.set()` mutator-rejection, and DataView `.buffer`/`getUint8`/
`setUint8` (read ok, write throws).

NOT yet covered in hardened test262 (covered instead by the package's own
ava suites — shim-typedarray-per-flavor, shim-transfer, etc.):
`transferToImmutable`; `transfer`/`transferToFixedLength`/`resize`
(throw-on-immutable); immutable `.slice()`; the `byteLength`/`maxByteLength`/
`detached`/`resizable` getters on an immutable buffer; TypedArray
`copyWithin`/`fill`/`reverse`/`sort` and `subarray`; and the non-Uint8
DataView accessors.

Task: decide whether every method must be mirrored into hardened test262
(vs. leaving exhaustive coverage in the ava suites), and if so, extend the
immutableArrayBufferViewMatrix harness to cover the gap. Validate any
additions across all three configured agents (bare XS, SES-on-XS, SES-on-Node)
under MODDABLE_VERSION 9.0.0 before landing — the harness is shared with the
test262-runner copy and a naive addition can regress the XS baseline.
