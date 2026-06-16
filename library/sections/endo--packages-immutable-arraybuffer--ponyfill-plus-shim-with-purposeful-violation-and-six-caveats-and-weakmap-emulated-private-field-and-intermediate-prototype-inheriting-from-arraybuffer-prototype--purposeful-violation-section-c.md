---
title: §Purposeful Violation section — concordance-sniff-defense
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

The README has §an-explicitly-named-section called **§Purposeful Violation**:

> Since the `ImmutableArrayBufferInternal` class is only an artifact of the ponyfill and shim (i.e., is absent both from the real proposal and from native implementations), `ImmutableArrayBufferInternal` should not need its own `Symbol.toStringTag` property. Especially not one that differs from `ArrayBuffer.prototype`. Adding one reduces the fidelity of the ponyfill and shim. Nevertheless, we set `ImmutableArrayBufferInternal.prototype[Symbol.toStringTag]` to `'ImmutableArrayBuffer'`. Why?
>
> At [concordance describe.js#L36] Node's concordance, in order to render diagnostic output for an object, sniffs the result of `toString()`. If the result seems to indicate that the object is an ArrayBuffer, then concordance assumes it can do things with the object (`Buffer.from`) that can only be done on genuine ArrayBuffers. To avoid this, the ponyfill and shim ensures that the sniff will not match `'ArrayBuffer'`.
>
> Ava also uses Node's concordance for its diagnostic output, which is how we discovered the problem.

§Purposeful-Violation as §a-README-section-shape is §a-rare-pattern in the library — §an-explicit-named-acknowledgment that §the-implementation-deviates-from-fidelity for §a-named-pragmatic-reason. §Concordance-sniff-defense is §the-named-pragmatic-reason; §Ava-uses-concordance is §how-it-was-discovered.

§The-pattern: §when-you-must-violate-fidelity-name-the-violation-and-its-rationale. §Sibling-to cycle 197 panic's §"defer-to-the-whose-shim-ran-first" typo-preservation (the source is honest about its imperfections) and cycle 196 endoclaw's §"contitues-a-claw" typo-preservation. §Honest-source-discipline at different scales.

§Borrowable-pattern: §Purposeful-Violation-section in README documenting §named-deliberate-deviations from §the-fidelity-target.

§Sibling-pattern to cycle 198 patterns-diagnostic-feedback's §the-data-is-already-there-just-locked discovery: both designs §explicitly-name-the-cost-of-a-design-choice. §198-names-a-discovery-driven-redesign; §201-names-a-fidelity-violation-driven-defense.
