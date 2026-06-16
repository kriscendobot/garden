---
title: §Cycle 201 meta-observations
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

§The-thirty-fifth-consecutive-designs/chat-alternation-cycle 166-201. §Cycle-200-milestone-passed; §cycle-201-is-the-first-cycle-of-the-third-hundred.

§Papers-lane-blocked 95+ consecutive cycles (since cycle ~106). §The-papers-lane-block is now §nearly-half-of-the-total-cycle-count.

§Library-reaches-706-sections at cycle 201.

§Nineteenth-member of §small-files-with-large-knowledge-density family.

§Library-protocol-applied: §grep-by-source-page-existence-with-the-`endo--packages-immutable-arraybuffer`-full-slug-prefix — §no-prior-ingest-found. §Caught-via-the-protocol-from-cycle-200's-double-pivot.

§Three-WeakMap-for-private-state-patterns now in the library:
- Cycle 199 memoize: §encapsulated-pumpkin-sentinel (reference-equality marker; not a WeakMap but the same idiom).
- Cycle 201 immutable-arraybuffer: §WeakMap-as-emulated-private-field-AND-brand-check.
- Cycle 150 pass-style typeGuards: §confirm-with-Rejector-trio + §two-level-rejection-discipline (different shape entirely).

§The-Eval-Twin-Problem-chain extends: cycles 197 panic + 199 memoize.md + 201 implicit (`@endo/immutable-arraybuffer` is `not by itself a Hardened JavaScript polyfill/shim` — the ses-shim is expected to import and harden).

§Honest-design-evolution-record family is not extended this cycle (no explicit prior-design narrative; §Purposeful-Violation is a §different-shape — honest-named-deviation-from-fidelity, not honest-named-prior-design-discarded).
