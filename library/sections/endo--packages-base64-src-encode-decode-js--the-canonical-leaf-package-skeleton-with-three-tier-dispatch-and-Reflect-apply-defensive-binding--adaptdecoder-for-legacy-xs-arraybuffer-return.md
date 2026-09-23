---
source: packages/base64/src/{encode,decode,common}.js + index.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages/base64
source_path: packages/base64/src/encode.js, packages/base64/src/decode.js, packages/base64/src/common.js, packages/base64/index.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - hardened-javascript
  - tooling
genre: §endo-source-comment-fragment §canonical-leaf-package-pattern
cycle: 181
lane: chat
status: current
title: §adaptDecoder-for-legacy-XS-ArrayBuffer-return
parent: endo--packages-base64-src-encode-decode-js--the-canonical-leaf-package-skeleton-with-three-tier-dispatch-and-Reflect-apply-defensive-binding
---

```js
// The legacy XS `Base64.decode` may return ArrayBuffer (not
// Uint8Array); adapt it.
const adaptDecoder =
  nativeDecoder =>
  (...args) => {
    const decoded = nativeDecoder(...args);
    if (decoded instanceof Uint8Array) {
      return decoded;
    }
    return new Uint8Array(decoded);
  };
```

§Adapter-curried-once: `adaptDecoder` takes a `nativeDecoder`
and returns a wrapper that normalizes the result to
`Uint8Array`.

§Why-needed: older Moddable/XS builds returned `ArrayBuffer`
from `globalThis.Base64.decode`. §The-jsDecodeBase64-polyfill
returns `Uint8Array`. §The-three-tier-dispatch returns one of
{native | xs | js}; §callers-expect-a-Uint8Array-uniformly.

§The-adapter-runs-only-on-the-XS-tier:

```js
const xsDecodeBase64 =
  globalThis.Base64 !== undefined
    ? adaptDecoder(globalThis.Base64.decode)
    : undefined;
```

§Conditional-wrap. §Native-and-JS-tiers-need-no-adaptation
because both return Uint8Array natively. §Defensive-shape-
normalization-at-the-legacy-XS-boundary.

§Cycle-180-hex-has-no-adaptDecoder because it has no legacy XS
tier. §This-is-§another-discipline-the-hex-clone-omits-because-
the-platform-doesn't-need-it.
