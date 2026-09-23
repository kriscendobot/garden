---
title: §By-copy network protocol rationale + §ROM-vs-RAM Moddable XS rationale
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

§Two-named-motivations explicitly in the README:

### Motivation 1: §ROM-vs-RAM Moddable XS rationale

> Some JavaScript implementations, like Moddable XS, bring JavaScript to embedded systems, like device controllers, where ROM is much more plentiful and cheaper than RAM. These systems need to place voluminous fixed data into ROM, and currently do so using semantics outside the official JavaScript standard.

§Embedded-systems-need-immutable-data-in-ROM-not-RAM. §Currently-done-with-semantics-outside-the-official-standard. §The-proposal-would-bring-the-mechanism-into-the-standard.

### Motivation 2: §By-copy network protocol rationale

> The OCapN network protocol treats strings and byte-arrays as distinct forms of bulk data to be transmitted by copy. At JavaScript endpoints speaking OCapN such as `@endo/pass-style` + `@endo/marshal`, JavaScript strings represent OCapN strings. The immutability of strings in the JavaScript language reflects their by-copy nature in the protocol. Likewise, to reflect an OCapN byte-array well into the JavaScript language, we need an immutable container of bulk binary data. There currently are none. An Immutable `ArrayBuffer` would provide exactly the low-level machinery we need.

§The-network-capability-protocol-treats-byte-arrays-as-bulk-data-transmitted-by-copy. §JavaScript-strings-reflect-this-by-copy-nature-via-immutability. §An-immutable-ArrayBuffer is §the-symmetric-shape for byte-arrays. §@endo/pass-style + @endo/marshal are the §JavaScript-endpoints that would consume this.

§Two-motivations-from-orthogonal-domains (embedded ROM systems + by-copy network protocols) converging on the same primitive. §Borrowable-pattern: §named-motivations-from-orthogonal-domains as §the-shape-of-a-proposal-rationale.

§The-proposal-target: §`ArrayBuffer.prototype.transferToImmutable()`-method + §`ArrayBuffer.prototype.immutable`-getter. §Two-named-additions.
