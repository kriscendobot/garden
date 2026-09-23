---
title: §Mutual-exclusion-noTransforms-and-elideComments
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
if (noTransforms && elideComments) {
  throw new Error(
    'bundleSource endoZipBase64 cannot elideComments with noTransforms',
  );
}
```

§Two-options-are-incompatible — §named-explicitly-at-the-validation-gate. §The-error-message-names-both-options-and-the-format.

§Borrowable-pattern: §when-two-options-are-mutually-exclusive, §reject-at-the-validation-gate-with-an-error-message-naming-both-options. §Don't-silently-prefer-one — §fail-loud + §tell-the-user-which-two-they-set + §let-them-decide-which-one-they-meant.
