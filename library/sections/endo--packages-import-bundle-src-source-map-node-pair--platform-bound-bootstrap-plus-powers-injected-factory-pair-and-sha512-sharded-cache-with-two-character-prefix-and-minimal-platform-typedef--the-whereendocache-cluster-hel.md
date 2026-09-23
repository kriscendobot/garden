---
title: §The whereEndoCache cluster helper — nested powers injection
source-slug: endo--packages-import-bundle-src-source-map-node-pair
section-slug: platform-bound-bootstrap-plus-powers-injected-factory-pair-and-sha512-sharded-cache-with-two-character-prefix-and-minimal-platform-typedef
source-url: https://github.com/endojs/endo/blob/master/packages/import-bundle/src/source-map-node.js
source-repo: endojs/endo
source-path: packages/import-bundle/src/source-map-node.js + source-map-node-powers.js
source-author: Endo project (collective)
total-lines: 45 (10 + 35)
ingest-cycle: 276
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-import-bundle-src-source-map-node-pair--platform-bound-bootstrap-plus-powers-injected-factory-pair-and-sha512-sharded-cache-with-two-character-prefix-and-minimal-platform-typedef
---

Line 19-20:
```js
const cacheDirectory = whereEndoCache(process.platform, process.env, {
  home,
});
```

§The-`whereEndoCache`-call-takes-its-own-powers-triple: §platform + §env + §`{home}`-object. §the-pattern-IS-nested-powers-injection — the factory accepts powers; then passes them onward to a cluster helper that takes its own powers.

§First-explicit-observation in library: **§nested-powers-injection-as-named-discipline — §a-powers-injected-factory-may-pass-its-powers-onward-to-other-powers-injected-functions + §each-layer-IS-explicit-about-what-it-needs + §no-implicit-platform-access-anywhere-in-the-chain**.

§Sibling-pattern to capability-systems' chain-of-authority discipline; §the-authority-flows-from-the-thin-Node-bootstrap-down-through-the-factory-into-the-cluster-helper-with-no-ambient-access-at-any-layer.

§The-`{home}`-object-as-third-argument — §named-object-destructure with one field; §sibling-pattern to many "options" arguments in JS APIs; §the-API-allows-future-extension by adding more fields to the options object without changing the function signature.
