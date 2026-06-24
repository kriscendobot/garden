---
title: "@endo/hex — §Ponyfill-with-load-time-dispatch + §Pre-lockdown-capture + §Native-error-rerun-polyfill-for-better-diagnostic"
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

`@endo/hex` exposes `encodeHex(bytes): string` and `decodeHex(string, name?): Uint8Array` as a §ponyfill for the TC39 `Uint8Array.prototype.toHex` / `Uint8Array.fromHex` intrinsics (proposal-arraybuffer-base64, Stage 4). Two source files, 172 total lines. The design choices below are the §SES-aware-and-benchmark-aware-and-diagnostic-aware reasons the package is larger than "just convert bytes."
