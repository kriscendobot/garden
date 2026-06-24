---
title: "@endo/immutable-arraybuffer — ponyfill + shim for the proposed Immutable ArrayBuffer feature"
source-slug: endo--packages-immutable-arraybuffer
url: https://github.com/endojs/endo/tree/master/packages/immutable-arraybuffer
authors: [Mark Miller, Kris Kowal, Endo contributors]
repo: endojs/endo
path:
  - packages/immutable-arraybuffer/src/immutable-arraybuffer-pony.js
  - packages/immutable-arraybuffer/src/immutable-arraybuffer-shim.js
  - packages/immutable-arraybuffer/README.md
total-lines: 350 source (253 ponyfill + 97 shim) + 75 README
license: Apache-2.0
ingest-cycle: 201
ingest-date: 2026-06-06
lane: chat
status: current
---

# @endo/immutable-arraybuffer

Ponyfill **and** shim for a proposed new JavaScript feature: **Immutable ArrayBuffers**. Exports `transferBufferToImmutable`, `sliceBufferToImmutable`, `isBufferImmutable` as standalone functions (ponyfill); the shim installs `transferToImmutable`, `sliceToImmutable`, and the `immutable` getter on `ArrayBuffer.prototype`.

## The proposal targets two additions to `ArrayBuffer.prototype`

- `transferToImmutable() :ArrayBuffer` — move the contents of the original buffer into a new immutable buffer, detach the original.
- `immutable: boolean` (read-only accessor) — is this buffer immutable?

An immutable buffer cannot be detached or resized. `maxByteLength === byteLength`. A `DataView` or `TypedArray` using an immutable buffer as its backing store could be frozen and immutable.

## Two named motivations from orthogonal domains

1. **§ROM-vs-RAM Moddable XS rationale**: embedded JavaScript systems (Moddable XS) need to place voluminous fixed data into ROM, currently done with semantics outside the official standard.
2. **§By-copy network protocol rationale**: the network capability protocol that Endo speaks treats byte-arrays as bulk data transmitted by copy. JavaScript strings reflect this by-copy nature via immutability. An immutable ArrayBuffer is the symmetric shape for byte-arrays. `@endo/pass-style` + `@endo/marshal` would consume this.

## Key design moves

- **§Ponyfill+Shim pattern (full version)** — both shapes exported simultaneously (sibling to cycle 197 panic's ponyfill-only deferred-shim).
- **§Purposeful-Violation section in README** — explicit-named-acknowledgment that `Symbol.toStringTag = 'ImmutableArrayBuffer'` (not `'ArrayBuffer'`) is §a-deliberate-fidelity-violation for §concordance-sniff-defense (Ava's diagnostic library sniffs `toString()` results to choose rendering).
- **§Six-named-Caveats** in README: platform-degradation / no-intermediate-in-proposal / intermediate-discoverable / not-real-exotic-objects / not-cross-thread / shim-still-runs-after-native / not-hardened-by-itself.
- **§WeakMap-as-emulated-private-field-AND-brand-check** — explicit honest acknowledgment that natural shape would be `this.#buffer` class private field but Hermes doesn't support them; WeakMap emulates both private-state and brand-check by-construction.
- **§Method-binding-pre-defineProperty** on the WeakMap (`buffers.has = buffers.has` etc) to avoid post-hoc prototype lookups.
- **§Intermediate-prototype `ImmutableArrayBufferInternalPrototype`** inheriting from `ArrayBuffer.prototype` — emulated immutable buffers transitively pass `instanceof ArrayBuffer`.
- **§Five-throw-methods** on the prototype (resize / transfer / transferToFixedLength / transferToImmutable, plus slice stays mutable but sliceToImmutable returns immutable) + **§six-getter-overrides** (byteLength / detached false / maxByteLength / resizable false / immutable true / toStringTag).
- **§Brand-check via `getBuffer(this)`** on every accessor — even getters that don't need the buffer-value call it for the side-effect (the throw on non-emulated instances).
- **§Three-tier-fallback**: `ArrayBuffer.prototype.transfer` (Node 21+) → `structuredClone({transfer: [...]})` (Node 17+) → undefined (graceful degradation; ponyfill+shim fail to initialize). §Three-platform-degradation with named known-deficient-platforms: Hermes / Node ≤16 / some JavaScriptCore versions.
- **§Zero-length-slice-as-genuine-ArrayBuffer-enforcement** — `arrayBufferSlice(arrayBuffer, 0, 0)` before structuredClone (the side-effect is enforcing arrayBuffer is a genuine exotic object).
- **§Capture-before-scuttled** pre-lockdown discipline — eight intrinsics captured at module load with the named comment "Capture structuredClone before it can be scuttled".
- **§Belt-and-suspenders-freeze** on the must-not-escape factory `makeImmutableArrayBufferInternal` — comment names that it must not escape; freeze provides defense-in-depth.
- **§Modern-shim-practice-frowns-on-conditional-installation** — named-shim-philosophy with rationale (changes to the proposal don't break old code depending on old shim).
- **§Warning-not-error-when-overwriting** with §TODO-comment naming the known-broken-interaction with `lockdown`'s frozen primordials.
- **§Shim-still-runs-after-native-implementation** — deliberate policy with named future cleanup step ("will require a later manual step to delete the shim, after manual analysis of the compat implications").
- **§Plain-JavaScript-not-Hardened-JavaScript** disclaimer — the ses-shim is expected to import and treat the result as additional primordials, to be hardened during lockdown's harden phase.
- **§Encapsulated-genuine-ArrayBuffer-with-exclusive-access** — security demands exclusive access; immutability enforced by never modifying it.

## Ingest scope

Cycle 201 (chat-lane): full ingest of the ponyfill + shim + README. One section because §three-files-form-one-design (ponyfill + shim built on it + README explaining both).

## Related material in the library

- **cycle 197 endo--packages-panic**: §ponyfill+shim distinction sibling; both packages have §caveat-emptor sections and §two-stage rollout discipline.
- **cycle 199 endo--packages-trampoline-memoize-nat-trio**: §minimal-dependency-discipline sibling (`@endo/marshal` aspiration). §encapsulated-pumpkin-sentinel and §WeakMap-as-emulated-private-field are sibling-patterns for §private-state-without-class-private-fields.
- **cycle 71+ endo--packages-pass-style**: §pass-style substrate that this enables — the byte-array bulk-data passable. The README explicitly cites `@endo/pass-style` + `@endo/marshal` as the consumers of immutable ArrayBuffer.
- **cycle 189 endo--packages-marshal-src-marshal-justin-and-marshal-stringify-js**: marshal substrate that depends on by-copy semantics.
- **cycle 181 endo--packages-base64**: §three-tier dispatch sibling pattern (native → legacy XS → pure JS); base64 uses Reflect.apply capture; this uses similar capture-before-scuttled.
- **cycle 175 endo--packages-harden-make-selector-js**: §pin-on-first-install discipline; this design's §shim-installs-without-pin-with-warning is the inverse (modern-shim-practice).
- **cycle 197 panic**: §Eval-Twin-Problem chain extends to this package implicitly (`not by itself a Hardened JavaScript polyfill/shim`).
- **cycle 198 patterns-diagnostic-feedback**: §the-data-is-already-there-just-locked discovery; both designs §explicitly-name-the-cost-of-a-design-choice (198 names a discovery-driven-redesign; 201 names a fidelity-violation-driven-defense).
