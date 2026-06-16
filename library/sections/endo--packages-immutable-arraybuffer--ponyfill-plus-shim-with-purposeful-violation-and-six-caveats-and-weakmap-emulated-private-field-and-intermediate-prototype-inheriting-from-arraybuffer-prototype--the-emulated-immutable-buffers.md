---
title: §The-emulated-immutable-buffers-inherit-from-ArrayBuffer.prototype-transitively
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

> The emulated immutable buffers inherit directly from an intermediate prototype we refer to as `immutableArrayBufferPrototype`. This intermediate prototype contains all the methods and read-only accessor properties proposed here, as well as overrides of those inherited from `ArrayBuffer.prototype` as needed to emulate the behavior of an immutable instance. For each emulated immutable buffer, the implementation encapsulates a genuine `ArrayBuffer` that it has exclusive access to, so it can enforce immutability simply by never modifying it.

§Encapsulated-genuine-ArrayBuffer-with-exclusive-access — §security-demands-exclusive-access. §Immutability-enforced-by-never-modifying-it. §The-emulated-immutable-buffer §holds-a-genuine-ArrayBuffer-in-the-WeakMap and §exposes-an-overridden-API that §never-touches-the-underlying-buffer-mutably.

§`makeImmutableArrayBufferInternal`-must-not-escape:

```js
// Since `makeImmutableArrayBufferInternal` MUST not escape,
// this `freeze` is just belt-and-suspenders.
freeze(makeImmutableArrayBufferInternal);
```

§Belt-and-suspenders-freeze. §The-comment-names-that-the-factory-must-not-escape (the module exports only the high-level functions, not the internal factory) and §freezes-anyway-as-defense-in-depth.

§Sibling-pattern: cycle 199 memoize's §encapsulated-pumpkin-marked-"must-not-escape-this-module" + cycle 175 harden-selector's §pin-on-first-install. §Honor-system-discipline-with-named-defense-in-depth.
