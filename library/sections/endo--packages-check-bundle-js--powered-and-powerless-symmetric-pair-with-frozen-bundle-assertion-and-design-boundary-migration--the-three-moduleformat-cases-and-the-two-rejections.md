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
title: §The-three-moduleFormat-cases (and the two rejections)
parent: endo--packages-check-bundle-js--powered-and-powerless-symmetric-pair-with-frozen-bundle-assertion-and-design-boundary-migration
---

```js
if (moduleFormat === 'endoZipBase64') {
  // ... extract bytes, parseArchive, verify sha512
} else if (
  moduleFormat === 'getExport' ||
  moduleFormat === 'nestedEvaluate'
) {
  Fail`checkBundle cannot determine hash of bundle with ${q(
    moduleFormat,
  )} moduleFormat because it is not necessarily consistent`;
} else {
  Fail`checkBundle cannot determine hash of bundle with unrecognized moduleFormat ${q(
    moduleFormat,
  )}`;
}
```

§Three-cases: §accept-endoZipBase64 + §reject-getExport-and-
nestedEvaluate-with-named-reason + §reject-unknown-with-named-
reason.

§Why-getExport-and-nestedEvaluate-are-rejected: "it is not
necessarily consistent." §The-design-decision-named-explicitly:
those module formats produce JavaScript-source bundles whose
hash depends on subtle textual choices (whitespace, source-map
encoding, ordering of properties), so the hash is §unstable-
across-toolchain-versions.

§endoZipBase64 is the §hash-stable-format: a zip archive of
modules + manifest, encoded as base64, whose sha512 covers the
zip bytes. §Stable-across-toolchain-versions because zip
ordering and zip header conventions are canonical.

§Compare-to-cycle-174-gateway-package's §three-design-lifecycle-
statuses-now-distinguished. §Both-are-§explicit-discrimination-
of-cases-each-with-named-rationale.
