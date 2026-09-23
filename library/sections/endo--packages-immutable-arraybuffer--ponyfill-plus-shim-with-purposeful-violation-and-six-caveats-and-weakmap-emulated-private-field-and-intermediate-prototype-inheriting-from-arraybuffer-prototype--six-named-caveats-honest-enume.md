---
title: §Six-named Caveats — honest enumeration of limitations
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

The README has §six-named-Caveats explicitly listed:

1. **§Platform-degradation**: ponyfill+shim rely on either `structuredClone` or `ArrayBuffer.prototype.transfer`. §Hermes / Node ≤16 / some JavaScriptCore versions have neither. §On-such-platforms the ponyfill and shim §fail-to-initialize.
2. **§No-intermediate-prototype-in-the-proposal**: the proposal modifies `ArrayBuffer.prototype` itself. §The-ponyfill-and-shim's-emulated-immutable-buffers-inherit-directly-from-an-intermediate-prototype. §Differential-behavior-via-overrides on `immutableArrayBufferPrototype`.
3. **§Intermediate-prototype-discoverable**: §the-intermediate-prototype is §an-artifact-of-the-emulation but is §not-encapsulated. §Trivially-discoverable as the object emulated immutable buffers directly inherit from.
4. **§Not-real-exotic-objects**: §the-shim's-emulated-immutable-buffers-are-not-real-ArrayBuffer-exotic-objects. §If-they-were, §the-shim-would-not-be-able-to-protect-them-from-being-written. §Cannot-be-plug-compatible — §cannot-be-used-as-the-backing-stores-of-DataViews-or-TypedArrays. §Follow-on-shims-might-modify-DataView-and-TypedArray (but §hard-and-beyond-the-ambition-of-this-ponyfill+shim).
5. **§Cannot-be-cloned-or-transferred-between-JS-threads** unlike genuine ArrayBuffer or SharedArrayBuffer.
6. **§Shim-still-runs-after-native-implementation** (the deliberate policy named earlier).
7. **§Not-hardened-by-itself** — §plain-JavaScript-ponyfill/shim, §not-Hardened-JavaScript-polyfill/shim. §The-ses-shim-is-expected-to-import-these and §treat-the-resulting-objects-as-additional-primordials, §to-be-hardened-during-lockdown's-harden-phase.

§Seven-Caveats actually — README says six but I count seven distinct named limitations. §The-enumeration-is-greppable and §each-caveat-names-its-shape.

§Borrowable-pattern: §named-Caveats-section as §honest-enumeration-of-limitations. §Sibling-pattern to cycle 197 panic's §caveat-emptor-at-the-end (single caveat) vs cycle 201's §enumerated-Caveats (six+).
