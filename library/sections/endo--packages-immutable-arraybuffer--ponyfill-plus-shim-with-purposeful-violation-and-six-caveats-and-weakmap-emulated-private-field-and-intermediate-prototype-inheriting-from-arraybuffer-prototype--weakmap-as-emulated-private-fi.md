---
title: §WeakMap-as-emulated-private-field — Hermes-no-class-private-fields
source: endo packages/immutable-arraybuffer/{src/immutable-arraybuffer-pony.js,src/immutable-arraybuffer-shim.js,README.md}
source-slug: endo--packages-immutable-arraybuffer
ingest-cycle: 201
ingest-date: 2026-06-06
lane: chat
authors: [Mark Miller, Kris Kowal, Endo contributors]
related:
  - endo--packages-panic (cycle 197: ponyfill+shim distinction sibling; both with caveat-emptor)
  - endo--packages-pass-style (cycle 71+: pass-style substrate that this enables — immutable bulk binary data)
  - endo--packages-marshal-src-marshal-justin-and-marshal-stringify-js (cycle 189: marshal substrate; this enables ByteArray pass-style)
  - endo--packages-trampoline-memoize-nat-trio (cycle 199: §minimal-dependency-discipline sibling; @endo/marshal aspiration)
  - endo--packages-harden-make-selector-js (cycle 175: §pin-on-first-install — this design's §shim-installs-without-pin-with-warning is the inverse)
keywords:
  - ponyfill-plus-shim pattern (sibling to cycle 197 panic)
  - Purposeful-Violation section in README
  - concordance-sniff-defense via Symbol.toStringTag
  - six-named-Caveats
  - WeakMap-as-emulated-private-field (Hermes-no-class-private-fields)
  - intermediate-prototype-inheriting-from-ArrayBuffer-prototype
  - five-throw-methods (resize / transfer / transferToFixedLength / transferToImmutable + slice-stays-mutable)
  - six-getter-overrides (byteLength / detached / maxByteLength / resizable / immutable / toStringTag)
  - structuredClone-or-transfer-fallback
  - three-platform-degradation (Hermes / Node ≤16 / some JavaScriptCore)
  - capture-before-scuttled (pre-lockdown discipline)
  - method-binding-pre-defineProperty (avoid-post-hoc-prototype-lookups)
  - by-copy-network-protocol-rationale (immutable bulk binary data)
  - ROM-vs-RAM Moddable-XS rationale (place voluminous fixed data into ROM)
  - zero-length-slice-as-genuine-ArrayBuffer-enforcement
  - modern-shim-practice-frowns-on-conditional-installation
  - shim-still-runs-after-native-implementation (deliberate-policy-with-named-future-cleanup-step)
  - belt-and-suspenders freeze on must-not-escape factory
  - brand-check via WeakMap.has(this)
  - cycle 201 milestone (post-cycle-200)
  - nineteenth-member of small-files-with-large-knowledge-density family
  - thirty-fifth consecutive designs/chat alternation cycle 166-201
parent: endo--packages-immutable-arraybuffer--ponyfill-plus-shim-with-purposeful-violation-and-six-caveats-and-weakmap-emulated-private-field-and-intermediate-prototype-inheriting-from-arraybuffer-prototype
---

```js
/**
 * If we could use classes with private fields everywhere, this would have
 * been a `this.#buffer` private field on an `ImmutableArrayBufferInternal`
 * class. But we cannot do so on Hermes. So, instead, we
 * emulate the `this.#buffer` private field, including its use as a brand check.
 * Maps from all and only emulated Immutable ArrayBuffers to real ArrayBuffers.
 */
const buffers = new WeakMap();
```

§Explicit-honest-acknowledgment that §the-natural-shape-would-be-class-private-fields but §Hermes-doesn't-support-them. §WeakMap-emulates-private-field-AND-brand-check simultaneously.

§Sibling-pattern: cycle 199 @endo/memoize's §encapsulated-pumpkin-sentinel (`harden({})` "must not escape this module") + cycle 197 panic's §registered-symbol + §local-symbol-vs-Eval-Twin-Problem. §Three-different-ways-to-emulate-private-state in §JavaScript-without-class-private-fields:
- §Pumpkin-sentinel (cycle 199): §reference-equality-marker.
- §Registered-symbol (cycle 197): §Symbol.for crossing twin boundaries.
- §WeakMap (cycle 201): §key-based-lookup with §brand-check via §has().

§The-WeakMap-approach is §the-only-one-that-also-serves-as-brand-check by-construction.

§Borrowable-pattern: §WeakMap-as-emulated-private-field-AND-brand-check when §class-private-fields-are-not-available.

§Method-binding-pre-defineProperty:

```js
for (const methodName of ['get', 'has', 'set']) {
  defineProperty(buffers, methodName, { value: buffers[methodName] });
}
```

§Avoid-post-hoc-prototype-lookups: §the-WeakMap's-own-`get`/`has`/`set` methods are pinned as own properties (vs inherited from `WeakMap.prototype`). §Defense-against-prototype-tampering after pre-lockdown imports. §Sibling-pattern to cycle 199 trampoline's §classic-uncurry-this and cycle 181 base64's §Reflect.apply-defensive-binding.
