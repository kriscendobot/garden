---
title: §the-named-deprecated-with-named-replacement-in-source
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

`pre-bundle-source.js` (8 lines):

```js
// pre-bundle-source.js - initialization to use @endo/bundle-source
// DEPRECATED: no longer necessary, imports of this module can be replaced with
//   import '@endo/init';
// or if further vetted shim initialization is needed:
//   import '@endo/init/pre.js';

// eslint-disable-next-line import/export
export * from './pre.js';
```

**§the-named-deprecated-with-named-replacement-in-source** — first-explicit-observation. The file is DEPRECATED with the migration path NAMED INLINE: *"imports of this module can be replaced with `import '@endo/init';`"*. Two named alternatives are provided: simple (`@endo/init`) AND advanced (`@endo/init/pre.js`).

Compare to:
- Cycle 326 @endo/patterns/index.js: @deprecated tags with canonical pointers
- Cycle 337 @endo/harden's isFake-deprecated-with-named-regret
- Cycle 343 @endo/init's unsafe-fast-with-aspiration-to-remove
- **Cycle 344's pre-bundle-source.js: file-header DEPRECATED comment with TWO named replacements**

**§five-shapes-of-deprecation-discipline** — first-explicit-observation as a tier-3 meta-pattern:

| Shape | Cycle | Example |
|---|---|---|
| @deprecated tag with canonical pointer | 326 | Patterns/index.js re-exports |
| Deprecated with named regret | 337 | Harden isFake |
| Deprecated with named aspiration to remove | 343 | Init unsafe-fast |
| Deprecated with named replacement in source | 344 | Init pre-bundle-source |
| Deprecated with forwarding-comment to alternative | 211 | @endo/common ident-checker |

Five named shapes; deprecation discipline at five different levels.
