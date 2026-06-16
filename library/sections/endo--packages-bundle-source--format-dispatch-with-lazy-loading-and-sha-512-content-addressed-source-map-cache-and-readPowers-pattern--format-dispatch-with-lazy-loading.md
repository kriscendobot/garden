---
title: §Format-dispatch-with-lazy-loading
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

```js
switch (moduleFormat) {
  case 'endoZipBase64': {
    const { bundleZipBase64 } = await import('./zip-base64.js');
    return bundleZipBase64(startFilename, bundleOptions, powers);
  }
  case 'getExport':
  case 'nestedEvaluate':
  case 'endoScript': {
    const { bundleScript } = await import('./script.js');
    return bundleScript(startFilename, moduleFormat, bundleOptions, powers);
  }
  // ...
}
```

§Dynamic-import-per-format — the implementation modules are not loaded until the format is requested. §Two-named-implementation-modules ({./zip-base64.js, ./script.js}). §Three-formats-collapse-to-one-module (the three script forms all dispatch to bundleScript with the format passed through).

§Borrowable-pattern: §lazy-load-the-format-specific-implementation. §A-caller-that-only-uses-endoZipBase64-doesn't-pay-the-cost-of-loading-script.js (which would transitively load Babel via parsers). §Cost-paid-only-when-the-format-is-used.

§Sibling to cycle 200 worker-rust-xs (different mechanism, same §pay-only-for-what-you-use principle) and cycle 211 @endo/common (§tree-shaking-friendly via one-file-per-export).
