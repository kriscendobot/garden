---
title: §the-named-multiple-instances-first-call-wins
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

Lines 87-97 (Multiple instances section):

> The first call to `harden` from any instance of `@endo/harden` determines the behavior of any subsequent instance of `@endo/harden` that initializes later, regardless of differences in behavior.
> In a mutable, pre-lockdown JavaScript environment, it does this by **behaving somewhat like a shim**.
> A side-effect of that first call is that it installs its flavor of `harden` at `Object[Symbol.for('harden')]` and all subsequent initializations just adopt that behavior.
> This property is how `lockdown` senses that it should fail.

**§the-named-multiple-instances-first-call-wins** — first-explicit-observation. Multiple copies of @endo/harden can be loaded (npm hoisting, multi-version dependency trees). The first-call-wins discipline means: **whichever instance calls `harden` first installs its implementation at the shared intrinsic location; all subsequent instances adopt that implementation**. The discipline is enforced by the shared intrinsic location (`Object[Symbol.for('harden')]`) — once any instance writes there, it's visible to all.

**§the-named-shim-like-behavior-pre-lockdown** — first-explicit-observation. The README's own framing: *"behaving somewhat like a shim"*. The package is not a shim (because it has its own API); but it *behaves* like one in the pre-lockdown phase by installing at a global location. Compare to cycle 187's §two-shim-strategies-side-by-side (conditional vs unconditional); §the-named-shim-like-behavior-pre-lockdown is a third shim shape: shim-like-by-side-effect-of-first-call.

**§the-named-side-effect-as-coordination-mechanism** — first-explicit-observation. The first call has a SIDE EFFECT (installation at the shared intrinsic location) that becomes the coordination mechanism for all subsequent instances. Tier-3 meta-pattern: when multiple instances of a package can coexist, use a SIDE EFFECT at a SHARED LOCATION as the coordination mechanism.

**§the-named-lockdown-senses-failure-via-installed-harden** — line 96-97: *"This property is how `lockdown` senses that it should fail."* The README ACKNOWLEDGES that lockdown uses the installed harden as a sentinel for whether harden has been called pre-lockdown. **§the-named-installed-harden-as-pre-lockdown-sentinel** — first-explicit-observation. Tier-3 meta-pattern: pre-lockdown discipline violations are detectable by the *presence* of the installed harden at the shared intrinsic location.
