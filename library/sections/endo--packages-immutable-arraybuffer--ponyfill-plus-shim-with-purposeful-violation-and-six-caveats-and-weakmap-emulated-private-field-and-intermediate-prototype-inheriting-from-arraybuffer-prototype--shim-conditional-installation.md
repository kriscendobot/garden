---
title: §Shim conditional-installation-with-warning policy
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
// Modern shim practice frowns on conditional installation, at least for
// proposals prior to stage 3. This is so changes to the proposal since
// an old shim was distributed don't need to worry about the proposal
// breaking old code depending on the old shim. Thus, if we detect that
// we're about to overwrite a prior installation, we simply issue this
// warning and continue.
const overwrites = ownKeys(arrayBufferMethods).filter(
  key => key in arrayBufferPrototype,
);
if (overwrites.length > 0) {
  console.warn(
    `About to overwrite ArrayBuffer.prototype properties ${stringify(overwrites)}`,
  );
}
```

§Modern-shim-practice-frowns-on-conditional-installation. §The-rationale: §so-changes-to-the-proposal-since-an-old-shim-was-distributed-don't-need-to-worry-about-the-proposal-breaking-old-code-depending-on-the-old-shim. §Old-shim's-shape-wins by §overwriting-the-native if it ran first.

§Warning-when-overwriting + §TODO-about-lockdown'd-primordials: "if the primordials are frozen after the prior implementation, such as by `lockdown`, then this precludes overwriting as expected. However, for this case, the following warning text will be confusing."

§Honest-TODO-comment naming §the-known-broken-interaction with §lockdown.

§Borrowable-pattern: §warning-not-error-when-overwriting + §named-future-fix for the §lockdown-broken-interaction.
