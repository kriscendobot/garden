---
title: §Borrowable patterns (tier-1)
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

1. **§Ponyfill+Shim pattern (full version)** — both shapes exported simultaneously; sibling to cycle 197 panic's ponyfill-only.
2. **§Purposeful-Violation-section in README** — §explicit-named-acknowledgment of §named-deliberate-deviations from §the-fidelity-target with §named-pragmatic-reason.
3. **§Concordance-sniff-defense via Symbol.toStringTag** — when a diagnostic library sniffs `toString()`, set the tag to something that doesn't match the sniffed pattern.
4. **§Six+-named Caveats** as §honest-enumeration-of-limitations in README.
5. **§WeakMap-as-emulated-private-field-AND-brand-check** when §class-private-fields-are-not-available (e.g., Hermes).
6. **§Method-binding-pre-defineProperty** on the WeakMap (`buffers.has = buffers.has`) to §avoid-post-hoc-prototype-lookups.
7. **§Intermediate-prototype-`InternalPrototype`-inheriting-from-the-host-prototype** when §the-proposal-modifies-the-host-prototype-directly but §the-emulation-cannot.
8. **§Five-throw-methods-on-immutable-prototype** with §two-distinct-error-messages (resize vs detach) for §two-error-categories.
9. **§Slice-stays-mutable / sliceToImmutable distinction** — §explicit-method-naming-with-the-shape.
10. **§Brand-check-via-`getBuffer(this)`-on-every-accessor** — even getters that don't need the buffer-value call it for the side-effect.
11. **§Three-tier-fallback: native-transfer → structuredClone → undefined** with §named-known-deficient-platforms (Hermes / Node ≤16 / some JavaScriptCore).
12. **§Zero-length-slice-as-genuine-ArrayBuffer-enforcement** — method-call-as-type-enforcement-side-effect.
13. **§Capture-before-scuttled** pre-lockdown discipline with §named-imports-and-named-rationale-in-comment.
14. **§Belt-and-suspenders-freeze on must-not-escape factory** — honor-system-discipline-with-defense-in-depth.
15. **§Modern-shim-practice-frowns-on-conditional-installation** as §named-shim-philosophy.
16. **§Shim-still-runs-after-native-implementation** as §deliberate-policy-with-named-future-cleanup-step.
17. **§Warning-not-error-when-overwriting** with §TODO-comment naming §the-known-broken-interaction with §lockdown.
18. **§Two-named-motivations-from-orthogonal-domains** (ROM-vs-RAM embedded + by-copy network protocol) converging on the same primitive — as §the-shape-of-a-proposal-rationale.
19. **§Plain-JavaScript-not-Hardened-JavaScript** disclaimer + §expected-interaction-with-ses-shim-lockdown-harden-phase.
20. **§Encapsulated-genuine-ArrayBuffer-with-exclusive-access** for §immutability-enforced-by-never-modifying-it.
