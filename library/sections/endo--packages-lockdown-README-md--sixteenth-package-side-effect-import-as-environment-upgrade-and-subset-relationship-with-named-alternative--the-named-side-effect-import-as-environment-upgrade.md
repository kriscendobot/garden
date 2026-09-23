---
title: §the-named-side-effect-import-as-environment-upgrade
source: endo--packages-lockdown-README-md
url: https://github.com/endojs/endo/blob/master/packages/lockdown/README.md
authors: [Kris Kowal, Endo project (collective)]
repo: endojs/endo
path: packages/lockdown/README.md
total-lines: 15
ingest-cycle: 341
ingest-date: 2026-06-15
lane: designs
section-tags:
  - the-named-side-effect-import-as-environment-upgrade
  - the-named-import-order-as-temporal-discipline
  - the-named-subset-relationship-named-with-named-alternative
  - the-named-pointer-to-related-package-with-named-relationship
  - the-named-coordinate-with-SES-via-import
  - the-named-package-purpose-as-coordination-with-named-other-package
  - the-named-simply-ensures-language
  - the-named-side-effect-only-package
  - the-named-fifteen-line-policy-minimal-README
  - the-named-sixteenth-package-in-the-pivot-cluster
  - the-named-streak-of-zero-cross-package
  - three-cycles-with-named-package-coordinates-with-named-other-package
  - thirty-two-cycles-with-named-pivot-domain-stay
  - eighty-two-citation-arc-closures-in-pivot-now
  - four-cycles-with-named-substrate-package-introduction
parent: endo--packages-lockdown-README-md--sixteenth-package-side-effect-import-as-environment-upgrade-and-subset-relationship-with-named-alternative
---

Lines 3-7 open with the package's purpose statement:

> We often need to upgrade a JavaScript environment to HardenedJS as a side effect of importing a module, so that later modules can rely on the hardened environment.
> The `@endo/lockdown` package simply ensures that SES has both initialized and locked down the environment.

**§the-named-side-effect-import-as-environment-upgrade** — first-explicit-observation as a tier-3 meta-pattern. The README's framing:

1. **Names the need**: *"We often need to upgrade a JavaScript environment"*
2. **Names the mechanism**: *"as a side effect of importing a module"*
3. **Names the goal**: *"so that later modules can rely on the hardened environment"*
4. **Names the package's job**: *"simply ensures that SES has both initialized and locked down"*

The phrase *"as a side effect of importing"* names a specific discipline: the import statement DOES SOMETHING beyond just providing bindings. The discipline is named in cycle 187's *"§unconditional-replacement"* and cycle 337's *"§prepare-star-convention"*; cycle 341 names it as the **package-purpose level**.

**§the-named-side-effect-only-package** — first-explicit-observation. A package whose entire job is to BE imported (no exports needed; the imports's side effects ARE the value). The package import is the contract. Compare to cycle 340's §the-named-types-only-file (no runtime; pure type-level); §the-named-side-effect-only-package is the inverse — no exports; pure runtime side-effect.

**§two-shapes-of-export-less-package** (types-only cycle 340 + side-effect-only cycle 341) — first-explicit-observation as a tier-3 meta-pattern. Both shapes have ZERO runtime exports; they differ in WHAT they contribute:
- Types-only: contributes JSDoc typedefs to the type-checker
- Side-effect-only: contributes runtime behavior via import-time evaluation

**§the-named-simply-ensures-language** — first-explicit-observation. The word *"simply"* in line 6 is a discipline-marker — the README's own framing is that the package is **intentionally minimal**. Compare to cycle 339's *"the package provides utilities for X"* (one-sentence purpose); cycle 341's *"simply ensures"* makes the minimalism explicit.
