---
title: §the-named-two-modes-of-package-installation
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

The SES entry-point cluster supports TWO modes:

**Mode 1: All-or-nothing** — consumer imports `ses`:
```js
import 'ses';
// Resolves to lockdown.js → index.js → all four shims installed
```

**Mode 2: À la carte** — consumer imports individual shims:
```js
import 'ses/compartment-shim.js';  // only compartment
import 'ses/console-shim.js';      // only console
import 'ses/assert-shim.js';       // only assert
```

**§the-named-two-modes-of-package-installation** — first-explicit-observation as a tier-3 meta-pattern. The discipline: when a package has multiple installable components, expose:
1. An aggregator entry point (default `import 'X';`) that installs everything
2. Individual sub-paths (`import 'X/component.js';`) that install only one thing

**§the-named-all-or-nothing-vs-a-la-carte-install** — first-explicit-observation. The aggregator is for users who want the package as a unit; the individual sub-paths are for users who want fine-grained control. Both modes coexist.

**§the-named-index-js-aggregates-all-shims** — first-explicit-observation. The 18-line `index.js` is the aggregator:

```js
import './src/lockdown-shim.js';
import './src/compartment-shim.js';
import './src/assert-shim.js';
import './src/console-shim.js';
```

Four imports installs everything. **§the-named-individual-shim-files-allow-partial-installation** — first-explicit-observation. Each top-level file is also a single-line forwarder, making individual shims importable.
