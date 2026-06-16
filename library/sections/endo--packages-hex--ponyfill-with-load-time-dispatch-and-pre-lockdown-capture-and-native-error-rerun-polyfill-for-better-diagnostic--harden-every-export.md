---
title: §Harden-every-export
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

```js
harden(jsEncodeHex);
harden(jsDecodeHex);
harden(encodeHex);
harden(decodeHex);
```

§Every-exported-function-is-hardened — the polyfills, the dispatched defaults, all four. §Belt-and-braces-against-tampering even for the polyfills (which §don't-need-to-be-hard-for-security but §are-hard-for-consistency-with-the-public-API).
