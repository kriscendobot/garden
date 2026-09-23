---
title: §the-named-dual-purpose-of-harden
source: endo--packages-harden-README-md
url: https://github.com/endojs/endo/blob/master/packages/harden/README.md
authors: [Kris Kowal, Mark S. Miller, Jean-Francois Paradis, Endo project (collective)]
repo: endojs/endo
path: packages/harden/README.md
total-lines: 158
ingest-cycle: 337
ingest-date: 2026-06-15
lane: designs
section-tags:
  - the-named-three-tier-defense-named-in-the-opening
  - the-named-threat-model-named-first
  - the-named-supply-chain-attack-IS-named-threat-model
  - the-named-place-to-stand-toward-its-own-defense-metaphor
  - the-named-dual-purpose-of-harden
  - the-named-Object-Symbol.for-harden-intrinsic
  - the-named-intrinsic-over-endowment-discipline
  - the-named-build-condition-as-policy-knob
  - the-named-two-named-build-conditions
  - the-named-multiple-instances-first-call-wins
  - the-named-shim-like-behavior-pre-lockdown
  - the-named-with-OR-without-NOT-both-policy
  - the-named-temporal-ordering-creates-vulnerability
  - the-named-helpful-stack-on-misuse
  - the-named-stack-points-to-the-offending-module
  - the-named-isFake-deprecated-with-named-regret
  - the-named-honest-regret-in-README
  - the-named-migration-path-with-named-alternative
  - the-named-Without-HardenedJS-degradation-mode
  - the-named-partial-safety-with-named-tradeoff
  - the-named-test-and-UI-framework-acknowledgment
  - the-named-six-section-policy-README-shape
  - the-named-fourteenth-package-in-the-pivot-cluster
  - twenty-eight-cycles-with-named-pivot-domain-stay
  - fifty-six-citation-arc-closures-in-pivot-now
  - the-named-substrate-package-with-policy-README
parent: endo--packages-harden-README-md--fourteenth-package-three-tier-defense-named-in-the-opening
---

Lines 21-24:

> In order to provide type information about the global `harden` in locked-down HardenedJS, **and also** to make it possible for hardened modules to be used outside HardenedJS, the `@endo/harden` package exports a `harden` function that can be used either way.

**§the-named-dual-purpose-of-harden** — first-explicit-observation. ONE package serves TWO purposes:
1. **Type information** — give TypeScript a typed surface for the global `harden`
2. **Cross-environment portability** — let hardened modules work both *inside* HardenedJS (where global harden is real) and *outside* (where harden degrades gracefully)

The dual purpose is named **explicitly with "and also"** as the conjunction. The README does not bury one purpose behind the other; both are stated as primary.

**§the-named-and-also-as-two-purpose-conjunction** — first-explicit-observation. Compare to cycle 333 @endo/common's §the-named-four-named-membership-criteria (four named purposes for the package); §the-named-dual-purpose is the two-purpose variant of the same naming discipline.

**§the-named-substrate-package-with-policy-README** — first-explicit-observation. The README documents **purposes and policies**, not API. Compare to cycle 333 @endo/common's §the-named-README-as-policy-not-API; cycle 337 harden's README extends the pattern: substrate-packages with policy-README shape (not API documentation).
