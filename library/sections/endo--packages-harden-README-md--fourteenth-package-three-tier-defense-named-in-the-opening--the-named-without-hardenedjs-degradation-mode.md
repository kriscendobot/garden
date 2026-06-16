---
title: §the-named-Without-HardenedJS-degradation-mode
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

Lines 70-81 (Without HardenedJS section):

> Libraries that use `@endo/harden` can be used without HardenedJS and the exported `harden` freezes the object itself and the transitive own properties of the object, **and does not traverse prototype chains**.
>
> Consequently, the surface of an object is immutable. However, if any fields of an object are optional, an attacker can subvert them **by altering their prototype**.
> This provides a degree of immutability that is useful for partial safety and does not interfere with uncoordinated alteration of the realm intrinsics, on which some testing and frontend user interface frameworks rely.

**§the-named-Without-HardenedJS-degradation-mode** — first-explicit-observation. The README explicitly documents the **degradation mode**:
- WHAT WORKS: surface immutability via transitive own-properties freeze
- WHAT DOESN'T: prototype-chain traversal — attackers can subvert via prototype alteration
- WHO BENEFITS: testing frameworks + frontend UI frameworks that rely on alterable intrinsics

**§the-named-partial-safety-with-named-tradeoff** — first-explicit-observation. The README NAMES the partial-safety mode as *useful* (not just acceptable). The tradeoff is named explicitly: less safety in exchange for compatibility with testing/UI frameworks.

**§the-named-test-and-UI-framework-acknowledgment** — first-explicit-observation. The README acknowledges PARALLEL ECOSYSTEM CONSTRAINTS: testing and UI frameworks rely on alterable intrinsics; @endo/harden in degraded mode coexists with them. Compare to cycle 327 @endo/patterns README's §the-named-three-Why-X-sections (three context-setting paragraphs); §the-named-test-and-UI-framework-acknowledgment is a one-line variant — name the parallel ecosystem in a single clause.

**§the-named-uncoordinated-alteration-of-realm-intrinsics** — the phrase is the README's own naming for what testing and UI frameworks do. The pejorative-sounding word "uncoordinated" is used neutrally as a technical description of the alteration pattern. **§the-named-precise-technical-language-without-pejorative-tone** — first-explicit-observation as a tier-3 meta-pattern. Compare to cycle 186's *"illusion of an option"* (sharper pejorative); cycle 337's *"uncoordinated alteration"* is the neutral variant. **§two-shapes-of-precise-technical-language** (sharp + neutral) — first-explicit-observation.
