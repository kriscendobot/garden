---
title: The single most structurally interesting move
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

**§the-named-single-line-forwarder-as-stability-barrier** — each top-level file (except index.js) is **one line**:

```js
import './src/lockdown-shim.js';
```

The top-level `lockdown-shim.js`, `compartment-shim.js`, `console-shim.js`, `assert-shim.js` are each a single-line forward to `./src/`. The file system structure creates a **stable API surface**; the `src/` implementation can move without breaking importers.

**§the-named-single-line-forwarder-as-stability-barrier** — first-explicit-observation as a tier-3 meta-pattern. The discipline: when a package wants to **decouple its public API URL** from its internal implementation, use **single-line forwarder files** at the top level. Consumers import `ses/compartment-shim.js`; the file system resolves to the top-level forwarder; the top-level forwarder re-imports from `src/`. If `src/compartment-shim.js` is later moved to `src/compartment/index.js` or `lib/compartment-shim.js`, only the top-level forwarder changes; consumers are unaffected.

**§the-named-stable-URL-surface-via-thin-forwarder** — first-explicit-observation. This is HOW cycle 342 @endo/lockdown's `import 'ses';` works — the import resolves to the top-level `lockdown.js` (which itself forwards to `index.js` which loads the four shims).

Compare to:
- Cycle 344 @endo/init's tiny files: rung-as-entry-point (each tiny file = a config variant)
- **Cycle 346 @endo/ses's tiny files: stability-via-thin-forwarder (each tiny file = stable URL for an internal module)**

**§the-named-rung-as-entry-point-vs-stability-via-thin-forwarder** — first-explicit-observation as a tier-3 meta-pattern. Two-shapes of tiny-file orchestration:

| Shape | Purpose | Example |
|---|---|---|
| Rung-as-entry-point | Each tiny file = a different config variant | Cycle 344 @endo/init |
| Stability-via-thin-forwarder | Each tiny file = stable URL for an internal module | Cycle 346 @endo/ses |

**§two-shapes-of-tiny-files-orchestration** — first-explicit-observation. Both ARE orchestration-via-import-graph (cycle 344's tier-3 meta-pattern) but with different orchestration purposes.
