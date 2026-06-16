---
title: §the-named-Object-Symbol.for-harden-intrinsic
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

Lines 42-43 + 55-59:

> The package `@endo/harden` reexports `Object[Symbol.for('harden')]` or `globalThis.harden` in its execution environment, **in order of preference**. (...)
>
> The `harden` in `@endo/harden` **prefers `Object[Symbol.for('harden')]`** because endowments cannot override that intrinsic. Any multi-tenant `Compartment` should freeze its own `globalThis`, including making `harden` non-configurable and non-writable, so there is no risk of tampering.

**§the-named-Object-Symbol.for-harden-intrinsic** — first-explicit-observation. The intrinsic location is `Object[Symbol.for('harden')]` — a SHARED intrinsic property accessed through Symbol.for. **Why a symbol property?** Because:
- Plain string property names (`Object.harden`) would collide with user code; symbols don't
- `Symbol.for(name)` creates a *registered symbol* available across realms — every compartment that calls `Symbol.for('harden')` gets the same symbol
- `Object` is a hardened shared intrinsic; properties of it cannot be overridden in a compartment

**§the-named-intrinsic-over-endowment-discipline** — first-explicit-observation. The discipline: **when both an intrinsic property and an endowment can provide a capability, prefer the intrinsic** because endowments can be overridden in nested compartments. Compare to cycle 142 passStyle-helpers.js's §safer-but-slower-on-XS tradeoff (different security/performance trade-off); §the-named-intrinsic-over-endowment is the security/portability variant. **§the-named-intrinsic-vs-endowment-distinction** as a tier-3 meta-pattern.

**§the-named-cannot-be-subverted-in-a-compartment** — line 53: *"a property of one of the hardened shared intrinsics and **cannot be subverted in a compartment**"*. The README NAMES THE INVARIANT explicitly. **§the-named-invariant-named-with-cannot-language** — first-explicit-observation. "Cannot" is a stronger guarantee than "should not" or "is not"; the README uses the strongest available language. Compare to cycle 152 memo-race.js's §state-machine-with-frozen-terminal-state (state can't be un-frozen).
