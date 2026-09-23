---
title: §Ponyfill+Shim pattern (sibling to cycle 197 panic)
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

§The-package-exports-both-shapes:
- **§Ponyfill** (`index.js` → `src/immutable-arraybuffer-pony.js`): §defines-and-exports-new-things-without-modifying-old-things. Exports `transferBufferToImmutable(buffer)`, `sliceBufferToImmutable(buffer, start?, end?)`, `isBufferImmutable(buffer)` as standalone functions. §A-ponyfill-by-definition-cannot-add-to-ArrayBuffer.prototype, so it must expose §brand-new-functions.
- **§Shim** (`shim.js`): §modifies-the-existing-JavaScript-primordials-as-needed. Trivially derived from the ponyfill's exports. Imports `@endo/immutable-arraybuffer/shim.js` §will-cause-the-prototype-additions.

§Cycle-197-@endo/panic-was-ponyfill-only — the panic README explicitly defers the shim "until the proposal gets farther along in the tc39 stage process". §Cycle-201-@endo/immutable-arraybuffer-is-ponyfill-plus-shim — both shapes shipped simultaneously because §the-proposal's-status allows both.

§Two-named-policies-for-the-shim:
- §Modern-shim-practice-frowns-on-conditional-installation (at least for proposals prior to stage 3): §so-changes-to-the-proposal-since-an-old-shim-was-distributed-don't-need-to-worry-about-the-proposal-breaking-old-code-depending-on-the-old-shim. §If-we-detect-a-prior-installation, §warn-and-continue (overwriting).
- §Shim-still-runs-after-native-implementation: §"current-code-will-still-replace-it-with-the-shim-implementation, in-accord-with-shim-best-practices". §Will-require-a-later-manual-step-to-delete-the-shim, after-manual-analysis-of-the-compat-implications.

§Borrowable-pattern: §deliberate-policy-with-named-future-cleanup-step. §The-design-acknowledges-the-shim-is-not-the-end-state and §names-the-cleanup-step-explicitly.
