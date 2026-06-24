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
title: §Two-file-symmetric-pair (the spine)
parent: endo--packages-check-bundle-js--powered-and-powerless-symmetric-pair-with-frozen-bundle-assertion-and-design-boundary-migration
---

```js
// index.js (powered)
import * as fs from 'fs';
import * as crypto from 'crypto';
import { checkBundle as powerlessCheckBundle } from './lite.js';

const computeSha512 = bytes => {
  const hash = crypto.createHash('sha512');
  hash.update(bytes);
  return encodeHex(hash.digest());
};

export const checkBundle = async (bundle, name = '<unknown-bundle>') => {
  return powerlessCheckBundle(bundle, computeSha512, name);
};
```

```js
// lite.js (powerless)
export const checkBundle = async (
  bundle,
  computeSha512,
  bundleName = '<unknown-bundle>',
) => { ... };
```

§Powered-checkBundle = §powerless-checkBundle + §computeSha512-
factory. §The-power (crypto + fs) flows into the powerless
core via §explicit-parameter-injection.

§Why-this-pattern-matters:

- `@endo/check-bundle/lite.js` runs in §any-SES-realm because
  it has no `fs` or `crypto` imports.
- `@endo/check-bundle/index.js` is §node-only because it
  depends on `node:fs` and `node:crypto`.
- A browser-side consumer can §import-lite-and-provide-its-
  own-WebCrypto-based-`computeSha512`.
- An Agoric-XS-side consumer can §import-lite-and-provide-its-
  own-XS-native-hash.

§Compare-to-cycle-183-@endo/init's-§tolerance-ladder (index <
debug < legacy < unsafe-fast). §Different-axis: cycle 183
ladders along §strictness; cycle 185 ladders along §powered-
ness.

§Compare-to-cycle-181-base64's-§three-tier-dispatch (native →
legacy XS → JS). §Different-mechanism: base64 dispatches
internally at module-load; check-bundle separates externally
into two files (powerless core vs powered shim).
