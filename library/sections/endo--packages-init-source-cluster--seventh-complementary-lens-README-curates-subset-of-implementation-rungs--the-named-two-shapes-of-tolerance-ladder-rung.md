---
title: §the-named-two-shapes-of-tolerance-ladder-rung
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

The five rungs split into TWO structural shapes:

**Shape 1: Re-export-from-variant** (index.js + debug.js + debug-async-hooks.js):

```js
import './pre-remoting.js';
export * from '@endo/lockdown/commit.js';     // or commit-debug.js
```

No options passed; the lockdown VARIANT is chosen by which file is re-exported. The lockdown configuration lives in the @endo/lockdown package; @endo/init just CHOOSES the variant.

**Shape 2: Direct-call-with-options** (unsafe-fast.js + legacy.js):

```js
import { lockdown } from '@endo/lockdown';
import './pre-remoting.js';

const options = { __hardenTaming__: 'unsafe' };  // or { overrideTaming: 'severe', ... }
lockdown(options);
```

Imports the function and calls with explicit options.

**§the-named-two-shapes-of-tolerance-ladder-rung** — first-explicit-observation as a tier-3 meta-pattern. The discipline:
- Use **re-export-from-variant** when the safety/debugging tradeoff is encoded in the lockdown variant package
- Use **direct-call-with-options** when the variant is NOT pre-configured (legacy.js) OR when an unusual option is needed (unsafe-fast.js's `__hardenTaming__`)

**§the-named-re-export-from-variant-vs-direct-call-with-options** — first-explicit-observation. Compare to cycle 342's §the-named-re-export-then-overwrite-pattern (in lockdown/pre.js); cycle 344's pattern is the *consumer-side* of cycle 342's wrapper.

**§three-shapes-of-tolerance-ladder-implementation** — first-explicit-observation:

| Shape | Cycle | Location |
|---|---|---|
| Separate entry-point files | 183 | File system as policy boundary |
| Re-export-from-variant | 344 | Encoded in `@endo/lockdown/commit*.js` choice |
| Direct-call-with-options | 344 | Options bag passed to `lockdown()` |

The cycle 183 + 343 + 344 trilogy now names the full architecture of tolerance ladders.
