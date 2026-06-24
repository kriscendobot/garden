---
title: §The-shared-options-shape across formats
source-slug: endo--packages-bundle-source
section-id: format-dispatch-with-lazy-loading-and-sha-512-content-addressed-source-map-cache-and-readPowers-pattern
url: https://github.com/endojs/endo/tree/master/packages/bundle-source
authors: [Endo contributors]
repo: endojs/endo
path: packages/bundle-source/src/{bundle-source.js,zip-base64.js,script.js,endo.js,fs.js,main.js,is-entrypoint.js,tool.js,index.js}
status: shipping
ingest-cycle: 221
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-bundle-source--format-dispatch-with-lazy-loading-and-sha-512-content-addressed-source-map-cache-and-readPowers-pattern
---

Both `bundleZipBase64` and `bundleScript` accept §the-same-six-named-options:

```js
const {
  dev = false,
  cacheSourceMaps = false,
  noTransforms = false,
  elideComments = false,
  conditions = [],
  commonDependencies,
} = options;
```

§Six-named-defaults — §dev (allow devDependencies) + §cacheSourceMaps (write source maps to cache) + §noTransforms (skip code transforms) + §elideComments (strip comments) + §conditions (package.json export conditions) + §commonDependencies (deduplicate shared dependencies).

§Borrowable-pattern: §shared-options-shape-across-multiple-public-entry-points (zipBase64 + script). §The-options-typedef-is-the-bridge-between-callers-and-the-six-feature-knobs.
