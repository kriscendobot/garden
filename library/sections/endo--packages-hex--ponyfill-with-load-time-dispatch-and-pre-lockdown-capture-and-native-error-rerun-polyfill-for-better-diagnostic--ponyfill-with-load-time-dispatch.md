---
title: §Ponyfill-with-load-time-dispatch
source-slug: endo--packages-hex
section-id: ponyfill-with-load-time-dispatch-and-pre-lockdown-capture-and-native-error-rerun-polyfill-for-better-diagnostic
url: https://github.com/endojs/endo/blob/master/packages/hex/src/
authors: [Endo contributors]
repo: endojs/endo
path: packages/hex/src/
status: shipping
ingest-cycle: 215
ingest-date: 2026-06-07
lane: chat
parent: endo--packages-hex--ponyfill-with-load-time-dispatch-and-pre-lockdown-capture-and-native-error-rerun-polyfill-for-better-diagnostic
---

The §dispatch-decision-is-made-once-at-module-load — both `encode.js` and `decode.js` read the native intrinsic at top level:

```js
const toHex = /** @type {any} */ (Uint8Array.prototype).toHex;
const nativeToHex =
  typeof toHex === 'function' ? /** @type {() => string} */ (toHex) : undefined;

export const encodeHex =
  nativeToHex !== undefined
    ? bytes => apply(nativeToHex, bytes, [])
    : jsEncodeHex;
```

The §exported-binding-is-set-once at module evaluation; no per-call branching, no post-load reconfiguration. §The-public-API-is-just-encodeHex / `decodeHex`; the pure-JS fallbacks `jsEncodeHex` / `jsDecodeHex` are §also-exported-for-benchmarking-and-for-environments-without-the-native-intrinsic (e.g. SES-locked-down compartments that have explicitly removed the intrinsic).
