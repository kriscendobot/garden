---
title: §Four-named-output-module-formats
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
export const DEFAULT_MODULE_FORMAT = 'endoZipBase64';
export const SUPPORTED_FORMATS = [
  'getExport',        // legacy script form
  'nestedEvaluate',   // legacy script form with nested compartments
  'endoZipBase64',    // canonical archive form (zip + base64)
  'endoScript',       // single-script form
];
```

§Two-categories: §archive-form (endoZipBase64) + §three-script-forms (the rest). §The-default-is-endoZipBase64; §the-other-three-are-explicitly-named-as-legacy-or-script-shapes.

§Borrowable-pattern: §default-format-named-as-a-constant + §SUPPORTED_FORMATS-as-allow-list + §dispatch-switch-checks-SUPPORTED_FORMATS-in-the-default-case-to-distinguish-not-supported-from-not-implemented:

```js
default:
  if (!SUPPORTED_FORMATS.includes(moduleFormat)) {
    throw Error(`moduleFormat ${moduleFormat} is not supported`);
  }
  throw Error(
    `moduleFormat ${moduleFormat} is not implemented but is in ${SUPPORTED_FORMATS}`,
  );
```

§Two-distinct-error-messages-for-two-distinct-failure-modes:
1. §Not-supported (caller asked for something not in the list).
2. §Listed-but-not-implemented (caller asked for something promised but not delivered).

§Borrowable-pattern: §distinguish-not-supported-from-not-implemented-with-different-error-messages. §This-is-rare-and-honest: most libraries collapse both into one error; this design surfaces the §promised-but-missing case as a distinct bug.
