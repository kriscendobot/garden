---
title: §Five-throw-methods + §six-getter-overrides on the intermediate prototype
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
const ImmutableArrayBufferInternalPrototype = {
  __proto__: arrayBufferPrototype,
  get byteLength() { return apply(arrayBufferByteLength, getBuffer(this), []); },
  get detached() { getBuffer(this); return false; },
  get maxByteLength() { return apply(arrayBufferByteLength, getBuffer(this), []); },
  get resizable() { getBuffer(this); return false; },
  get immutable() { getBuffer(this); return true; },
  slice(start, end) { return arrayBufferSlice(getBuffer(this), start, end); },
  sliceToImmutable(start, end) { return sliceBufferToImmutable(getBuffer(this), start, end); },
  resize(_newByteLength) { getBuffer(this); throw TypeError('Cannot resize an immutable ArrayBuffer'); },
  transfer(_newLength) { getBuffer(this); throw TypeError('Cannot detach an immutable ArrayBuffer'); },
  transferToFixedLength(_newLength) { getBuffer(this); throw TypeError('Cannot detach an immutable ArrayBuffer'); },
  transferToImmutable(_newLength) { getBuffer(this); throw TypeError('Cannot detach an immutable ArrayBuffer'); },
  [toStringTag]: 'ImmutableArrayBuffer',
};
```

§Six-getter-overrides (`byteLength`, `detached`, `maxByteLength`, `resizable`, `immutable`, plus `toStringTag` data property) + §five-method-overrides (`slice` returns mutable copy, `sliceToImmutable` returns immutable, `resize`/`transfer`/`transferToFixedLength`/`transferToImmutable` all throw with shape-specific message).

§Brand-check-via-`getBuffer(this)` on every accessor — even the §getters-that-don't-need-the-buffer-value (`detached`, `resizable`, `immutable`) §call-`getBuffer(this)`-for-the-brand-check-side-effect. §The-getter-must-fail-if-called-on-a-non-emulated-instance.

§Two-distinct-throw-messages: §"Cannot-resize-an-immutable-ArrayBuffer" for resize; §"Cannot-detach-an-immutable-ArrayBuffer" for the three transfer-* methods. §Two-error-categories with named-rationale.

§Slice-stays-mutable distinguishes from §sliceToImmutable: §`buffer.slice(0, 100)` on an immutable buffer §still-returns-a-mutable-copy (matching ArrayBuffer.prototype.slice's behavior); §`buffer.sliceToImmutable(0, 100)` returns a §new-immutable. §The-symmetry: §`transferToImmutable` for transfer; §`sliceToImmutable` for slice; §both-named-with-the-same-pattern.
