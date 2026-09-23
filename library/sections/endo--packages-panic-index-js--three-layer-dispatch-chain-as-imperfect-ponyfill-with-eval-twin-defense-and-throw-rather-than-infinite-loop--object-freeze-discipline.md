---
title: §`Object.freeze` discipline
source: endo packages/panic/{index.js,README.md,SECURITY.md,CHANGELOG.md}
source-slug: endo--packages-panic
ingest-cycle: 197
ingest-date: 2026-06-06
lane: chat
authors: [Mark Miller, Kris Kowal]
keywords:
  - ponyfill-vs-shim distinction
  - Eval Twin Problem
  - registered-symbol vs novel-subclass
  - three-layer dispatch chain
  - infinite-regress check
  - throw-rather-than-infinite-loop
  - lastResortError as identity check (forgeable + non-forgeable both honestly named)
  - prepare-commit-transactional-pattern as canonical use-case
  - Don't Remember Panicking TC39 proposal
  - PanicEndowmentSymbol following passStyleOfEndowmentSymbol precedent
  - default-erroneous-exit + no-ambient-normal-exit
  - historical-note-explaining-why-ambient-panic-no-longer-loses-security
related:
  - endo--packages-pass-style (sibling: PassStyleOfEndowmentSymbol precedent + Eval Twin Problem)
  - endo--packages-errors (panic README: makeError/X/q template tag)
  - endo--packages-marshal-src-marshal-justin-and-marshal-stringify-js (cycle 189: also cites Eval Twin defenses + qp-vs-q template tag pair)
  - endo--packages-init-and-lockdown (cycle 183: two-phase init also depends on SES primordials)
parent: endo--packages-panic-index-js--three-layer-dispatch-chain-as-imperfect-ponyfill-with-eval-twin-defense-and-throw-rather-than-infinite-loop
---

```js
Object.freeze(lastResortError);
// ...
Object.freeze(panic);
```

Both exports are §frozen-but-not-hardened. Sibling to cycle 146 E.js's §freeze-but-not-harden-the-proxy-target (both cite §preparing-for-stabilize-doc rationale). The author cannot use `harden` here because `@endo/panic` is loaded before SES might have run lockdown; freezing without `harden` provides §non-trapdoor-immutability without depending on the SES whitelist.

§Why-freeze-`panic`: §so-attackers-cannot-monkey-patch-the-exported-function to swap it for something that returns rather than terminates. §Why-freeze-`lastResortError`: §so-the-identity-check-cannot-be-spoofed-via-property-replacement.
