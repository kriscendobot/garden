---
title: §the-named-license-header-as-most-of-the-file
source: endo--packages-ses-entry-cluster
url: https://github.com/endojs/endo/tree/master/packages/ses
authors: [Mark S. Miller, Kris Kowal, Endo project (collective)]
repo: endojs/endo
path: packages/ses/{index.js,lockdown.js,lockdown-shim.js,compartment-shim.js,console-shim.js,assert-shim.js}
total-lines: 23
ingest-cycle: 346
ingest-date: 2026-06-15
lane: chat
section-tags:
  - the-named-single-line-forwarder-as-stability-barrier
  - the-named-stable-URL-surface-via-thin-forwarder
  - the-named-two-modes-of-package-installation
  - the-named-all-or-nothing-vs-a-la-carte-install
  - the-named-index-js-aggregates-all-shims
  - the-named-individual-shim-files-allow-partial-installation
  - the-named-two-shapes-of-tiny-files-orchestration
  - the-named-rung-as-entry-point-vs-stability-via-thin-forwarder
  - the-named-license-header-as-most-of-the-file
  - the-named-six-tiny-files-with-license-header-dominating
  - the-named-streak-resumes-with-thirteenth-instance
  - the-named-complementary-lens-re-ingest
  - eight-cycles-with-named-complementary-lens-re-ingest
  - thirty-seven-cycles-with-named-pivot-domain-stay
  - one-hundred-twenty-citation-arc-closures-in-pivot-now
parent: endo--packages-ses-entry-cluster--thirteenth-one-cycle-pair-single-line-forwarder-as-stability-barrier-and-two-modes-of-package-installation
---

`index.js` is 18 lines total but **14 of those lines are the Apache 2.0 license header**. Only 4 lines are actual code (the imports).

**§the-named-license-header-as-most-of-the-file** — first-explicit-observation. The ratio of license-header to code in this file is 14:4 ≈ 3.5:1. For files this small, the license header dominates.

**§the-named-six-tiny-files-with-license-header-dominating** — first-explicit-observation. Across the six files:
- 5 one-line files = 5 lines of code, 0 license headers (license inherited from package LICENSE file)
- 1 eighteen-line file (index.js) = 4 lines of code + 14 lines of license header

Total: 9 lines of code + 14 lines of license header = 23 lines.

**§the-named-license-header-only-on-aggregator** — first-explicit-observation. Only `index.js` carries the license header; the individual forwarder files (`lockdown.js`, `compartment-shim.js`, etc.) do not. The discipline: when a cluster has one canonical aggregator, put the license header on that file; the individual forwarders are trivial enough to inherit.
