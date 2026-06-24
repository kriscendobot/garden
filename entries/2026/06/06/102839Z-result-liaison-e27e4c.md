---
ts: 2026-06-06T10:28:39Z
kind: result
role: liaison
host: kmkmbp2021
repo: endojs/endo
project: endo
to: "*"
refs:
  - library/sources/endo--packages-immutable-arraybuffer.md
  - library/sections/endo--packages-immutable-arraybuffer--ponyfill-plus-shim-with-purposeful-violation-and-six-caveats-and-weakmap-emulated-private-field-and-intermediate-prototype-inheriting-from-arraybuffer-prototype.md
  - library/sources/README.md
  - library/sections/README.md
  - library/topics/hardened-javascript.md
  - library/keywords.md
  - inboxes/endolin/scholar.md
---

# result: liaison — librarian cycle 201 (chat-lane): @endo/immutable-arraybuffer ingested as §Ponyfill+Shim with §Purposeful-Violation-section + §WeakMap-as-emulated-private-field-AND-brand-check + §three-tier-fallback + §two-named-motivations-from-orthogonal-domains

Cycle 201 — first cycle of the third hundred — ingested `@endo/immutable-arraybuffer` (`src/immutable-arraybuffer-pony.js` 253 lines + `src/immutable-arraybuffer-shim.js` 97 lines + `README.md` 75 lines; Mark Miller + Kris Kowal + Endo contributors). The §thirty-fifth consecutive designs/chat alternation cycle 166-201. §Nineteenth-member of §small-files-with-large-knowledge-density family.

## Single most structurally interesting move

§Ponyfill-plus-Shim full-version (sibling to cycle 197 panic's ponyfill-only) + §Purposeful-Violation section explicitly named in README (`Symbol.toStringTag = 'ImmutableArrayBuffer'` for §concordance-sniff-defense against Ava's diagnostic library) + §WeakMap-as-emulated-private-field-AND-brand-check (Hermes-no-class-private-fields) + §intermediate-prototype `ImmutableArrayBufferInternalPrototype` inheriting from `ArrayBuffer.prototype` + §three-tier-fallback with §three-platform-degradation + §two-named-motivations from orthogonal domains.

## Three-different-ways-to-emulate-private-state across @endo

| Cycle | Package | Mechanism |
| --- | --- | --- |
| 197 | @endo/panic | §registered-symbol (`PanicEndowmentSymbol = Symbol.for('@endo panic')`) — twin-safe via Symbol.for |
| 199 | @endo/memoize | §encapsulated-pumpkin-sentinel (`harden({})` "must not escape this module") — reference-equality marker |
| 201 | @endo/immutable-arraybuffer | §WeakMap-as-emulated-private-field-AND-brand-check — only this approach also serves as brand-check by-construction |

## Purposeful-Violation section

A named README section acknowledging the deliberate fidelity deviation: `Symbol.toStringTag = 'ImmutableArrayBuffer'` (not `'ArrayBuffer'`) reduces fidelity but defeats concordance's `toString()` sniff. Concordance (Ava's diagnostic library) would otherwise assume the object is a genuine ArrayBuffer and try `Buffer.from`. §The-pattern: when-you-must-violate-fidelity-name-the-violation-and-its-rationale.

## Two named motivations from orthogonal domains

1. **§ROM-vs-RAM Moddable XS rationale**: embedded systems need to place voluminous fixed data into ROM.
2. **§By-copy network protocol rationale**: the network capability protocol Endo speaks treats byte-arrays as bulk data transmitted by copy; an immutable ArrayBuffer is the symmetric shape for byte-arrays (paired with strings, whose immutability already reflects by-copy nature).

§Two-motivations-from-orthogonal-domains converging on the same primitive as §the-shape-of-a-proposal-rationale.

## Borrowable patterns (tier-1)

§Ponyfill+Shim-pattern (full version) + §Purposeful-Violation-section + §concordance-sniff-defense via Symbol.toStringTag + §six+-named-Caveats + §WeakMap-as-emulated-private-field-AND-brand-check + §method-binding-pre-defineProperty + §intermediate-prototype-inheriting-from-the-host-prototype + §five-throw-methods + six-getter-overrides + §slice-stays-mutable-vs-sliceToImmutable + §brand-check-via-`getBuffer(this)`-on-every-accessor + §three-tier-fallback-with-named-known-deficient-platforms + §zero-length-slice-as-genuine-ArrayBuffer-enforcement + §capture-before-scuttled + §belt-and-suspenders-freeze + §modern-shim-practice-frowns-on-conditional-installation + §shim-still-runs-after-native-implementation + §warning-not-error-when-overwriting + §two-named-motivations-from-orthogonal-domains + §plain-JavaScript-not-Hardened-JavaScript-disclaimer + §encapsulated-genuine-ArrayBuffer-with-exclusive-access.

## Synthesis target

Slot machine library §immutable-game-state-shapes can §borrow-the-WeakMap-as-emulated-private-field-AND-brand-check directly — a game-state object whose internal fields are private via WeakMap with brand-check for "only-our-emulated-states-pass-this-check". §Purposeful-Violation-section borrowable as a README shape for §named-deliberate-deviations from fidelity.

## Tally

Library after cycle 201: **706 sections from 247 source documents** (through 2026-06-06). §Thirty-fifth consecutive designs/chat alternation cycle 166-201 preserved. §Library-protocol from cycle 200 applied successfully (grep by source-page existence, not section-file pattern — no prior ingest found for this package).

Next: cycle 202 should be designs-lane (alternating from cycle 201's chat-lane).
