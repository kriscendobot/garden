---
title: §the-named-layered-shim-with-named-addition
source: endo--packages-init-source-cluster
url: https://github.com/endojs/endo/tree/master/packages/init
authors: [Kris Kowal, Endo project (collective)]
repo: endojs/endo
path: packages/init/{index.js,debug.js,unsafe-fast.js,legacy.js,debug-async-hooks.js,pre.js,pre-remoting.js,pre-bundle-source.js}
total-lines: 66
ingest-cycle: 344
ingest-date: 2026-06-15
lane: chat
section-tags:
  - the-named-README-curates-subset-of-implementation-rungs
  - the-named-five-rungs-in-implementation-vs-three-in-README
  - the-named-two-shapes-of-tolerance-ladder-rung
  - the-named-re-export-from-variant-vs-direct-call-with-options
  - the-named-orchestration-via-import-graph
  - the-named-tiny-files-where-the-COMPOSITION-is-the-content
  - the-named-layered-shim-with-named-addition
  - the-named-pre-remoting-adds-eventual-send-to-pre
  - the-named-base64-and-promise-kit-as-canonical-pre-lockdown-shims
  - the-named-export-star-from-named-lockdown-variant
  - the-named-direct-import-and-call-when-custom-options
  - the-named-deprecated-with-named-replacement-in-source
  - the-named-async_hooks-patch-with-named-platform-limitation
  - the-named-doubled-underscores-as-internal-API-marker
  - the-named-complementary-lens-re-ingest
  - seven-cycles-with-named-complementary-lens-re-ingest
  - the-named-streak-resumes-with-twelfth-instance
  - thirty-five-cycles-with-named-pivot-domain-stay
  - one-hundred-five-citation-arc-closures-in-pivot-now
parent: endo--packages-init-source-cluster--seventh-complementary-lens-README-curates-subset-of-implementation-rungs
---

`pre.js` (7 lines):

```js
import '@endo/lockdown';
import '@endo/base64/shim.js';
import '@endo/promise-kit/shim.js';
export * from '@endo/lockdown';
```

`pre-remoting.js` (7 lines):

```js
export * from './pre.js';
export * from '@endo/eventual-send/shim.js';
```

**§the-named-pre-remoting-adds-eventual-send-to-pre** — first-explicit-observation. `pre-remoting.js` is structurally `pre.js + eventual-send-shim`. The layered design: `pre.js` is the basic shim cluster; `pre-remoting.js` extends it with HandledPromise/eventual-send.

**§the-named-layered-shim-with-named-addition** — first-explicit-observation as a tier-3 meta-pattern. The discipline: when a package has variants that differ by adding ONE FEATURE, structure them as layers (`base.js` + `extended.js`) rather than separate independent files.

**§the-named-base64-and-promise-kit-as-canonical-pre-lockdown-shims** — first-explicit-observation. `pre.js` installs THREE pre-lockdown shims: lockdown itself, @endo/base64, @endo/promise-kit. These are the canonical pre-lockdown stack. Cycle 187 named the shim cluster; cycle 344 reveals the exact three-package composition.
