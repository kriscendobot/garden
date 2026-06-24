---
title: The single most structurally interesting move
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

**§the-named-three-tier-defense-named-in-the-opening** — lines 3-17 of the README open with the threat model and three coordinated defenses:

1. **Sentence 1 (lines 3-5)**: *"Hardened modules are modules that make their interface resist tampering by other modules that import them, **making them less susceptible to supply chain attack**."*
2. **Tier 1 — HardenedJS (lines 7-12)**: *"In HardenedJS, the global `harden` function transitively freezes an object and all of the objects that are reachable by walking chains of properties and prototypes. All the primordials like `Array.prototype` and `Object` are frozen in this environment, **which gives your module a place to stand toward its own defense**."*
3. **Tier 2 — LavaMoat (lines 13-17)**: *"Then, with LavaMoat, each package is credibly isolated and only receives the subset of globals and host modules it needs to function. That is, we can enforce **Principle of Least Authority**."*
4. **Tier 3 — harden() (lines 18-19)**: *"But, that leaves the module to use `harden` to freeze all its exports and anything it returns that might be shared by other packages that use it."*

**§the-named-three-tier-defense-named-in-the-opening** — first-explicit-observation as a tier-3 meta-pattern. The README's opening paragraph:
- Names the **threat** first (supply chain attack via tampering)
- Names **three coordinated defenses** — HardenedJS (primordials) + LavaMoat (POLA) + harden() (per-module hardening)
- Identifies **the package's role** as the third tier — what to do AFTER your environment gives you a place to stand

**§the-named-threat-model-named-first** — first-explicit-observation. README opens with WHAT WE ARE DEFENDING AGAINST before HOW WE DEFEND. Compare to cycle 317 @endo/hex README (§the-named-supply-chain-attack-exposure-IS-named-threat-model-for-harden, which named the threat model in the *context of the hex package*); cycle 337 is the **canonical statement** of the threat model — supply chain attack is the *primary* threat that the entire HardenedJS stack defends against.

**§the-named-supply-chain-attack-IS-named-threat-model** — first-explicit-observation as the canonical threat-model anchor. The phrase *"supply chain attack"* appears in the README's first sentence; no other threat is named higher. Tier-3 meta-pattern: when a substrate package's README defines a defense, name the threat at the highest level.

**§the-named-place-to-stand-toward-its-own-defense-metaphor** — first-explicit-observation. The phrase *"gives your module a place to stand toward its own defense"* is a vivid metaphor for what HardenedJS provides. Compare to cycle 87 pass-style/error.js's §V8-stack-accessor-channel (a metaphor for capability channels). Two cycles with named architectural metaphors in @endo. **§two-cycles-with-named-architectural-metaphor** (87 + 337).
