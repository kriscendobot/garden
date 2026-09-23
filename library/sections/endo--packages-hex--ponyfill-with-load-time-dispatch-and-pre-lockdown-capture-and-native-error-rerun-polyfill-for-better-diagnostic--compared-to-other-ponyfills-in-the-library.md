---
title: §Compared to other ponyfills in the library
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

| Cycle | Package | Native intrinsic | Shape |
| --- | --- | --- | --- |
| 197 | @endo/panic | `Error.prototype.stack` | §three-layer-dispatch-chain-as-imperfect-ponyfill |
| 201 | @endo/immutable-arraybuffer | `ArrayBuffer.prototype.transferToImmutable` | §ponyfill+shim + §race-to-install-detect-only |
| 215 | @endo/hex | `Uint8Array.{toHex,fromHex}` | §ponyfill-with-load-time-dispatch + §native-error-rerun-polyfill |

§Three-different-ponyfill-shapes-in-the-library family — a new sibling to the existing §three-canonical-uncurry-shapes, §three-utility-cluster-shapes, and §three-runtime-version-compat-hacks meta-clusters.
