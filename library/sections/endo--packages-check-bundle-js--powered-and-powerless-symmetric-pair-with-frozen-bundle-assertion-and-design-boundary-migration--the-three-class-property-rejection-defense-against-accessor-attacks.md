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
title: §The-three-class-property-rejection (defense against accessor attacks)
parent: endo--packages-check-bundle-js--powered-and-powerless-symmetric-pair-with-frozen-bundle-assertion-and-design-boundary-migration
---

```js
const properties = Object.entries(Object.getOwnPropertyDescriptors(bundle));
const nonValues = properties.filter(
  ([, property]) => typeof property.get === 'function',
);
const nonStrings = properties.filter(
  ([, property]) => typeof property.value !== 'string',
);
(nonValues.length === 0 && nonStrings.length === 0) ||
  Fail`checkBundle cannot vouch for the ongoing integrity of a bundle ${q(
    bundleName,
  )} with getter properties (has ${nonValues.map(
    ([name]) => name,
  )}) or non-string value properties (has ${nonStrings.map(
    ([name]) => name,
  )})`;
```

§Two-defensive-checks: §nonValues (getter properties) +
§nonStrings (non-string values). §A-bundle-must-be-a-frozen-
record-of-strings — nothing else.

§Why-getters-are-rejected: even on a frozen object, a getter
function could return different values across calls. §A-getter-
defeats-the-frozen-vouch.

§Why-non-string-values-are-rejected: the bundle protocol
specifies string-valued fields (`moduleFormat` / `endoZipBase64`
/ `endoZipBase64Sha512`). §Non-string-values-indicate-tampering-
or-format-error.

§The-error-message names the offending property names via
`.map(([name]) => name)`. §Diagnostic-discipline names the
specific properties at fault, not just "has nonValues."

§Compare-to-cycle-178-daemon-xs-worker-snapshot's §append-only-
callback-table. §Both-are-§structural-defenses-against-mutation-
or-replacement-attacks; both rely on the §frozen-state of the
substrate.

§Compare-to-cycle-87-pass-style/safe-promise.js' §safe-promise-
predicate: both filter for §shape-conformance-as-precondition.
