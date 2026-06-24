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
title: §Native-intrinsic-captured-once-at-module-load
parent: endo--packages-base64-src-encode-decode-js--the-canonical-leaf-package-skeleton-with-three-tier-dispatch-and-Reflect-apply-defensive-binding
---

```js
// Capture the native TC39 `Uint8Array.prototype.toBase64` intrinsic at
// module load, before any caller can reach `encodeBase64` and before
// SES lockdown freezes the prototype.
// Post-lockdown mutation cannot redirect the dispatched binding.
const nativeToBase64 = /** @type {any} */ (Uint8Array.prototype).toBase64;
```

§The-comment-names-three-properties-of-the-discipline:

1. **§Before-any-caller-can-reach-encodeBase64** — capture
   before consumers can observe a tampered state.
2. **§Before-SES-lockdown-freezes-the-prototype** — capture
   while the prototype is still mutable (so the captured value
   is the *real* native method, not a SES tamed version).
3. **§Post-lockdown-mutation-cannot-redirect-the-dispatched-
   binding** — the const reference is immutable after capture.

§The-three-properties-form-the-§module-load-detection-window
discipline. §Cycle-180-hex-package-named-this as §native-
fallthrough-detection-bound-once-at-module-load; §reading-this-
source shows the exact pattern.
