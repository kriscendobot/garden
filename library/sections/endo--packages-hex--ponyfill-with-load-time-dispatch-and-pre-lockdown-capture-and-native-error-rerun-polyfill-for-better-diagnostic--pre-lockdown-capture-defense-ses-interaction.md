---
title: §Pre-lockdown-capture defense (SES interaction)
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

The README and source comments explain why the load-time capture matters under SES:

> Capture the native TC39 `Uint8Array.prototype.toHex` intrinsic at module load, before any caller can reach `encodeHex` and before SES lockdown freezes the prototype. Post-lockdown mutation cannot redirect the dispatched binding.

§Capture-pre-lockdown-then-rely-on-immutability is the same shape `@endo/env-options` (cycle 207) uses for primordials capture, and the same shape the [SES error-handling cluster](endo--packages-ses-src-error-tame-v8-error-constructor-js) uses. The eleventh §SES-defense-family member in the library: §race-against-lockdown-to-snapshot-intrinsics + §post-lockdown-freezing-makes-the-snapshot-load-bearing.
