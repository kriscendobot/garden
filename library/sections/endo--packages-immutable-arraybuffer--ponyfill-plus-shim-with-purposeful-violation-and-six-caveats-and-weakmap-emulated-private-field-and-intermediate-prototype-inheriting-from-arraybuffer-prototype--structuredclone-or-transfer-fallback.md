---
title: §structuredClone-or-transfer-fallback
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
let optArrayBufferTransfer;

if (optTransfer) {
  optArrayBufferTransfer = arrayBuffer => apply(optTransfer, arrayBuffer, []);
} else if (optStructuredClone) {
  optArrayBufferTransfer = arrayBuffer => {
    // Hopefully, a zero-length slice is cheap, but still enforces that
    // `arrayBuffer` is a genuine `ArrayBuffer` exotic object.
    arrayBufferSlice(arrayBuffer, 0, 0);
    return optStructuredClone(arrayBuffer, { transfer: [arrayBuffer] });
  };
} else {
  optArrayBufferTransfer = undefined;
}
```

§Three-tier-fallback: §`ArrayBuffer.prototype.transfer` (modern Node 21+) → §`structuredClone({transfer: [...]})` (Node 17+) → §undefined (graceful degradation, ponyfill+shim fail to initialize).

§Sibling-pattern to cycle 197 panic's §three-layer-dispatch-chain (console.error → globalThis[PanicEndowmentSymbol] → process.abort → globalThis.panic → throw). §Both-designs §enumerate-mechanisms-from-best-to-degraded with §explicit-named-fallbacks.

§Zero-length-slice-as-genuine-ArrayBuffer-enforcement (`arrayBufferSlice(arrayBuffer, 0, 0)` before structuredClone): §the-side-effect-is-enforcing-that-arrayBuffer-is-a-genuine-ArrayBuffer-exotic-object (slice would throw on a non-exotic). §`Hopefully-a-zero-length-slice-is-cheap` — §honest-comment-naming-the-cost-uncertainty.

§Borrowable-pattern: §method-call-as-type-enforcement-side-effect when §the-thrown-error-from-the-method-is-the-desired-validation. §Sibling-pattern to cycle 199 memoize's §non-weak-key-compat-early-error (try `memo.set(arg, ...)` so the WeakMap throws if arg isn't a valid key).
