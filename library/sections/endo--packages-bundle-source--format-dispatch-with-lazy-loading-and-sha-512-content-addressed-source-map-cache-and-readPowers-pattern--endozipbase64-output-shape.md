---
title: §endoZipBase64-output-shape
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
return harden({
  moduleFormat: 'endoZipBase64',
  endoZipBase64,
  endoZipBase64Sha512: sha512,
});
```

§Three-named-fields:
1. §moduleFormat as the §discriminator-tag (the consumer dispatches on this).
2. §endoZipBase64 as the §content-string (base64-encoded zip).
3. §endoZipBase64Sha512 as the §integrity-hash for the unencoded bytes.

§Borrowable-pattern: §discriminator-tag + §content + §integrity-hash as the canonical bundle-output shape. §Sibling to cycle 200's §root-hash-printed-to-stderr (different layer, same §integrity-anchor discipline).

§Harden-the-output discipline.
