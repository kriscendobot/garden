---
title: §the-named-async_hooks-patch-with-named-platform-limitation
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

`debug-async-hooks.js` (12 lines):

```js
// Install async_hooks patches for Node.js debugging in lockdown mode
// This is a specialized entrypoint for debugging scenarios where async_hooks
// compatibility is needed (e.g., for debuggers in older Node.js versions).
// Note: This patch may not work in Node.js 24+.
import './src/node-async_hooks-patch.js';
import './pre-remoting.js';
export * from '@endo/lockdown/commit-debug.js';
```

**§the-named-async_hooks-patch-with-named-platform-limitation** — first-explicit-observation. The file's comment names BOTH:
1. **Purpose**: debugging in older Node.js versions
2. **Limitation**: *"This patch may not work in Node.js 24+"*

The file is built for a SPECIFIC PLATFORM VERSION WINDOW. **§the-named-platform-version-window-named-explicitly** — first-explicit-observation. The discipline: when a feature is tied to a platform version, name the END of the window explicitly so users know when to revisit.
