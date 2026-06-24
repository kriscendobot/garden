---
title: §Three-different-ponyfill-shapes summary table
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

| Property | @endo/panic | @endo/immutable-arraybuffer | @endo/hex |
| --- | --- | --- | --- |
| Public API | `panic(error)` | `transferToImmutable`, `sliceToImmutable` | `encodeHex`, `decodeHex` |
| Dispatch | three-layer chain | race-to-install-detect-only | load-time intrinsic capture |
| Error path | log + exit | throw new TypeError | §native-rerun-polyfill |
| Why ponyfill | host engine variance | proposal not yet Stage 4 | §Stage-4-but-not-yet-everywhere |
