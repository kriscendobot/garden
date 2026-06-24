---
source: packages/check-bundle/{index,lite,src/json}.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages/check-bundle
source_path: packages/check-bundle/index.js, packages/check-bundle/lite.js, packages/check-bundle/src/json.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - capability-security
  - bundles
  - hardened-javascript
genre: §endo-source-comment-fragment §canonical-powered-powerless-pair
cycle: 185
lane: chat
status: current
title: §`parseArchive` integration (the hash-of-hashes verification)
parent: endo--packages-check-bundle-js--powered-and-powerless-symmetric-pair-with-frozen-bundle-assertion-and-design-boundary-migration
---

```js
const bytes = decodeBase64(endoZipBase64);
const { sha512: parsedSha512 } = await parseArchive(bytes, bundleName, {
  computeSha512,
  expectedSha512: endoZipBase64Sha512,
});
assert(parsedSha512 !== undefined);
```

§Three-step-verification:

1. `decodeBase64(endoZipBase64)` produces the zip bytes.
2. `parseArchive` from `@endo/compartment-mapper/import-archive.js`
   reads the zip, verifies the manifest, **and computes the
   sha512 of the bytes**.
3. The `expectedSha512: endoZipBase64Sha512` parameter tells
   parseArchive what hash to verify against; if it doesn't
   match, parseArchive throws.

§The-`assert(parsedSha512 !== undefined)` is §belt-and-
suspenders: parseArchive should only return undefined if it
didn't compute the hash, which only happens when neither
`computeSha512` nor `expectedSha512` is provided — but both
are provided here, so the assert defends against future
parseArchive changes.

§Compare-to-cycle-181-base64's §safety-net (propagate native
error if polyfill doesn't also throw). §Both-are-§belt-and-
suspenders-against-future-implementation-drift.

§Cycle-181-base64's-§decodeBase64 is called here for the
`endoZipBase64` field. §Direct-dependency-chain: check-bundle
→ base64 → (potentially) native TC39.
