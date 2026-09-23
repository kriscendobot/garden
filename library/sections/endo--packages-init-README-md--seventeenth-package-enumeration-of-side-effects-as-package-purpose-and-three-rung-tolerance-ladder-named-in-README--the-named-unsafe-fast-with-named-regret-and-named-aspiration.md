---
title: §the-named-unsafe-fast-with-named-regret-and-named-aspiration
source: endo--packages-init-README-md
url: https://github.com/endojs/endo/blob/master/packages/init/README.md
authors: [Kris Kowal, Endo project (collective)]
repo: endojs/endo
path: packages/init/README.md
total-lines: 52
ingest-cycle: 343
ingest-date: 2026-06-15
lane: designs
section-tags:
  - the-named-enumeration-of-side-effects-as-package-purpose
  - the-named-five-named-actions-performed-on-import
  - the-named-default-is-fully-locked-down
  - the-named-three-entry-point-tolerance-ladder-named-in-README
  - the-named-debug-as-less-safe-but-conducive-to-debugging
  - the-named-detailed-rationale-for-each-debug-option
  - the-named-cross-package-compensation-named
  - the-named-ses-ava-compensates-for-Ava-specifically
  - the-named-unsafe-fast-with-named-regret-and-named-aspiration
  - the-named-extreme-measure-we-hope-to-obviate
  - the-named-hr-separator-as-section-divider
  - the-named-seventeenth-package-in-the-pivot-cluster
  - the-named-fifty-two-line-policy-deep-README
  - the-named-substrate-policy-prose-shape-confirmed
  - thirty-four-cycles-with-named-pivot-domain-stay
  - ninety-eight-citation-arc-closures-in-pivot-now
  - six-cycles-with-named-substrate-package-introduction
parent: endo--packages-init-README-md--seventeenth-package-enumeration-of-side-effects-as-package-purpose-and-three-rung-tolerance-ladder-named-in-README
---

Lines 47-48:

> Avoid using `@endo/init/unsafe-fast.js`.
> **It is an extreme measure we hope to obviate.**

**§the-named-unsafe-fast-with-named-regret-and-named-aspiration** — first-explicit-observation. The README explicitly says:
1. *Avoid using* (named regret about its existence)
2. *Extreme measure* (named characterization of severity)
3. *We hope to obviate* (named aspiration to remove)

**§the-named-extreme-measure-we-hope-to-obviate** — first-explicit-observation as a tier-3 meta-pattern. Compare to cycle 337's §the-named-isFake-deprecated-with-named-regret (*"We regret this misfeature"*) — same shape of honest-regret-in-README, but at a different level:
- Cycle 337: regret about a past design choice
- Cycle 343: regret about an existing entry point + aspiration to remove it

**§two-cycles-with-named-honest-regret-with-named-aspiration** (337 + 343). The "regret" pattern continues to grow.

**§the-named-existing-entry-point-with-named-aspiration-to-remove** — first-explicit-observation. The package CURRENTLY ships this option but the README explicitly aspires to its REMOVAL. Tier-3 framing: when a package must ship an unsafe option for compatibility reasons, document the regret + aspiration to remove so future maintainers know it's not load-bearing in the design.
