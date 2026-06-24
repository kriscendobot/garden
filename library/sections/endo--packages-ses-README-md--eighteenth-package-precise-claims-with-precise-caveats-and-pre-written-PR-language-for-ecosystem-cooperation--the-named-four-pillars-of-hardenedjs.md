---
title: §the-named-four-pillars-of-HardenedJS
source: endo--packages-ses-README-md
url: https://github.com/endojs/endo/blob/master/packages/ses/README.md
authors: [Kris Kowal, Mark S. Miller, Endo project (collective)]
repo: endojs/endo
path: packages/ses/README.md
total-lines: 964
ingest-cycle: 345
ingest-date: 2026-06-15
lane: designs
section-tags:
  - the-named-precise-claims-with-precise-caveats-discipline
  - the-named-pre-written-PR-language-for-ecosystem-cooperation
  - the-named-acronym-with-named-philosophical-expansion
  - the-named-SES-stands-for-fearless-cooperation
  - the-named-four-pillars-of-HardenedJS
  - the-named-host-program-vs-guest-program-vocabulary
  - the-named-canonical-deployers-named-with-logos
  - the-named-three-attack-categories-lockdown-defends-against
  - the-named-undeniable-objects-discipline
  - the-named-taming-as-named-verb-of-art
  - the-named-realm-vs-compartment-distinction
  - the-named-three-tiers-of-isolation-claims
  - the-named-list-of-things-guest-cannot-do
  - the-named-list-of-things-guest-can-still-do
  - the-named-Trusted-Compute-Base-enumerated
  - the-named-override-mistake-as-named-JavaScript-anti-feature
  - the-named-defineProperties-workaround-for-override-mistake
  - the-named-audit-history-as-trust-signal
  - the-named-purple-teaming-as-collaborative-audit-style
  - the-named-Caja-as-named-predecessor-with-named-extensions
  - the-named-Math-random-and-Date-now-disabled-by-default
  - the-named-SharedArrayBuffer-as-named-attack-vector
  - the-named-reentrancy-attack-named-explicitly
  - the-named-defending-via-clean-stack-promise
  - the-named-locale-methods-as-fingerprinting-vector
  - the-named-eighteenth-package-in-the-pivot-cluster
  - the-named-964-line-substrate-policy-vast-README
  - eight-cycles-with-named-substrate-package-introduction
  - thirty-six-cycles-with-named-pivot-domain-stay
  - one-hundred-sixteen-citation-arc-closures-in-pivot-now
parent: endo--packages-ses-README-md--eighteenth-package-precise-claims-with-precise-caveats-and-pre-written-PR-language-for-ecosystem-cooperation
---

Lines 9-20 enumerate the FOUR pillars:

| Pillar | One-line description |
|---|---|
| **Compartments** | Separate execution contexts each with own globalThis and global lexical scope |
| **Frozen realm** | Compartments share intrinsics (avoids identity discontinuity); freezing protects programs from each other |
| **Strict mode** | Enforces JavaScript strict mode (silent failures become thrown errors) |
| **POLA** (Principle of Least Authority) | Compartments receive no ambient authority by default |

**§the-named-four-pillars-of-HardenedJS** — first-explicit-observation as a tier-3 meta-pattern. The README distills the entire HardenedJS architecture to FOUR named pillars, each with a bolded keyword + one-line description.

Compare to:
- Cycle 337 @endo/harden's three-tier defense (HardenedJS + LavaMoat + harden()) — at the META level (three layers of defense)
- **Cycle 345 @endo/ses's four pillars** — at the COMPONENT level (four parts of HardenedJS itself)

**§two-shapes-of-architectural-summary** (cycle 337 three-tier-meta-defense + cycle 345 four-pillars-component-architecture) — first-explicit-observation as a tier-2 multi-cycle pattern.

**§the-named-bolded-keyword-as-pillar-marker** — first-explicit-observation. Each pillar starts with `**Bold**` to highlight the named concept. The discipline: when listing named components, bold the name.
