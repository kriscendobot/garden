---
title: §the-named-cross-package-compensation-named
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

Lines 25-27:

> The `@endo/ses-ava` package compensates for the case of Ava specifically, but `@endo/init/debug.js` may be necessary for other tools.

**§the-named-cross-package-compensation-named** — first-explicit-observation as a tier-3 meta-pattern. The README names a SPECIFIC OTHER PACKAGE (@endo/ses-ava) that handles a SPECIFIC USE CASE (Ava testing). The discipline: when a specific debugging tool has known compatibility issues, ANOTHER PACKAGE provides the compensation; the README points to it.

**§the-named-ses-ava-compensates-for-Ava-specifically** — first-explicit-observation. Cycle 187 ingested @endo/ses-ava as part of the shim-and-prepare cluster; cycle 343 reveals the README-level explanation of WHY ses-ava exists: it's a *compensation* mechanism for a specific test framework.

**§the-named-cross-package-compensation-mechanism** — first-explicit-observation as a tier-3 meta-pattern. When a package's defaults conflict with a tool's expectations, the architectural solution is a *compensation package* rather than weakening the defaults. The compensation is scoped to ONE consumer (Ava), keeping the defaults strict.

Compare to cycle 187's §two-shim-strategies (conditional + unconditional); cycle 343's compensation is a third strategy: *cross-package compensation*. **§three-shapes-of-compatibility-strategy** (conditional-install + unconditional-replacement + cross-package-compensation). First-explicit-observation as a tier-3 meta-pattern.
