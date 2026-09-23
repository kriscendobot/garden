---
title: Synthesis-target
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

Slot machine library **§`@game/harden/README.md`** — substrate-package policy README:

1. **Threat model named first** — open with what we're defending against (e.g., cheating, unauthorized state mutation, side-channel attacks)
2. **Three-tier defense named in the opening** — name the threat + three coordinated defenses + the package's role in the stack
3. **Architectural metaphor for what the substrate provides** — *"a place to stand toward its own defense"* is borrowable; a slot-machine substrate could give modules *"a deterministic foundation for their own randomness"*
4. **Dual-purpose with and-also conjunction** — name multiple purposes explicitly; don't bury one behind the other
5. **Intrinsic over endowment** — when an intrinsic property AND a global both provide a capability, prefer the intrinsic
6. **Build conditions as policy knobs** — expose policy choices at build time; name both endpoints of the spectrum
7. **First-call-wins coordination for multiple instances**
8. **With OR Without NOT Both** — name the temporal-ordering trap explicitly
9. **Helpful stack on misuse** — runtime-detected discipline violations point to the offending module
10. **prepare-* naming convention** — by convention, modules whose names start with `prepare-` are initialization-side-effect modules
11. **Honest regret + migration path with named alternative** — when deprecating a past design choice, explicitly regret it and provide migration code with the rationale
12. **Degradation mode named with tradeoff** — when the package works in a less-safe environment, name what works AND what doesn't AND who benefits
13. **Precise technical language without pejorative tone** — *"uncoordinated alteration"* not *"misuse"*
14. **Six-headed-section policy README shape** for substrate-packages
