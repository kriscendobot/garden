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
title: §Three-tier-dispatch (the spine)
parent: endo--packages-base64-src-encode-decode-js--the-canonical-leaf-package-skeleton-with-three-tier-dispatch-and-Reflect-apply-defensive-binding
---

```js
export const encodeBase64 = (() => {
  if (nativeToBase64 !== undefined) return nativeEncodeBase64;
  if (xsEncodeBase64 !== undefined) return xsEncodeBase64;
  return jsEncodeBase64;
})();
Object.freeze(encodeBase64);
```

§Three-tier-priority-IIFE-bound-at-module-load:

1. **§Tier-1 — TC39 native** (`Uint8Array.prototype.toBase64`)
   when present.
2. **§Tier-2 — legacy XS native** (`globalThis.Base64.encode`)
   from older Moddable/XS builds (Agoric chain).
3. **§Tier-3 — pure-JS fallback** (`jsEncodeBase64`).

§The-IIFE-returns-the-chosen-implementation-bound-to-a-const.
§Module-load-time-decision. §No-runtime-branching-per-call.
§Compare-to-cycle-180-hex-package-design's-§two-tier-dispatch
(only native + JS); hex omits the §legacy-XS-tier because no
legacy XS hex binding exists.

§The-decoder-mirrors-the-encoder's-three-tier-structure:

```js
export const decodeBase64 = (() => {
  if (nativeFromBase64 !== undefined) return nativeDecodeBase64;
  if (xsDecodeBase64 !== undefined) return xsDecodeBase64;
  return jsDecodeBase64;
})();
Object.freeze(decodeBase64);
```

§Symmetric-pattern. §IIFE-returns-bound-const. §Object.freeze-
on-the-final-export.
