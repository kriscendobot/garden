---
title: §the-named-debug-as-less-safe-but-conducive-to-debugging
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

Lines 18-19:

> The `@endo/init/debug.js` makes a less safe environment which is more conducive to debugging.

**§the-named-debug-as-less-safe-but-conducive-to-debugging** — first-explicit-observation. The README names the TRADEOFF EXPLICITLY: less safety in exchange for better debugging. The phrasing is *non-pejorative* (compare to cycle 337's §the-named-precise-technical-language-without-pejorative-tone).

**§the-named-detailed-rationale-for-each-debug-option** — lines 21-39 detail THREE SES options that debug.js relaxes:

1. **errorTaming** (lines 21-27): default `"safe"` redacts stack traces; tools like Ava look for stacks; debug.js relaxes this
2. **stackFiltering** (lines 29-31): default `"concise"` reduces noise; debug.js may show fuller stacks
3. **overrideTaming** (lines 33-39): default `"moderate"` introduces accessor noise in debugger; debug.js uses `"min"` for less noise

**§the-named-detailed-rationale-for-each-debug-option** — first-explicit-observation as a tier-3 meta-pattern. The discipline: when offering a less-safe variant, document EACH option that differs from default AND name the default behavior AND name when the relaxation might be needed.

Compare to cycle 342's NOTE-TO-REVIEWERS pattern (per-option warnings in source); cycle 343's documentation pattern (per-option rationale in README). **§two-shapes-of-per-option-discipline** (NOTE-TO-REVIEWERS in source + per-option rationale in README).
