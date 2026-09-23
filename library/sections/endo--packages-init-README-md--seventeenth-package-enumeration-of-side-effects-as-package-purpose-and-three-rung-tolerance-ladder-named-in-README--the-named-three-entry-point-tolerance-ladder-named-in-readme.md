---
title: §the-named-three-entry-point-tolerance-ladder-named-in-README
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

The README documents THREE entry points:

| Entry point | Section | Safety vs debugging tradeoff |
|---|---|---|
| `@endo/init` | Lines 1-15 | Default; fully locked down |
| `@endo/init/debug.js` | Lines 18-43 | Less safe; conducive to debugging |
| `@endo/init/unsafe-fast.js` | Lines 47-52 | Extreme measure; avoid; "we hope to obviate" |

**§the-named-three-entry-point-tolerance-ladder-named-in-README** — first-explicit-observation. Cycle 183 named §tolerance-ladder-via-separate-entry-point-files at the SOURCE-level (observing the file structure); cycle 343 reveals the README's articulation: each rung named, with its own section explaining purpose and tradeoff.

**§the-named-hr-separator-as-section-divider** — first-explicit-observation. Lines 16 and 45 use Markdown `---` horizontal rules to separate the three entry-point discussions. The HR is a visual structural marker, not a header.

**§the-named-three-rung-ladder-default-debug-unsafe-fast** — first-explicit-observation. The three rungs correspond to three safety/performance choices:
- Default (rung 1): maximum safety
- Debug (rung 2): reduced safety, increased visibility into errors
- Unsafe-fast (rung 3): minimal safety, maximum performance

**§three-shapes-of-safety-vs-performance-tradeoff-exposure** — first-explicit-observation as a tier-3 meta-pattern:

| Cycle | Package | Shape |
|---|---|---|
| 183 | @endo/init source | Separate entry-point files (file-system as policy boundary) |
| 337 | @endo/harden README | Build conditions (`-C hardened`, `-C harden:unsafe`) |
| **343** | **@endo/init README** | **Documented entry-point ladder with named rationale per rung** |

Compare to cycle 342's NOTE-TO-REVIEWERS as merge-defense (source-level honesty about commented-out options) — that's a fourth shape but at a different *level* (per-option vs per-package).
