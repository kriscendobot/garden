---
title: The single most structurally interesting move
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

**§the-named-enumeration-of-side-effects-as-package-purpose** — lines 3-7:

> Importing `@endo/init` sets up an Endo JavaScript realm.
> This includes setting up HardenedJS, including locking it down,
> sets the realm up for [Eventual Send](../eventual-send),
> ensures that `atob` and `btoa` are present, and ensures that promises can be
> hardened regardless of the platform.

**§the-named-enumeration-of-side-effects-as-package-purpose** — first-explicit-observation as a tier-3 meta-pattern. The README enumerates **FIVE specific actions** the package performs on import:

| # | Action | Detail |
|---|---|---|
| 1 | Sets up HardenedJS | Including locking it down |
| 2 | Sets up Eventual Send | Linked to ../eventual-send |
| 3 | Ensures atob present | Cross-platform base64 |
| 4 | Ensures btoa present | Cross-platform base64 |
| 5 | Ensures promises can be hardened | Regardless of platform |

**§the-named-five-named-actions-performed-on-import** — first-explicit-observation. Compare to cycle 341's @endo/lockdown which named ONE action (*"simply ensures that SES has both initialized and locked down"*). Cycle 343's @endo/init enumerates FIVE; the package is a higher-level aggregator.

**§the-named-side-effect-only-package-with-enumerated-side-effects** — first-explicit-observation as a tier-3 meta-pattern. Cycle 341 named §the-named-side-effect-only-package (the import IS the contract); cycle 343 reveals a refinement: side-effect-only packages SHOULD enumerate their side effects in the README. Tier-3 framing: the README's enumeration is the *contract* for what the import accomplishes.

**§three-cycles-with-named-side-effect-only-package** (cycle 187 shim cluster + cycle 341 lockdown + cycle 343 init) — first-explicit-observation as a tier-2 multi-cycle pattern. The discipline crosses three pivot cycles.
