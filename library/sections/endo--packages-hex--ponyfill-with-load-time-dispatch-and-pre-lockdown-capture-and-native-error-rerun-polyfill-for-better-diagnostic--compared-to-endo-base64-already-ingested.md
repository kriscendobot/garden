---
title: §Compared to @endo/base64 (already ingested)
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

| Aspect | @endo/base64 (cycle 7) | @endo/hex (cycle 215) |
| --- | --- | --- |
| Status | Pre-TC39-proposal native intrinsics | §ponyfill-for-Stage-4-proposal |
| Dispatch | Pure JS only (no native fallback) | §load-time-dispatch-to-native-when-present |
| Diagnostic | Throws on invalid chars (no offset) | §precise-offset-diagnostic + §name-parameter |
| Errors path | Single implementation | §double-decode-on-native-error |

§Two-different-binary-encoding-utility-shapes-in-the-same-library-family. The §evolution-from-base64-to-hex tracks the §TC39-proposal-arraybuffer-base64-Stage-4 stabilization.
