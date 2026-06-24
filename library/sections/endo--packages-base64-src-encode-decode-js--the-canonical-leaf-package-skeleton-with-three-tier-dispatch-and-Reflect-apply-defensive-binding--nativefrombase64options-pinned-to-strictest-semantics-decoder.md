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
title: §nativeFromBase64Options-pinned-to-strictest-semantics (decoder)
parent: endo--packages-base64-src-encode-decode-js--the-canonical-leaf-package-skeleton-with-three-tier-dispatch-and-Reflect-apply-defensive-binding
---

```js
const nativeFromBase64Options = Object.freeze({
  lastChunkHandling: 'strict',
  alphabet: 'base64',
});
```

§Two-options-pinned:

- **`lastChunkHandling: 'strict'`** — rejects unpadded / short
  final chunks. §Comment: "The proposal default `'loose'` would
  silently accept them."
- **`alphabet: 'base64'`** — rejects URL-safe characters (`-_`).
  §Comment: "pins forward compatibility against any future spec
  drift."

§Strict-by-default-discipline. §The-jsDecodeBase64-polyfill
implements RFC 4648 § 4 base64 strictly; the native-dispatch
options pin the same strictness so the two paths agree on which
inputs are valid.

§The-options-object-is-Object.frozen — the dispatched native
call cannot accidentally observe a mutated options bag.

§Cycle-180-hex-has-no-options-bag (TC39 `Uint8Array.fromHex` is
case-insensitive and the encoder is fixed-lowercase); §the-
options-pinning-discipline-does-not-port-to-hex because there's
no equivalent option to pin. §This-is-a-§clean-clone-because-
the-platform-already-pinned-the-semantics.
